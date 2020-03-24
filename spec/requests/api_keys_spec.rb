require 'rails_helper'

RSpec.describe 'Api_Keys API', type: :request do
  let!(:api_keys) { create_list(:api_key, 2) }
  let(:api_key_id) { api_keys.first.id }
  let(:key_str) { api_keys.first.key_str }
  let(:headers) { { 'X-Api-Key': key_str } }

  # View all API keys ( GET /api_keys)
  describe 'GET /api_keys' do
    before { get '/api_keys', headers: headers }

    it 'returns API keys' do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Show API key (GET /api_keys/:id)
  describe 'GET /api_keys/:id' do
    before { get "/api_keys/#{api_key_id}", headers: headers }

    context 'when the api key exists' do
      it 'returns the api key' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(api_key_id)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the api key does not exist' do
      let(:api_key_id) { 99 }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find ApiKey/)
      end
    end
  end

  # Create api key (POST /api_keys)
  describe 'POST /api_keys' do
    let(:valid_attributes) { { email: Faker::Internet.email } }

    context 'when request is valid' do
      before { post '/api_keys', params: valid_attributes, headers: headers }

      it 'returns the record' do
        expect(json).not_to be_empty
      end

      it 'creates an api key' do
        expect(json['key_str']).not_to be(nil)
      end

      it 'defaults to non-admin' do
        expect(json['admin']).to be(false)
      end

      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request is invalid' do
      before { post '/api_keys', params: { email: 'bad_email' }, headers: headers }

      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Email is invalid/)
      end
    end
  end

  # Update api key attributes (PUT /api_keys/:id)
  describe 'PUT /api_keys/:id' do
    let(:valid_attributes) { { admin: true } }

    context 'when the api key exists' do
      before { put "/api_keys/#{api_key_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the api key does not exist' do
      before { put '/api_keys/99', params: valid_attributes, headers: headers }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find ApiKey/)
      end
    end
  end

  # Delete an api key (DELETE /api_keys/:id)
  describe 'DELETE /api_keys/:id' do
    before { delete "/api_keys/#{api_key_id}", headers: headers }

    it 'returns status 204' do
      expect(response).to have_http_status(204)
    end
  end
end
