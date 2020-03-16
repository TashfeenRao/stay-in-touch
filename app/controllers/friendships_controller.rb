class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def send_request
    friendship1 = Friendship.create(user_id: current_user.id,
                                    friend_id: params[:friend_id],
                                    status: false)
    redirect_to users_path, notice: 'Send your friend request successfully' if friendship1.save
  end

  def accept
    accept1 = current_user.inverse_friendships.find_by(user_id: params[:user_id])
    return unless accept1

    accept1.update(status: true)
    current_user.friendships.create(friend_id: params[:user_id], status: true)
    redirect_to requests_path, notice: 'You accepted request'
  end

  def decline
    decline1 = current_user.friendships.find_by(friend_id: params[:user_id])
    decline2 = current_user.inverse_friendships.find_by(user_id: params[:user_id])
    if decline1.nil?
      decline2.destroy
      redirect_to requests_path, notice: 'You Decline request'
    elsif decline2.nil?
      decline1.destroy
      redirect_to requests_path, notice: 'You Cancel request'
    else
      return unless decline1 && decline2

      decline1.destroy
      decline2.destroy
      redirect_to requests_path, notice: 'You Decline request'
    end
  end

  def show
    @friends = Friendship.all
  end
end
