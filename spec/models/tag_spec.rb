# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tag do
  it do
    is_expected.
      to belong_to(:tag_group).inverse_of(:tags).optional
  end
end
