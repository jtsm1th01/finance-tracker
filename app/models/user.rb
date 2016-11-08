class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

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
  
  def full_name
    return "#{fname} #{lname}".strip if (fname || lname)
    "Anonymous"
  end
  
  def not_friends_with?(user_id)
    friendships.where(friend_id: user_id).count < 1
  end
  
  def except_current_user(users)
    users.reject {|user| user.id == self.id}
  end
  
  def self.search(param)
    return User.none if param.blank?
    param.strip!
    param.downcase!
    (fname_matches(param) + lname_matches(param) + email_matches(param)).uniq
  end
  
  def self.fname_matches(param)
    matches('fname', param)  
  end
  
  def self.lname_matches(param)
    matches('lname', param)
  end
  
  def self.email_matches(param)
    matches('email', param)
  end
  
  def self.matches(field_name, param)
    where("lower (#{field_name}) like ?", "%#{param}%")  
  end
  
end

