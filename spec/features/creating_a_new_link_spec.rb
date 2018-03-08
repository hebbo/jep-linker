require 'rails_helper'

RSpec.feature "Creating a new link" do
  let(:user) { FactoryBot.create(:user) }

  context 'when user is logged in' do
    scenario "successfully creates a new link" do
      login_as(user, :scope => :user)
      visit "/"
      fill_in "Long URL", with: "http://ryanbigg.com/2016/04/hiring-juniors"
      click_button "Shorten"
      link = Link.last
      expect(page).to have_content("Your short url is http://short.ly/#{link.short_url}")
    end

    scenario "shows error message if no link submitted" do
      login_as(user, :scope => :user)
      visit "/"
      click_button "Shorten"
      expect(page).to have_content("Long url can't be blank")
    end

    scenario "shows an error message if long url is invalid" do
      login_as(user, :scope => :user)
      visit "/"
      fill_in "Long URL", with: "leftover Christmas ham"
      click_button "Shorten"
      expect(page).to have_content("Invalid URL format")
    end

    scenario "google shortening service is not allowed" do
      login_as(user, :scope => :user)
      visit "/"
      fill_in "Long URL", with: "https://goo.gl/5PnQ4y"
      click_button "Shorten"
      expect(page).to have_content("shortening service not allowed in long URL")
    end

    scenario "bit.ly shortening service is not allowed" do
      login_as(user, :scope => :user)
      visit "/"
      fill_in "Long URL", with: "http://bit.ly/2oG0C3v"
      click_button "Shorten"
      expect(page).to have_content("shortening service not allowed in long URL")
    end
  end

  context 'when users not logged in' do
    scenario "successfully creates a new link" do
      login_as(user, :scope => :user)
      visit "/"
      fill_in "Long URL", with: "http://ryanbigg.com/2016/04/hiring-juniors"
      click_button "Shorten"
      link = Link.last
      expect(page).to have_content("Your short url is http://short.ly/#{link.short_url}")
    end

    scenario "they can sign up" do
      visit "/"
      click_link "Sign up"
      expect(current_path).to eq("/users/sign_up")
      fill_in "user_email", with: "test@test.com"
      fill_in "user_password", with: "mypassword"
      fill_in "user_password_confirmation", with: "mypassword"
      click_button "Sign up"
      expect(current_path).to eq("/")
    end
  end
end
