# frozen_string_literal: true

namespace :one_offs do
  desc "Import a bookmark page from Chrome (may not be one-off in the future)"
  task import_chrome_bookmarks: :environment do
    require "nokogiri"

    # Script to import bookmarks from Chrome
    # This script assumes that you've removed any unwanted bookmarks
    user = User.find_by(email: "kleinjm007@gmail.com")
    raise "Cannot find user" unless user

    page = Nokogiri::HTML(open("lib/chrome_bookmarks/bookmarks_5_16_17.html"))
    page.css("a").each do |bookmark|
      Bookmark.find_or_create_by(
        name: bookmark.text, link: bookmark.values.first, user: user
      )
    end
  end
end
