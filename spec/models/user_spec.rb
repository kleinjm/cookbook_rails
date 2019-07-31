# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it do
    is_expected.
      to have_many(:tag_groups).dependent(:destroy).inverse_of(:user)
  end
end
