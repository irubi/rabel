# encoding: utf-8
class Admin::TopicsController < Admin::BaseController
  def index
    @topics = Topic.order('created_at DESC').page(params[:page])
    @title = '讨论话题'
  end

  def show_images
    @topics = Topic.order('created_at DESC').page(params[:page])
    @title = '图片选择'
  end

  def destroy
    @topic = Topic.find(params[:id])
    if @topic.destroy
      redirect_to admin_topics_path
    else
      redirect_to admin_root_path
    end
  end
end
