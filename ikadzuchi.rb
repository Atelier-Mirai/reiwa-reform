################################################################################
#
# 施工事例 生成モジュール
#
# reform ディレクトリ内の写真と説明文、工事情報をもとに
# 施工事例のHTMLファイルを生成する
#
################################################################################

require 'pathname'
require './construction'

module Ikadzuchi

  class << self
    # サブディレクトリごとに、generateを呼び出す
    def generate_all
      pwd = Dir.pwd
      # ディレクトリ移動
      Dir.chdir(pwd + '/source/reform')

      pwd = Pathname.pwd
      # サブディレクトリを取得する(新しい順)
      directories = []
      pwd.children(false).select(&:directory?).each do |dir|
        next if dir.to_s == "_partial"
        directories << dir.to_s
      end

      # 降順に並び替え
      directories = directories.sort { |a, b| b <=> a }

      # 施工一覧用の見出し部分を生成する
      # results_template = Ikadzuchi::template("_results_template.txt")
      results_template = Template.read("_results_template.txt")
      Ikadzuchi::write("_results.slim", results_template.head)

      # 施工一覧用
      # サムネイルの追加と各工事用のページを生成する
      directories.each do |directory|
        Ikadzuchi::generate(directory)
      end
    end

    ################################################################################
    # 工事名ディレクトリにある画像(.jpg)と、memo.csvを雛形にslimファイルを生成する
    # @param [String] construction_name 工事名称
    # @return "#{construction_name}.slim" ファイルが生成される
    ################################################################################
    def generate(directory)
      # 工事情報を読み込む
      information  = Construction.new(directory)

      # 雛形ファイルを読み込む ページネーション有効
      photos_template = Template.read("_photos_template.txt", true)

      # 施工写真用雛形を置換
      slim = Ikadzuchi::replace_with_pagination(photos_template, information)

      # 施工写真のslimを出力
      Ikadzuchi::write "#{directory}.html.slim", slim

      # 施工事例一覧に、この工事のサムネイルを追記する
      results_template = Template.read("_results_template.txt")
      thumbnail_slim   = Ikadzuchi::replace(results_template.body, information.head)
      thumbnail_slim   = thumbnail_slim.gsub("\#{directory}", information.directory)
      Ikadzuchi::append "_results.slim", thumbnail_slim
    end

    ################################################################################
    # ページネーションを出力する
    # « ‹ 8 9 10 11 12 13 14 › »
    # @params [Integer] current_page: 現在の頁数
    # @params [Integer] total_pages:  総頁数
    # @params [Integer] window:       前後にいくつの頁を表示させるか？
    ################################################################################
    def pagination(current_page:, total_pages:, window: 3)
      # 一頁しかないなら、ページネーション不要
      return "" if current_page == 1 && total_pages == 1

      pagination = ""
      if current_page != 1
        pagination << <<~EOH
          li.page-item
            a href="\#page1" &laquo;
          li.page-item
            a href="\#page#{current_page.pred}" &lsaquo;
        EOH
      end

      (([current_page-window, 1].max) .. [current_page+window, total_pages].min).each do |i|
        pagination << <<~EOH
          li.page-item#{i == current_page ? '.active' : ''}
            a href="\#page#{i}" #{i}
        EOH
      end

      if current_page != total_pages
        pagination << <<~"EOH"
          li.page-item
            a href="\#page#{current_page.next}" &rsaquo;
          li.page-item
            a href="\#page#{total_pages}" &raquo;
        EOH
      end

      "\n  .pagination\n" << pagination.split("\n").map { |line| "    #{line}" }.join("\n") << "\n\n"
    end

    ################################################################################
    # 指定されたディレクトリ内の画像ファイル名を返す
    # @param [String] directory 画像ファイルの置かれているディレクトリ名
    # @return [Array] 画像ファイル名
    ################################################################################
    def images(directory)
      # 画像ファイル名を取得
      Dir.glob("#{directory}/*.jpg").map { |f| File.split(f)[1] }.sort
    end

    ################################################################################
    # 指定された雛形を読み込む
    # @param [String] filename 雛形ファイル名
    # @return [Template] シングルトン
    ################################################################################
    def template(filename, pagination = false)
      Template.read(filename, pagination = false)
    end

    ################################################################################
    # 指定された備忘録を読み込む
    # @param [String] filanem 備忘録のファイル名
    # @return [Array] 読み込んだ備忘録
    ################################################################################
    # # メモ型構造体
    # Memo = Struct.new(:caption, :comment, :image)
    #
    # def memo(directory)
    #   # 各フィールドを読み込み、arrayに格納する
    #   array = []
    #   File.read("#{directory}/_memo.csv").each_line do |line|
    #     caption, comment, image = line.chomp.split(',').map(&:strip)
    #     array << Memo.new(caption, comment, "#{directory}/#{image}")
    #   end
    #   array
    # end

    ################################################################################
    # 雛形を置換する
    # @param [String] template 雛形
    # @param [String] hash 置換用 key/value
    # @return [String] 置換後のtemplate
    ################################################################################
    def replace(template, data)
      data = data.to_h if data.kind_of? Struct
      data = data.to_h if data.kind_of? Construction

      if data.kind_of? Hash
        data&.each do |key, value|
          template = template.gsub("\#{#{key}}", value.to_s)
        end
      end
      template
    end

    ################################################################################
    # 工事写真用雛形を置換することによって、各工事の施行写真が納められたslimファイルを生成する
    # @param  [String]  template 雛形
    # @param  [Hash]    info 工事情報
    # @param  [String]  array 置換用 key/value hashの配列
    # @return [String]  置換後のtemplate
    ################################################################################
    def replace_with_pagination(photos_template, information)

      per_page = 12 # 一頁に12枚の写真を表示する
      current_page = 1
      total_pages  = (information.body.count / per_page.to_f).ceil

      # 施工写真達の先頭に工事名称生成
      slim = Ikadzuchi::replace(photos_template.head, information.head)
      slim << "\n"

      information.body.each.with_index(1) do |memo, i|
        # ページ先頭であれば、.active 付与
        active = current_page == 1 ? '.active' : ''

        # 施工写真達の先頭にページネーション生成
        if i % per_page == 1
          slim << "\#page#{current_page}.page-content#{active}\n"
          slim << pagination(current_page: current_page, total_pages: total_pages)
        end

        # 真ん中の写真達
        slim << Ikadzuchi::replace(photos_template.body, memo)

        # 施工写真達の末尾にページネーション生成
        if i % per_page == 0
          slim << pagination(current_page: current_page, total_pages: total_pages)
          current_page += 1
        end
      end

      # 最終頁の末尾にページネーション生成
      if per_page * total_pages != information.body.count
        slim << pagination(current_page: current_page, total_pages: total_pages)
      end
      slim
    end

    ################################################################################
    # ファイルを読み込む
    # @params [String] filename
    ################################################################################
    def read(filename)
      File.read filename
    end

    ################################################################################
    # ファイルを出力する
    # @params [String] filename
    # @params [String] text
    ################################################################################
    def write(filename, text)
      File.write filename, text
    end

    ################################################################################
    # ファイルに追記する
    # @params [String] filename
    # @params [String] text
    ################################################################################
    def append(filename, text)
      File.open(filename, "a") do |f|
        f.puts text
      end
    end

    ################################################################################
    # 文字数制限を行う
    # @params [String] text
    # @params [Integer] limit
    ################################################################################
    def clamp(text, limit)
      return if text.nil?
      if text.size >= limit
        text = text[0...limit] + "…"
      end
      text
    end
  end
end

################################################################################
#
# シングルトンクラスの実装
#
################################################################################
require 'singleton'
class Template
  include Singleton
  attr_accessor :head, :body, :all

  def initialize
    @template = ""
  end

  class << self
    def read(filename, pagination = false)
      template        = Template.instance
      template.all    = ""
      template.head = ""
      template.body   = ""

      # テンプレートファイルを読み込む
      t = File.read filename

      mode = :head
      t.each_line do |line|
        template.all << line
        # 改行までがhead 改行後がbody
        if line =~ /^\R/
          mode = :body
          next
        end
        case mode
        when :head
          template.head << line
        when :body
          template.body << line
        end
      end

      if pagination
        # 行頭に二つ半角空白を附与
        str = ""
        template.body.each_line do |line|
          str << "  #{line}"
        end
        template.body = str
      end

      # #BLANKLINE を 空白文字に置換
      template.all  = template.all.gsub("#BLANKLINE", "")
      template.head = template.head.gsub("#BLANKLINE", "")
      template
    end
  end
end
