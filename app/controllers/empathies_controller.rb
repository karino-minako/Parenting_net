class EmpathiesController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    unless @question.empathized_by?(current_user)
      empathy = @question.empathies.new(user_id: current_user.id)
      empathy.save
      @question_user_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/" + @question.user.profile_image_id.to_s
      @image_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/"
    end
  end

  def destroy
    @question = Question.find(params[:question_id])
    empathy = current_user.empathies.find_by(question_id: @question.id)
    empathy.destroy
    @question_user_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/" + @question.user.profile_image_id.to_s
    @image_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/"
  end
end