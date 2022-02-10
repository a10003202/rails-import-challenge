json.set! :data do
  json.array! @galleries do |gallery|
    json.partial! 'galleries/gallery', gallery: gallery
    json.url  "
              #{link_to 'Show', gallery }
              #{link_to 'Edit', edit_gallery_path(gallery)}
              #{link_to 'Destroy', gallery, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end