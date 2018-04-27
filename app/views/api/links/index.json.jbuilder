json.array! @links do |link|
  json.id link.id
  json.short_url link.short_url
  json.long_url link.long_url
end
