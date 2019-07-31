# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagGroup do
  it { is_expected.to belong_to(:user).inverse_of(:tag_groups) }
  it do
    is_expected.
      to have_many(:tags).dependent(:destroy).inverse_of(:tag_group)
  end
  it { is_expected.to validate_presence_of(:name) }
end
