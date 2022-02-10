json.extract! gallery, :id, :name, :file, :image_type, :order, :owner_id, :owner_type, :created_at, :updated_at
json.url gallery_url(gallery, format: :json)
