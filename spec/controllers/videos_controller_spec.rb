require 'spec_helper'

describe VideosController do

  describe "GET show" do
      it "sets @video if user is authenticated" do
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "redirects the user to the sign in page if unauthenticated" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end
  end

  describe "POST search" do
    it "sets @videos for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: "futurama")
      post :search, search: 'rama'
      expect(assigns(:videos)).to eq([futurama])
    end

    it "redirects to sign in page for unauthenticated users" do
      futurama = Fabricate(:video, title: "futurama")
      post :search, search: 'rama'
      expect(response).to redirect_to sign_in_path
    end
  end
end
