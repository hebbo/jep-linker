require 'rails_helper'

RSpec.feature "Visiting a short link" do
  let(:long_url) { "https://ryanbigg.com/2018/03/hiring-juniors" }
  let(:user) { FactoryBot.create(:user) }

  scenario "user is redirected to external site", js: true do
    login_as(user, :scope => :user)
    visit "/"
    fill_in "Long URL", with: long_url
    click_button "Shorten"
    link = Link.last
    visit "/#{link.short_url}"
    expect(current_url).to eq(long_url)
  end
end
