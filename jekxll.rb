ruby -rubygems -e 'require "jekyll-import";
JekyllImport::Importers::WordpressDotCom.run({
  "source" => "youdidwhatwithtsqlcom.wordpress.2021-03-13.xml",
  "no_fetch_images" => false,
  "assets_folder" => "assets/images"
})'
