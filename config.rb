# 自動再読み込み
activate :livereload

# 相対URLを使う
activate :relative_assets

# ベンダープリフィックス付与
activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# レイアウト
set :layout, 'site'
page 'index.html', layout: 'top'
page 'no_layout.html', layout: false

# ビルド時の設定
configure :build do
  # HTML 圧縮
  activate :minify_html
  # CSS 圧縮
  activate :minify_css
  # # JavaScript 圧縮
  activate :minify_javascript
  # # イメージ 圧縮
  activate :imageoptim
  # アセットファイルの URL にハッシュを追加
  # activate :asset_hash
end

# Slim の設定
set :slim, {
  # デバック用に html をきれいにインデントし属性をソートしない
  # pretty: true, sort_attrs: false,

  # 属性のショートカット
  # Slim コード中、「&text name="user"」と書くと、
  # <input type="text" name="user"> とレンダリングされる。
  shortcut: {'&' => {tag: 'input', attr: 'type'}, '#' => {attr: 'id'}, '.' => {attr: 'class'}}
}
