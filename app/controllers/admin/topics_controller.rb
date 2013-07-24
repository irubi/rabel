# encoding: utf-8
require 'RMagick'
class Admin::TopicsController < Admin::BaseController
  def index
    @topics = Topic.order('created_at DESC').page(params[:page])
    @title = '讨论话题'
  end

  def select_image
    @title = ''
    @topic = Topic.find(params[:id])
    @image = Nicepicture.find_by_url(params[:url])
    if(@image.nil?)
      @image = Nicepicture.create(:url => params[:url])
      generate_thumbnail(@image.url)
      @topic.nicepictures << @image
      @topic.save
      @text = '移出'
    else
      @image.destroy
      @text = '加入'
    end
    respond_to do |format|
      format.js
    end
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

  private
  def generate_thumbnail(image)
    image = Rails.public_path + image
    origin_image = image.scan(/(.*)\./)[0][0]+ 'origin' + image.gsub(/.*\./,".")
    thumbnail = image.scan(/(.*)\./)[0][0]+ 'thumbnail' + image.gsub(/.*\./,".")
    clown = Magick::Image.read(origin_image).first
    cols, rows = clown.columns, clown.rows
    begin
      new_rows = rows/(cols/190)
      clown.crop_resized!(190, new_rows, Magick::NorthGravity)
    rescue
      
    end
    
    clown.write(thumbnail)
  end
end







