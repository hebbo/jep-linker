require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'creation' do
    it 'generates an access token' do
      user = FactoryBot.create(:user)
      expect(user.access_token).to_not be(nil)
    end
  end
end
