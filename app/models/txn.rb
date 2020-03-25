class Txn < ApplicationRecord
  belongs_to :coin, optional: true
  belongs_to :api_key, optional: true

  validates_presence_of :value, :txn_type
  validates :txn_type, inclusion: { in: %w[deposit withdrawal],
                                message: 'Not a valid transaction type. Please choose deposit or withdrawal.' }
  validates :value, inclusion: { in: [1, 5, 10, 25],
                                 message: '%{value} is not a valid coin value.' }

  def self.create_deposit(params, auth_key)
    @coin = Coin.create(value: params['value'], name: Coin.coin_name(params))
    @txn = Txn.create!(params.merge(coin_id: @coin.id, api_key_id: auth_key.id))
    @coin.save
    @txn
  end

  def self.create_withdrawal(params, auth_key)
    @coin = Coin.find_by(value: params['value'])
    if @coin
      @txn = Txn.create(params.merge(coin_id: @coin.id, api_key_id: auth_key.id))
      @coin.destroy
      @txn
    end
  end
end
