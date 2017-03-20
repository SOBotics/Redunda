json.array! @bot_data do |data|
  json.key data.key
  json.created_at data.created_at
  json.updated_at data.updated_at
  json.sha256 Digest::SHA256.hexdigest(data.data)
end
