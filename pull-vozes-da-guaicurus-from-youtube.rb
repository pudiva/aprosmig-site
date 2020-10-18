require "json"
require "yaml"
require 'active_support'
require 'active_support/core_ext'

jason = JSON.parse(`youtube-dl -J PLOVo8bItdVh8_IQfEZVGdrBNhWQNI8JiZ`)

jason["entries"].map do |entry|
  image = entry["thumbnails"].last
  upload_date = Date.iso8601(entry["upload_date"])

  out = {
    "layout" => "vozes-da-guaicurus-post",
    "title" => entry["title"],
    "date" => upload_date.iso8601,
    "categories" => "vozes-da-guaicurus",
    "image" => {
      "path" => image["url"],
      "width" => image["width"],
      "height" => image["height"],
    },
    "video" => {
      "path" => "https://www.youtube.com/embed/#{entry["id"]}?rel=0",
      "type" => "text/html",
      "width" => image["width"],
      "height" => image["height"]
    },
    "seo" => {
      "type" => "CreativeWork",
    },
  }

  File.open("_posts/#{upload_date.iso8601}-#{entry["title"].parameterize}.md", "w") do |fp|
    fp.puts YAML.dump(out)
    fp.puts "---"
    fp.puts entry["description"]
  end
end
