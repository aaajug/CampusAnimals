json.extract! upload, :id, :name, :image, :created_at, :updated_at
json.url upload_url(upload, format: :json)
