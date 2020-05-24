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

      # _description.csv: 工事概要と、工事現場が書かれているので、
      # 読み込んで、配列に格納する。
      # descriptions = []
      # desc = Struct.new("Desc", :outline, :site)
      # File.read('_description.csv').each_line do |line|
      #   _, b, c = line.split(',')
      #    descriptions << desc.new(b, c.chomp)
      # end
      #
      # 昇順に並び替え
      # directories = directories.sort { |a, b| a <=> b }
      #
      # # 併合開始
      # directories.each_with_index do |dir, i|
      #   c = Construction.new(dir)
      #   c.outline = descriptions[i].outline if c.outline.nil?
      #   c.site = descriptions[i].site if c.site.nil?
      #   c.save(dir)
      # end

      # 降順に並び替え
      directories = directories.sort { |a, b| b <=> a }

      # 施工一覧用の見出し部分を生成する
      results_template = Ikadzuchi::template("_results_template.txt", pagination: false)
      slim = Ikadzuchi::replace(results_template.header, {})
      Ikadzuchi::write "_results.slim", slim

      # 施工一覧用 サムネイルの追加と
      # 各工事用のページを生成する
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
      # 雛形ファイルを読み込む
      photos_template = Ikadzuchi::template("_photos_template.txt", pagination: true)
      # 画像を読み込む
      images = Ikadzuchi::images(directory)
      # 備忘録を読み込む
      memo = Ikadzuchi::memo("#{directory}/_memo.csv")
      # 工事情報を読み込む
      info = Ikadzuchi::info("#{directory}/_information.txt")
      info[:construction_photo] = images.last if info[:construction_photo]&.empty?

      # 画像ファイル名の処理
      if memo.first.keys.include?(:image)
        # memoにimageファイル名まで記されているなら、.jpgを付与
        images_with_memo = memo
        images_with_memo.each do |m|
          m[:image] += ".jpg" unless m[:image].include? ".jpg"
        end
      else
        # 画像ファイル名を取得し、memoと併合する
        images_with_memo = images.map.with_index do |image, i|
          if !image.nil? && !memo[i].nil?
            { image: image }.merge memo[i]
          end
        end
        # メモより画像が多いとき、余分なhtmlが出力されるので、対策
        images_with_memo.compact!
      end
      # サブディレクトリ名付与
      images_with_memo.each do |m|
        m[:image] = "#{directory}/#{m[:image]}"
      end

      # 頁を付与
      slim = Ikadzuchi::replace_with_pagination(photos_template, info, images_with_memo, 12)

      # 施工写真達のslimを出力
      Ikadzuchi::write "#{directory}.html.slim", slim

      # 施工事例 一覧の生成
      results_template = Ikadzuchi::template("_results_template.txt", pagination: false)

      # サムネイル用slimを追記する
      info[:directory] = directory
      slim = Ikadzuchi::replace(results_template.body, info)
      Ikadzuchi::append "_results.slim", slim
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
      # Dir.glob("*.jpg").sort.map { |f| File.split(f)[1] }.sort
    end


    ################################################################################
    # 指定された雛形を読み込む
    # @param [String] filename 雛形ファイル名
    # @return [Template] シングルトン
    ################################################################################
    def template(filename, pagination)
      Template.read(filename, pagination)
    end


    ################################################################################
    # 指定された備忘録を読み込む
    # @param [String] filanem 備忘録のファイル名
    # @return [Array] 読み込んだ備忘録
    ################################################################################
    def memo(filename)
      # カラム名の読み込み
      column_names = []
      memo = File.read filename
      # return memo
      memo.each_line do |line|
        # 先頭行はカラム名なので読み取る
        column_names = line.chop.tr('"', '').tr("'", '').tr(" ", "").split(',')
        break
      end

      array = []
      # 各フィールドを読み込み、arrayに格納する
      memo.each_line.with_index do |line, i|
        next if i == 0 # 先頭行はカラム名なので読み飛ばす

        columns = line.chop.tr('"', '').tr("'", '').tr(" ", "").split(',').map(&:strip)
        hash = {}
        column_names.each_with_index do |c, i|
          hash.store column_names[i].to_sym, columns[i].to_s
        end
        array.push hash
      end
      array
    end


    ################################################################################
    # 指定された工事情報を読み込む
    # @param [String] filanem 工事情報のファイル名
    # @return [Hash] 読み込んだ工事情報
    ################################################################################
    def info(filename)
      hash = {
        name:    "",
        started: "",
        ended:   "",
        period:  "",
        outline: "",
        kinds:   "other",
        photo:   "",
        site:    ""
      }

      h = {
        '工事名称': :name,
        '工事開始日': :started,
        '工事完了日': :ended,
        '工事概要': :outline,
        '工事種別': :kinds,
        '工事完成写真': :photo,
        '工事現場': :site
      }

      kinds = {
        '大規模': 'renovation',
        '簡易': 'easily',
        '台風直し': 'restore',
        '瓦・屋根': 'tile',
        '外壁': 'wall',
        'その他': 'other'
      }

      info = File.read filename
      info.each_line do |line|
        key, value = line.chop.tr('：', ':').split(':')
        case key
        when '工事名称', '工事開始日', '工事完了日', '工事概要'
          hash[h[key.to_sym]] = value.to_s
        when '工事種別'
          # 工事種別は複数指定されるときもあるので
          class_names = []
          values = value&.tr('、', ',')&.split(',')
          values&.each { |v| class_names.push kinds[v.to_sym] }
          hash[:kinds] = if class_names.empty?
                                        'other'
                                      else
                                        class_names.join
                                      end
        when '工事完成写真'
          if !value.nil? && !value.include?('.jpg')
            value << '.jpg'
          end
          hash[h[key.to_sym]] = value.to_s
        when '工事現場'
          hash[:site] = value
        end
      end
      # 工事期間
      hash[:period] = "#{hash[:started]} 〜 #{hash[:ended]}"
      hash
    end


    ################################################################################
    # 雛形を置換する
    # @param [String] template 雛形
    # @param [String] hash 置換用 key/value
    # @return [String] 置換後のtemplate
    ################################################################################
    def replace(template, hash)
      hash&.each do |key, value|
        template = template.gsub("\#{#{key}}", value.to_s)
      end
      template
    end


    ################################################################################
    # 雛形を置換する
    # @param  [String]  template 雛形
    # @param  [Hash]    info 工事情報
    # @param  [String]  array 置換用 key/value hashの配列
    # @param  [Integer] per_page  一頁に何枚の写真を表示させるか
    # @return [String]  置換後のtemplate
    ################################################################################
    def replace_with_pagination(template, info, images_with_memo, per_page = 12)
      current_page = 1
      total_pages = (images_with_memo.count / per_page.to_f).ceil
      # 施工写真達の先頭に工事名称生成
      slim = Ikadzuchi::replace(template.header, info)
      slim << "\n"

      images_with_memo.each.with_index(1) do |e, i|
        if i % per_page == 1
          slim << "\#page#{current_page}.page-content#{ current_page == 1 ? '.active' : '' }\n"
        end

        # 施工写真達の先頭にページネーション生成
        if i % per_page == 1
          slim << pagination(current_page: current_page, total_pages: total_pages)
        end

        slim << Ikadzuchi::replace(template.body, e)

        # 施工写真達の末尾にページネーション生成
        if i % per_page == 0
          slim << pagination(current_page: current_page, total_pages: total_pages)
          current_page += 1
        end
      end
      # 最終頁の末尾にページネーション生成
      if per_page * total_pages != images_with_memo.count
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
  attr_accessor :header, :body, :all

  def initialize
    @template = ""
  end

  class << self
    def read(filename, pagination)
      template        = Template.instance
      template.all    = ""
      template.header = ""
      template.body   = ""

      # テンプレートファイルを読み込む
      t = File.read filename

      mode = :header
      t.each_line do |line|
        template.all << line
        # 改行までがheader 改行後がbody
        if line =~ /^\R/
          mode = :body
          next
        end
        case mode
        when :header
          template.header << line
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
      template
    end
  end
end
