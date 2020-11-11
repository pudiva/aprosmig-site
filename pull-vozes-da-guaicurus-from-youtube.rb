# you'll need an youtube API KEY:
# export YT_API_KEY="badbadbadbadbadbadbadbadbad"

require "active_support"
require "active_support/core_ext"
require "byebug"
require "yaml"
require "yt"

list = Yt::Playlist.new id: "PLOVo8bItdVh8_IQfEZVGdrBNhWQNI8JiZ"
list.playlist_items.map do |entry|
  next unless entry.public?
  image = entry.snippet.thumbnails["maxres"]
  upload_time = entry.published_at.in_time_zone("America/Sao_Paulo")

  out = {
    "layout" => "vozes-da-guaicurus-post",
    "title" => entry.title,
    "date" => upload_time.iso8601,
    "categories" => "vozes-da-guaicurus",
    "image" => {
      "path" => image["url"],
      "width" => image["width"],
      "height" => image["height"],
    },
    "video" => {
      "path" => "https://www.youtube.com/embed/#{entry.video_id}?rel=0",
      "type" => "text/html",
      "width" => image["width"],
      "height" => image["height"],
    },
    "seo" => {
      "type" => "CreativeWork",
    },
  }

  File.open("_posts/#{upload_time.to_date.iso8601}-#{entry.title.parameterize}.md", "w") do |fp|
    fp.puts YAML.dump(out)
    fp.puts "---"
    fp.puts entry.description
  end
end
