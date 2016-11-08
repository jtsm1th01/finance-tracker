class FriendshipsController < ApplicationController

  def destroy
    @friendship = current_user.friendships.where(friend_id: params[:id]).first
    if @friendship.destroy
      flash[:notice] = "Friend was removed"
      redirect_to my_friends_path
    else
      flash[:danger] = "Friend could not be removed"
      render my_friends_path
    end
  end

end