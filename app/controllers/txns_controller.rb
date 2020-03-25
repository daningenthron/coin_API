class TxnsController < ApplicationController
  # API Keys are validated in ApplicationController

  def index
    @txns = Txn.all
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
    params.permit(:txn_type, :value)
  end

  def deposit
    txn_params['txn_type'] == 'deposit'
  end

  def withdrawal
    txn_params['txn_type'] == 'withdrawal'
  end
end
