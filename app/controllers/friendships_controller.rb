class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def send_request
    friendship1 = Friendship.create(user_id: current_user.id,
                                   friend_id: params[:friend_id],
                                   status: false)
    friendship2 = Friendship.create(user_id: params[:friend_id],
                                   friend_id: current_user.id,
                                   status: false)
    redirect_to users_path, notice: 'Send your friend request successfully' if friendship1.save && friendship2.save
  end

  def accept
    accept1 = Friendship.find_by(user_id: params[:user_id],friend_id: current_user.id)
    accept2 = Friendship.find_by(user_id:current_user.id, friend_id: params[:user_id])
    return unless accept1 && accept2

    accept1.update(status: true)
    accept2.update(status: true)
    redirect_to requests_path, notice: 'You accepted request'
  end

  def decline
    decline1 = Friendship.find_by(user_id: params[:user_id],friend_id: current_user.id)
    decline2 = Friendship.find_by(user_id:current_user.id, friend_id: params[:user_id])
    return unless decline1 && decline2

    decline1.destroy
    decline2.destroy
    redirect_to requests_path, notice: 'You Decline request'
  end

  def show
    @friends = Friendship.all
  end
end
