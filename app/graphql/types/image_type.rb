# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    field :id, ID, null: false
    # This data must be encoded as UTF-8
    # TODO: move back to Cloudinary
    # field :data, String, null: false
  end
end
