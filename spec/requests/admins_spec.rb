require 'rails_helper'

RSpec.describe 'Admin API', type: :request do
  let!(:admins) { create_list(:admin, 2) }
  let(:admin_id) { admins.first.id }
  let(:api_key) { create(:api_key, key_str: 'test_key') }
  let(:key_str) { api_key.key_str }
  let(:api_key_id) { api_key.id }
  let(:headers) { { 'X-Api-Key': key_str } }

  # View all admins (GET /admins)
  describe 'GET /admins' do
    before { get '/admins', headers: headers }

    it 'returns admins' do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Show admin (GET /admins/:id)
  describe 'GET /admins/:id' do
    before { get "/admins/#{admin_id}", headers: headers }

    it 'returns the admin' do
      expect(json['id']).to eq(admin_id)
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Create admin (POST /admins)
  describe 'POST /admins' do
    let(:valid_attributes) { { name: 'Admin', email: 'email@example.com' } }

    context 'when the request is valid' do
      before { post '/admins', params: valid_attributes, headers: headers }

      it 'creates the admin' do
        expect(json['email']).to eq('email@example.com')
      end

      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is not valid' do
      before { post '/admins', params: { name: 'Admin' }, headers: headers }

      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/can\'t be blank/)
      end
    end
  end

  # Update admin attributes (PUT /admins/:id)
  describe 'PUT /admins/:id' do
    let(:valid_attributes) { { email: 'new_email@example.com' } }

    context 'when request is valid' do
      before { put "/admins/#{admin_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when request is not valid' do
      before { put "/admins/#{admin_id}", params: { email: 'bad_email' }, headers: headers }

      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Update failed/)
      end
    end

    context 'when record does not exist' do
      before { put '/admins/99', params: valid_attributes, headers: headers }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Admin/)
      end
    end
  end

  # Delete admin (DELETE /admins/:id)
  describe 'DELETE /admins/:id' do
    before { delete "/admins/#{admin_id}", headers: headers }

    it 'returns status 204' do
      expect(response).to have_http_status(204)
    end
  end
end
