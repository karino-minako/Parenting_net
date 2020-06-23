class HomeController < ApplicationController
  def top
  	@all_ranks = Post.find(PostLike.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
  end

  def about
  end
end
