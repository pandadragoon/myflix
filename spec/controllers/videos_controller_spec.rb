require 'spec_helper'

describe VideosController do

  describe "GET show" do
      it "sets @video if user is authenticated" do
        set_current_user
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end
      it "sets @reviews if user is authenticated" do
        set_current_user
        video = Fabricate(:video)
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review1,review2])
      end
  
      it_behaves_like "requires sign in" do
        let(:action) {get :show, id: 1}
      end
  end

  describe "POST search" do
    it "sets @videos for authenticated users" do
      set_current_user
      futurama = Fabricate(:video, title: "futurama")
      post :search, search: 'rama'
      expect(assigns(:videos)).to eq([futurama])
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :search, search: 'rama'}
    end
  end
end
