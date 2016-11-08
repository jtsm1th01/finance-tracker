class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @user_stocks = @user.user_stocks
  end
  
  def my_portfolio
    @user_stocks = current_user.stocks
    @user = current_user
  end
  
  def my_friends
    @friends = current_user.friends
  end
  
  def search
    @users = User.search(params[:search_param])
    
    if @users
      @users = current_user.except_current_user(@users)
      render partial: "friends/lookup"
    else
      render status: :not_found, nothing: true
    end
  end
  
  def add_friend
    @friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: @friend.id)
    
    if current_user.save
      flash[:notice] = "User was successfully added as friend"
      redirect_to my_friends_path
    else
      flash[:error] = "There was an error adding user as friend"
      redirect_to my_friends_path
    end
  end

end