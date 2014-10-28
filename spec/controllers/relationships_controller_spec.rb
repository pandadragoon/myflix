require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships for the current user's following relationships" do
      bob = Fabricate(:user)
      set_current_user(bob)
      alice = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: alice)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end
  end
  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) {delete :destroy, id: 4}
    end
    it "redirects back to the people page" do
      bob = Fabricate(:user)
      set_current_user(bob)
      alice = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: alice)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end
    it "deletes the relationship if the current user is the follower" do
      bob = Fabricate(:user)
      set_current_user(bob)
      alice = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: alice)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end
    it "does not delete the relationship if the current user is not the follower" do
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      charlie = Fabricate(:user)
      set_current_user(alice)
      relationship = Fabricate(:relationship, follower: charlie, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end
end
