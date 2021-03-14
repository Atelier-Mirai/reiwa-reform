################################################################################
#
# カード型データベースクラス
#
################################################################################
require 'pry'

module M
  HASH = {
    '工事名称': :name,
    '工事開始日': :started,
    '工事完了日': :ended,
    '工事概要': :outline,
    '工事種別': :kinds_pretty,
    '工事完成写真': :photo,
    '工事現場': :site
  }

  KINDS = {
    '大規模': 'renovation',
    '簡易': 'easily',
    '台風直し': 'restore',
    '瓦・屋根': 'tile',
    '外壁': 'wall',
    'その他': 'other'
  }

  refine String do
    # '工事名称' -> ':name' に変換
    def to_symbol
       # ["工事名称", "工事開始日", "工事完了日", "工事概要", "工事種別", "工事完成写真", "工事現場"]
      if HASH.keys.map(&:to_s).include?(self)
        HASH[self.to_sym]
      elsif KINDS.keys.map(&:to_s).include?(self)
        KINDS[self.to_sym]
      elsif KINDS.values.include?(self)
        HASH.key(self).to_s
      end
    end
  end

  refine Symbol do
    # :name -> '工事名称' に変換
    def to_pretty
       # ["工事名称", "工事開始日", "工事完了日", "工事概要", "工事種別", "工事完成写真", "工事現場"]
      if HASH.values.include?(self)
        HASH.key(self).to_s
      end
    end
  end
end

class Construction
  using M

  attr_accessor :head,         # 以下の総称
                :name,         # 工事名称
                :started,      # 工事開始日
                :ended,        # 工事完了日
                :outline,      # 工事概要
                :kinds,        # 工事種別
                :kinds_pretty, # 工事種別
                :photo,        # 工事完成写真
                :site,         # 工事現場
                :directory,    # ディレクトリ

                :body         # 各施工写真の caption, comment, imageファイル名の配列


  # メモ型構造体
  Memo = Struct.new(:caption, :comment, :image)

  def initialize(data_directory)
    construction = Template.read("#{data_directory}/_information.txt")
    @head = {}
    construction.head.each_line do |line|
      k, v = line.chomp.split('：')
      @head[k.to_symbol] = v
      # instance_variable_set("@#{k.to_symbol}", v)
    end
    @head[:kinds] = M::KINDS[@head[:kinds_pretty].to_sym]

    # 各フィールドを読み込み、arrayに格納する
    array = []
    construction.body.each_line do |line|
      caption, comment, image = line.chomp.split(',').map(&:strip)
      array << Memo.new(caption, comment, "#{data_directory}/#{image}")
    end
    @body = array

    @directory = data_directory
  end

  def show
    M::HASH.each do |k, v|
      print "#{k}：", instance_variable_get("@#{v}"), "\n"
    end
    return nil
  end

  def to_h
    h = {}
    M::HASH.values.each do |v|
      h[v] = instance_variable_get("@#{v}")
    end
    h[:directory] = @directory
    h[:kinds]     = @kinds
  end

  def save(data_directory = "")
    filename = data_directory.empty? ? "_information.txt" : "#{data_directory}/_information.txt"
    File.open(filename, "w", 0755) do |f|
      M::HASH.each do |k, v|
        f.print "#{k}：", instance_variable_get("@#{v}"), "\n"
      end
    end
  end

end
