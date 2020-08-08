module NotificationsHelper
  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    your_post = link_to 'あなたの投稿', post_path(notification), style:"font-weight: bold;"
    @visiter_comment = notification.comment_id

    @answer = nil
    your_question = link_to 'あなたの質問', question_path(notification), style:"font-weight: bold;"
    @visiter_answer = notification.answer_id

    @follow = nil
    your_follower = link_to 'あなたをフォローした人', user_path(notification), style:"font-weight: bold;"

    @message = nil
    your_message = link_to 'あなたにメッセージを送った人', user_path(notification), style:"font-weight: bold;"
    @visiter_message = notification.message_id

    case notification.action
      when "follow" then
        @follow = Relationship.find_by(followed_id: notification.id)
        tag.a(notification.visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"さんがあなたをフォローしました"
      when "like" then
        tag.a(notification.visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"さんが"+tag.a('あなたの投稿', href:post_path(notification.post_id), style:"font-weight: bold;")+"に「いいね」しました"
      when "empathy" then
        tag.a(notification.visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"さんが"+tag.a('あなたの質問', href:question_path(notification.question_id), style:"font-weight: bold;")+"に「共感した」を押しました"
      when "comment" then
        @comment = Comment.find_by(id: @visiter_comment)
        if @comment.post.user_id == current_user.id
          tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"さんが"+tag.a('あなたの投稿', href:post_path(notification.comment.post_id), style:"font-weight: bold;")+"にコメントしました"
        else
          tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"さんが"+tag.a("#{@comment.post.user.name}さんの投稿", href:post_path(notification.comment.post_id), style:"font-weight: bold;")+"にコメントしました"
        end
      when "answer" then
        @answer = Answer.find_by(id: @visiter_answer)
        if @answer.question.user_id == current_user.id
          tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"さんが"+tag.a('あなたの質問', href:question_path(notification.answer.question_id), style:"font-weight: bold;")+"に回答しました"
        else
          tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"さんが"+tag.a("#{@answer.question.user.name}さんの質問", href:question_path(notification.answer.question_id), style:"font-weight: bold;")+"に回答しました"
        end
      when "message" then
        @message = Message.find_by(id: @visiter_message)&.content
        tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"さんが"+tag.a('あなたとのチャットルーム', href:room_path(notification.message.room_id), style:"font-weight: bold;")+"にメッセージを送りました"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
