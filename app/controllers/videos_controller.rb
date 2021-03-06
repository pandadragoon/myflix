class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
  end
  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews.all
  end
  def search
    @videos = Video.search_by_title(params[:search])
  end
  private

  def video_params
    params.require(:video).permit(:title, :description, :small_cover, :large_cover)
  end

end
