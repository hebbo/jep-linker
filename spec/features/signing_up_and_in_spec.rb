require 'rails_helper'

RSpec.feature "Signing in and up" do
  let(:user) { FactoryBot.create(:user) }

  context 'when users not logged in' do
    scenario "they can sign up" do
      visit "/"
      click_link "Sign up"
      expect(current_path).to eq("/users/sign_up")
      fill_in "user_email", with: "test@test.com"
      fill_in "user_password", with: "mypassword"
      fill_in "user_password_confirmation", with: "mypassword"
      click_button "Sign up"
      expect(current_path).to eq("/")
      expect(page).to have_content("Welcome! You have signed up successfully")
    end

    scenario "they can sign in" do
      visit "/"
      click_link "Sign up"
      expect(current_path).to eq("/users/sign_up")
      fill_in "user_email", with: "test@test.com"
      fill_in "user_password", with: "mypassword"
      fill_in "user_password_confirmation", with: "mypassword"
      click_button "Sign up"
      expect(current_path).to eq("/")
      expect(page).to have_content("Welcome! You have signed up successfully")
      click_link "Logout"

      click_link "Sign in"
      expect(current_path).to eq("/users/sign_in")
      fill_in "user_email", with: "test@test.com"
      fill_in "user_password", with: "mypassword"
      click_button "Log in"
      expect(page).to have_content("No links yet!")
    end
  end
end
