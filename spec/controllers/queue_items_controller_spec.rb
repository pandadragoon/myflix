require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to queue items of authenticated user" do
      bob = Fabricate(:user)
      set_current_user(bob)
      queue_item1 = Fabricate(:queue_item, user: bob)
      queue_item2 = Fabricate(:queue_item, user: bob)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :index}
    end
  end

  describe "POST create" do
    it "redirects to the my queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: Fabricate(:video).id
      expect(response).to redirect_to my_queue_path
    end
    it "creates a queue item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it "creates the queue item associated with the video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    it "creates the queue item associated with the signed in user" do
      bob = Fabricate(:user)
      set_current_user(bob)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(bob)
    end
    it "puts the video as the last in the queue" do
      bob = Fabricate(:user)
      set_current_user(bob)
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: bob)
      south_park = Fabricate(:video)
      post :create, video_id: south_park.id
      south_park_queue_item = QueueItem.where(video_id: south_park.id, user_id: bob.id).first
      expect(south_park_queue_item.position).to eq(2)
    end
    it "does not add the video to the queue if already in the queue" do
      bob = Fabricate(:user)
      set_current_user(bob)
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: bob)
      post :create, video_id: monk.id
      expect(bob.queue_items.count).to eq(1)
    end
    it_behaves_like "requires sign in" do
      let(:action) { post :create, video_id: 3}
    end
  end
  describe"DELETE destroy" do
    it "redirects to the my queue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end
    it "deletes the queue item" do
      bob = Fabricate(:user)
      set_current_user(bob)
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end
    it "normalizes position order when video is removed from queue" do
      bob = Fabricate(:user)
      set_current_user(bob)
      queue_item1 = Fabricate(:queue_item, user: bob, position: 1)
      queue_item2 = Fabricate(:queue_item, user: bob, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end
    it "does not delete the queue item if not owned by current user" do
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 3}
    end
  end

  describe 'POST update_queue' do
    it_behaves_like "requires sign in" do
      let(:action) { post :update_queue, queue_items: [{id: 1, position: 2}, {id: 2, position: 1}]}
    end
    context "with valid input" do
      let(:bob) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:queue_item1) {Fabricate(:queue_item, user: bob, position: 1, video: video)}
      let(:queue_item2) {Fabricate(:queue_item, user: bob, position: 2, video: video)}
      before {set_current_user(bob)}

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2 }, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2 }, {id: queue_item2.id, position: 1}]
        expect(bob.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3 }, {id: queue_item2.id, position: 2}]
        expect(bob.queue_items.map(&:position)).to eq([1,2])
      end
    end
    context "with invalid input" do
      let(:bob) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:queue_item1) {Fabricate(:queue_item, user: bob, position: 1, video: video)}
      let(:queue_item2) {Fabricate(:queue_item, user: bob, position: 2, video: video)}
      before {set_current_user(bob)}
      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.5 }, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "sets the error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.5 }, {id: queue_item2.id, position: 1}]
        expect(flash[:error]).to be_present
      end
      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2 }, {id: queue_item2.id, position: 2.2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    context "with queue items that do not belong to the current users" do
      it "does not change the queue items" do
        bob = Fabricate(:user)
        set_current_user(bob)
        alice = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: bob, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2 }, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

  end
end
