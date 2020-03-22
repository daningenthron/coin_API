class CoinsController < ApplicationController
  before_action :set_coin, only: [:show, :update, :destroy]

  def index
    @coins = Coin.all
    json_response(@coins)
  end

  def create
    @coin = Coin.create!(coin_params)
    value = @coin[:value]
    @coin.name = name_hash[value]
    @coin.save
    json_response(@coin, :created)
  end

  def show
    json_response(@coin)
  end

  def update
    @coin.update(coin_params)
    head :no_content
  end

  def destroy
    @coin.destroy
    head :no_content
  end

  def total
    json_response(Coin.sum(:value))
  end

  private

  def name_hash
    { 1 => 'penny', 5 => 'nickel', 10 => 'dime', 25 => 'quarter' }
  end

  def name(value)
    name_hash[value]
  end

  def coin_params
    params.permit(:value, :name)
  end

  def set_coin
    @coin = Coin.find(params[:id])
  end
end
