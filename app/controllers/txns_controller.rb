class TxnsController < ApplicationController
  def index
    @txns = Txn.all
    json_response(@txns)
  end

  def show
    @txn = Txn.find(params[:id])
    json_response(@txn)
  end

  def create
    @coin = Coin.create(value: txn_params['value'], name: Coin.coin_name(txn_params))
    @txn = Txn.create!(txn_params.merge(coin_id: @coin.id, api_key_id: auth_key.id))
    @coin.save
    json_response(@txn)
  end

  private

  def txn_params
    params.permit(:txn_type, :value, :api_key_id)
  end
end
