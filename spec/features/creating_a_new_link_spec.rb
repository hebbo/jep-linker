require 'rails_helper'

RSpec.feature "Creating a new link" do
  let(:user) { FactoryBot.create(:user) }

  context 'when user is logged in' do
    before do
      login_as(user)
    end

    scenario "successfully creates a new link" do
      visit "/"
      fill_in "Long URL", with: "http://ryanbigg.com/2016/04/hiring-juniors"
      click_button "Shorten"
      link = Link.last
      expect(page).to have_content("Your short url is http://www.example.com/#{link.short_url}")
    end

    scenario "shows error message if no link submitted" do
      visit "/"
      click_button "Shorten"
      expect(page).to have_content("Long url can't be blank")
    end

    scenario "shows an error message if long url is invalid" do
      visit "/"
      fill_in "Long URL", with: "leftover Christmas ham"
      click_button "Shorten"
      expect(page).to have_content("Invalid URL format")
    end

    scenario "google shortening service is not allowed" do
      visit "/"
      fill_in "Long URL", with: "https://goo.gl/5PnQ4y"
      click_button "Shorten"
      expect(page).to have_content("shortening service not allowed in long URL")
    end

    scenario "bit.ly shortening service is not allowed" do
      visit "/"
      fill_in "Long URL", with: "http://bit.ly/2oG0C3v"
      click_button "Shorten"
      expect(page).to have_content("shortening service not allowed in long URL")
    end
  end

  context 'when users not logged in' do
    scenario "successfully creates a new link" do
      visit "/"
      fill_in "Long URL", with: "http://ryanbigg.com/2016/04/hiring-juniors"
      click_button "Shorten"
      link = Link.last
      expect(page).to have_content("Your short url is http://www.example.com/#{link.short_url}")
    end
  end
end
