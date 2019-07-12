# frozen_string_literal: true

# cl_id has been kept on the image model in the event that we switch back to
# cloudinary. No images on the cloudinary account have been removed
class Image < ApplicationRecord
  belongs_to :recipe

  validates :recipe, presence: true
end
