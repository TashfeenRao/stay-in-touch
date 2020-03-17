module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def show_requests
    @request = current_user.inverse_friendships.where(status: false)
  end

  def show_pending
    current_user.friendships.where(status: false)
  end

  def friends
    @friend = current_user.friendships.where(status: true)
  end

  def user_friends(user)
    user.friendships.where(status: true)
  end

  def show_mutual_friends(user)
    u1 = user.friendships.find_by(status: true)
    u2 = current_user.friendships.find_by(status: true)
    return if u1.nil? || u2.nil?

    @mutual = u1 if u1.friend_id == u2.friend_id
  end

  def show_friend_request(user)
    friendship = Friendship.find_by(user_id: current_user.id,
                                    friend_id: user.id)
    user != current_user && !friendship
  end

  def already_friend(user)
    friendship = Friendship.find_by(user_id: current_user.id,
                                    friend_id: user.id,
                                    status: true)
    user != current_user && friendship
  end

  def pending_friend(user)
    friendship = Friendship.find_by(user_id: current_user.id,
                                    friend_id: user.id,
                                    status: false)
    user != current_user && friendship
  end
end
