json.array! @events do |event|
  json.name event.name
  json.is_broadcast event.bot_instance != nil
  # Unfortunately, it doesn't look like there's a non-hacky way to directly inject JSON into a response
  json.headers JSON.parse event.headers
  json.content event.content
end
