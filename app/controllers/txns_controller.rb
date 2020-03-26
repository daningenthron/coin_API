class TxnsController < ApplicationController
  # API Keys are validated in ApplicationController

  def index
    api_key_id = params[:api_key_id]
    @txns = api_key_id ? Txn.where(api_key_id: api_key_id) : @txns = Txn.all
    json_response(@txns)
  end

  def show
    @txn = Txn.find(params[:id])
    json_response(@txn)
  end

  def create
    @txn = if deposit
             Txn.create_deposit(txn_params, auth_key)
           elsif withdrawal
             Txn.create_withdrawal(txn_params, auth_key)
           else
             Txn.create!(txn_params) # to model for validation handling
           end
    @txn ? json_response(@txn) : json_response('Coin could not be found', :unprocessable_entity)
  end

  private

  def txn_params
    params.permit(:txn_type, :value, :api_key_id)
  end

  def deposit
    txn_params[:txn_type] == 'deposit'
  end

  def withdrawal
    txn_params[:txn_type] == 'withdrawal'
  end
end
