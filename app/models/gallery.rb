class Gallery < ApplicationRecord
  belongs_to :owner, polymorphic: true
  enum image_type: { normal: 0, logo: 1, thumbnail: 2, banner: 3 }
  mount_uploader :file, GalleryUploader

  validates :owner, presence: true

  def size
    self.file.size
  end
end
