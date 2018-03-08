require 'rails_helper'

RSpec.describe Api::LinksController, type: :controller do
  describe '#index' do
    context 'no token provided' do
      let!(:link1) { FactoryBot.create(:link) }
      let!(:link2) { FactoryBot.create(:link) }
      let(:expected_links) do
        [
          {
            'id' => link1.id.to_s,
            'long_url' => link1.long_url,
            'short_url' => link1.short_url,
          },
          {
            'id' => link2.id.to_s,
            'long_url' => link2.long_url,
            'short_url' => link2.short_url,
          },
        ]
      end

      it 'returns all links' do
        get :index
        expect(response).to be_ok
        expect(response.body).to eq(expected_links.to_json)
      end
    end

    context 'token is provided' do
      let(:user) { FactoryBot.create(:user) }
      let!(:link1) { FactoryBot.create(:link) }
      let!(:link2) { FactoryBot.create(:link) }
      let!(:anonymous_link) { FactoryBot.create(:link) }
      let(:expected_links) do
        [
          {
            'id' => link1.id.to_s,
            'long_url' => link1.long_url,
            'short_url' => link1.short_url,
          },
          {
            'id' => link2.id.to_s,
            'long_url' => link2.long_url,
            'short_url' => link2.short_url,
          },
        ]
      end

      it 'returns the user links' do
        user.links << link1
        user.links << link2

        get :index, params: { access_token: user.access_token }

        expect(response).to be_ok
        expect(response.body).to eq(expected_links.to_json)
      end
    end
  end
end
