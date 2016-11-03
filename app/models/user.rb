class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  def can_add_stock?(ticker_symbol)
    has_fewer_than_10_stocks? && !stock_already_added?(ticker_symbol)
  end
  
  def has_fewer_than_10_stocks?
    (user_stocks.count) < 10
  end
  
  def stock_already_added?(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol)
    return false unless stock
    user_stocks.where(stock_id: stock.id).exists?
  end
  
end

