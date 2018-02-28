require 'rails_helper'

RSpec.describe '/api/status' do
  it 'is alive' do
    get '/api/status'
    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)).to eq('alive' => 'true')
  end
end
