require 'rails_helper'

RSpec.describe 'Coin API', type: :request do
  let!(:coins) { create_list(:coin, 2) }
  let(:coin_id) { coins.first.id }
  let(:key_str) { api_key.key_str }
  let(:api_key) { create(:api_key, key_str: 'test_key') }
  let(:api_key_id) { api_key.id }
  let(:headers) { { 'X-Api-Key': key_str } }

  # View all Coins (GET /coins)
  describe 'GET /coins' do
    before { get '/coins', headers: headers }

    it 'returns coins' do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Show Coin (GET /coins/:id)
  describe 'GET /coins/:id' do
    before { get "/coins/#{coin_id}", headers: headers }

    context 'when the coin exists' do
      it 'returns the coin' do
        expect(json).not_to be_empty
        expect(json['id']).to eq('1')
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the coin does not exist' do
      let(:coin_id) { 99 }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Coin/)
      end
    end
  end

  # Create coin (POST /coins)
  describe 'POST /coins' do
    let(:valid_attributes) { { value: 1 } }

    context 'when request is valid' do
      before { post '/coins', params: valid_attributes, headers: headers }

      it 'creates a coin' do
        expect(json['attributes']['value']).to eq(1)
      end

      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request is invalid' do
      before { post '/coins', params: { value: 4 }, headers: headers }

      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/not a valid coin value/)
      end
    end
  end

  # Update coin attributes (PUT /coins/:id)
  describe 'PUT /coins/:id' do
    let(:valid_attributes) { { value: 25 } }

    context 'when the coin exists' do
      before { put "/coins/#{coin_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the coin does not exist' do
      before { put '/coins/99', params: valid_attributes, headers: headers }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Coin/)
      end
    end
  end

  # Delete a coin (DELETE /coins/:id)
  describe 'DELETE /coins/:id' do
    before { delete "/coins/#{coin_id}", headers: headers }

    it 'returns status 204' do
      expect(response).to have_http_status(204)
    end
  end

  # View value of all coins (GET /coins/total)
  describe 'GET /coins/total' do
    let(:coins) { create_list(:coin, 2, value: 10, name: 'dime') }

    before { get '/coins/total', headers: headers }

    it 'returns the correct total' do
      expect(JSON.parse(response.body)['meta']['total']).to eq(20)
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end
  end
end
