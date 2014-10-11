class VideosController < ApplicationController
  def index
    @categories = Category.all
  end
  def show
    @video = Video.find(params[:id])
  end

  private

  def video_parms
    params.require(:video).require(:title, :description, :small_cover_url, :large_cover_url)
  end
end
