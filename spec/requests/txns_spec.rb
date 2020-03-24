require 'rails_helper'

RSpec.describe 'Transaction API', type: :request do
  let!(:api_key) { create(:api_key, key_str: 'test_key') }
  let(:api_key_id) { api_key.id }
  let(:key_str) { api_key.key_str }
  let!(:coins) { create_list(:coin, 2, value: 10) }
  let(:coin_id) { coins.first.id }
  let(:headers) { { 'X-Api-Key': key_str } }

  describe 'with valid api key' do
    # View all transactions (GET /txns)
    let!(:txns) { create_list(:txn, 2, coin_id: coin_id, api_key_id: api_key_id) }

    describe 'GET /txns' do
      before { get '/txns', headers: headers }

      it 'returns transactions' do
        expect(json).not_to be_empty
        expect(json.size).to eq(2)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    # Show transaction (GET /txns/:id)
    let(:txn) { create(:txn, coin_id: coin_id, api_key_id: api_key_id) }
    let(:txn_id) { txn.id }

    describe 'GET /txns/:id' do
      before { get "/txns/#{txn_id}", headers: headers }

      context 'when the transaction exists' do
        it 'returns the transaction' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(txn_id)
        end

        it 'returns status 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the transaction does not exist' do
        let(:txn_id) { 99 }

        it 'returns status 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Txn/)
        end
      end
    end

    # Create a deposit (POST /txns)
    describe 'POST /txns (deposit)' do
      let(:valid_attributes) { { value: 5, txn_type: 'deposit' } }

      context 'when the request is valid' do
        before { post '/txns', params: valid_attributes.merge(coin_id: coin_id), headers: headers }

        it 'creates a coin' do
          expect(json['coin_id']).not_to be_nil
        end

        it 'creates a transaction' do
          expect(json['id']).to eq(3)
        end

        it 'returns status 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the amount is invalid' do
        before { post '/txns', params: valid_attributes.merge(value: 3), headers: headers }

        it 'returns status 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/not a valid coin value/)
        end
      end

      context 'when the transaction type is invalid' do
        before { post '/txns', params: valid_attributes.merge(txn_type: 'bad_type'), headers: headers }

        it 'returns status 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Not a valid transaction type/)
        end
      end
    end

    # Create a withdrawal
    describe 'Post /txns (withdrawal)' do
      let(:valid_attributes) { { value: 10, txn_type: 'withdrawal' } }
      let(:value) { valid_attributes.value }
      let(:coin) { coins.find_by(value: value) }

      context 'when the request is valid' do
        before { post '/txns', params: valid_attributes, headers: headers }

        it 'destroys a coin' do
          expect(json['coin_id']).not_to be_nil
        end

        it 'creates a transaction' do
          expect(json['id']).to eq(4)
        end

        it 'returns status 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when there is not a matching coin' do
        before { post '/txns', params: valid_attributes.merge(value: 25), headers: headers }
      end
    end
  end

  describe 'with invalid api key' do
    let(:headers) { { 'X-Api-Key': 'bad_key' } }

    context 'does not authorize GET/txns' do
      before { get '/txns', headers: headers }
      
      it 'returns status 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns an invalid API key message' do
        expect(response.body).to match(/not a valid API key/)
      end
    end

    context 'does not authorize POST/txns' do
      let(:valid_attributes) { { value: 5, txn_type: 'deposit' } }

      before { post '/txns', params: valid_attributes.merge(coin_id: coin_id), headers: headers }

      it 'returns status 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns an invalid API key message' do
        expect(response.body).to match(/not a valid API key/)
      end
    end
  end
end
