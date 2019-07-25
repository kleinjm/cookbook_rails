# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  describe "validations and relations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end
end
