# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordLoader do
  describe "#perform" do
    it "calls fulfill on each record" do
      user = create(:user)

      loader = described_class.new(User)
      allow(loader).to receive(:fulfill)
      allow(loader).to receive(:fulfilled?).and_return(false)

      loader.perform([user.id])

      expect(loader).to have_received(:fulfill).with(user.id, user)
      expect(loader).to have_received(:fulfilled?).with(user.id)
      expect(loader).to have_received(:fulfill).with(user.id, nil)
    end
  end
end
