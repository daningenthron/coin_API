require 'rails_helper'

RSpec.describe 'Coin API', type: :request do
  let!(:coins) { create_list(:coin, 10) }
  let(:coin_id) { coins.first.id }

  # View all Coins (GET /coins)
  describe 'GET /coins' do
    before { 'get /coins' }

    it 'returns coins' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Show Coin (GET /coins/:id)
  describe 'GET /coins/:id' do
    before { "get /coins/#{id}" }

    context 'when the coin exists' do
      it 'returns the coin' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(coin_id)
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
      before { post '/coins', params: valid_attributes }

      it 'creates a coin' do
        expect(json['value']).to eq('1')
      end

      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request is invalid' do
      context 'when value is under 5' do
        before { post '/coins', params: { value: 4 } }

        it 'returns status 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/not a valid coin value/)
        end
      end

      context 'when value is over 5' do
        it 'returns an additional message' do
          expect(response.body).to match(/one coin at a time/)
        end
      end
    end
  end

  # Update coin attributes (PUT /coins/:id)
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { value: 25 } }

    context 'when the coin exists' do
      before { put "/todos/#{id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the coin does not exist' do
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
    before { delete "/coins/#{id}" }

    it 'returns status 204' do
      expect(response).to have_http_status(204)
    end
  end
end