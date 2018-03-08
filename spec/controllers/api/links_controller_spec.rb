require 'rails_helper'

RSpec.describe Api::LinksController, type: :controller do
  describe '#index' do
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
end
