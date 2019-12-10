# include template
require './ikadzuchi.rb'

# 工事日 R01-11-26など
construction_date = ARGV[0]

if construction_date.nil?
  # 全ての工事の施行事例を生成
  Ikadzuchi::generate_all
else
  # 個別の工事の施行事例を生成
  Ikadzuchi::generate(construction_date)
end
