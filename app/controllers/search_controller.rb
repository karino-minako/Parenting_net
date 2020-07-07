class SearchController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params["search"]["model"]
    @content = params["search"]["content"]
    @records = search_for(@model, @content)
  end

  private
  def search_for(model, content)
    if model == 'user'
      User.where('name LIKE ?', '%'+content+'%')
    elsif model == 'post'
      Post.where('title LIKE ?', '%'+content+'%')
    elsif model == 'question'
      Question.where('title LIKE ?', '%'+content+'%')
    end
  end
end