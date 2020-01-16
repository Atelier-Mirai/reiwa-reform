################################################################################
#
# 画像のリサイズ
#
# reform ディレクトリ内の写真を
# 800x532にリサイズする
#
# 参考
# ruby画像リサイズ
# https://qiita.com/wumegawa/items/e1319028be20c3f5a09c
#
################################################################################

require 'pathname'
require 'RMagick'

module Resize
  class << self
    # ディレクトリ内の画像ファイルのリサイズを行う
    def resize(directory)
      # 元のディレクトリ
      pwd = Dir.pwd
      # ディレクトリ移動
      Dir.chdir(pwd + '/' + directory)

      # フォルダー内jpgファイルのみ対象にする
      files = Dir.glob("*.jpg")

      # リサイズ
      files.each do |fileName|
        # 画像取得
        img = Magick::ImageList.new(fileName)
        # 新しいサイズへ変更
        new_img = img.resize_to_fit(800, 532)
        # 新画像保存
        new_img.write(fileName)
      end

      # 元のディレクトリに移動
      Dir.chdir(pwd)
    end
  end
end

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
p directories

directories.each do |directory|
  # 個々のディレクトリごとにリサイズ処理を行う
  Resize::resize(directory)
  # return
end
