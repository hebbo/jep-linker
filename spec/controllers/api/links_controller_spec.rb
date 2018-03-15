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
            'short_url' => link1.short_url,
            'long_url' => link1.long_url,
          },
          {
            'id' => link2.id.to_s,
            'short_url' => link2.short_url,
            'long_url' => link2.long_url,
          },
        ]
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
            'short_url' => link1.short_url,
            'long_url' => link1.long_url,
          },
          {
            'id' => link2.id.to_s,
            'short_url' => link2.short_url,
            'long_url' => link2.long_url,
          },
        ]
      end

      it 'returns the user links' do
        user.links << link1
        user.links << link2
        request.headers["Authorization"] = "token #{user.access_token}"
        get :index

        expect(response).to be_ok
        expect(response.body).to eq(expected_links.to_json)
      end

      it 'returns an error when access token is incorrect' do
        request.headers['Authorization'] = "token randomtoken"
        get :index
        expect(response.code).to eq('401')
      end
    end
  end

  describe '#create' do
    let(:post_params) do
      {
        "link": {
          "short_url": "abc123", # this field is optional
          "long_url": "https://google.com"
        }
      }
    end

    let(:expected_result) do
      {
        "link": {
          "id": "1",
          "short_url": "abc123", # this field is optional
          "long_url": "https://google.com"
        }
      }
    end

    context 'when a token is provided' do
      let(:user) { FactoryBot.create(:user) }

      context 'and short url is provided' do
        it 'creates a link' do
          request.headers["Authorization"] = "token #{user.access_token}"
          post :create, params: post_params

          expect(response.code).to eq('200')
          expect(response.body).to eq(expected_result.to_json)
        end
      end

      context 'and no short url is provided' do
        let(:post_params) do
          {
            "link": {
              "long_url": "https://google.com"
            }
          }
        end

        it 'creates a link' do
          request.headers["Authorization"] = "token #{user.access_token}"
          post :create, params: post_params

          expect(response.code).to eq('200')
          expect(JSON.parse(response.body).dig("link","long_url")).to eq("https://google.com")
        end

        # it 'creates a link twice' do
        #   request.headers["Authorization"] = "token #{user.access_token}"
        #   post :create, params: post_params

        #   expect(response.code).to eq('200')
        #   expect(JSON.parse(response.body).dig("link","long_url")).to eq("https://google.com")

        #   post :create, params: post_params

        #   expect(response.code).to eq('200')
        #   expect(JSON.parse(response.body).dig("link","long_url")).to eq("https://google.com")
        # end
      end

      context 'and wrong params are provided' do
        let(:post_params) do
          {
            "blah": {
              "foo": "bar"
            }
          }
        end

        it 'returns a 500' do
          request.headers["Authorization"] = "token #{user.access_token}"
          post :create, params: post_params

          expect(response.code).to eq('500')
          expect(response.body).to eq({link: ['is missing']}.to_json)
        end
      end
    end

    context 'when a token is wrong' do
      it 'returns an error' do
        request.headers['Authorization'] = "token randomtoken"
        post :create, params: post_params
        expect(response.code).to eq('401')
      end
    end

    context 'when a token is not provided' do
      it 'returns an error' do
        post :create, params: post_params
        expect(response.code).to eq('401')
      end
    end
  end
end
