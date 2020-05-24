################################################################################
#
# カード型データベースクラス
#
################################################################################
module M
  HASH = {
    '工事名称': :name,
    '工事開始日': :started,
    '工事完了日': :ended,
    '工事概要': :outline,
    '工事種別': :kinds,
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
        KINDS[self]
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

  attr_accessor :name,    # 工事名称
                :started, # 工事開始日
                :ended,   # 工事完了日
                :outline, # 工事概要
                :kinds,   # 工事種別
                :photo,   # 工事完成写真
                :site     # 工事現場

  HASH = {
    '工事名称': :name,
    '工事開始日': :started,
    '工事完了日': :ended,
    '工事概要': :outline,
    '工事種別': :kinds,
    '工事完成写真': :photo,
    '工事現場': :site
  }

  def initialize(data_directory)
    File.read("#{data_directory}/_information.txt").each_line do |line|
      k, v = line.chomp.split('：')
      instance_variable_set("@#{k.to_symbol}", v)
    end
  end

  def show
    HASH.each do |k, v|
      print "#{k}：", instance_variable_get("@#{v}"), "\n"
    end
  end

  def save(data_directory = "")
    filename = data_directory.empty? ? "_information.txt" : "#{data_directory}/_information.txt"
    File.open(filename, "w", 0755) do |f|
      HASH.each do |k, v|
        f.print "#{k}：", instance_variable_get("@#{v}"), "\n"
      end
    end
  end
end
