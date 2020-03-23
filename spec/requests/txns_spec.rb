require 'rails_helper'

RSpec.describe 'Transaction API', type: :request do
  let(:api_key) { create(:api_key) }
  let(:api_id) { api_key.id }
  let(:key_str) { api_key.key_str }
  let(:coins) { create_list(:coin, 5, value: 10) }

  describe 'with invalid token' do
    it 'does not authorize GET /index' do
    end

    it 'does not authorize GET /show' do
    end
  end

  describe 'with valid token' do
    before(:each) { expect(key_str).to eq('test_key') }

    # View all transactions (GET /txns)
    let(:txns) { create_list(:txn, 2, api_key_id: api_id) }

    describe 'GET /txns' do
      before { get '/txns' }

      it 'returns transactions' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    # Show transaction (GET /txns/:id)
    let(:txn) { create(:txn, api_key_id: api_id) }
    let(:txn_id) { txn.id }

    describe 'GET /txns/:id' do
      before { get "/txns/#{txn_id}" }

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
      let(:valid_attributes) { { value: 5, type: 'deposit', api_key: 'test_key' } }

      context 'when the request is valid' do
        before { post '/txns', params: valid_attributes }

        it 'creates a transaction' do
          expect(json['id']).not_to be_empty
        end

        it 'creates a transaction' do
          expect(json['txn_id']).not_to be_empty
        end

        it 'returns status 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the amount is invalid' do
        before { post '/txns', params: valid_attributes.merge(value: 3) }

        it 'returns status 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/not a valid coin value/)
        end
      end

      context 'when the transaction type is invalid' do
        before { post '/txns', params: valid_attributes.merge(type: 'bad_type') }

        it 'returns status 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Not a valid transaction type/)
        end
      end
    end
  end
end
