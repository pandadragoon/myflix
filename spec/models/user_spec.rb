require 'spec_helper'

describe User do
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:password)}
  it {should validate_presence_of(:full_name)}
  it {should validate_uniqueness_of (:email)}
  it {should have_many(:queue_items).order("position")}
  it {should have_many(:reviews).order("created_at DESC")}

  it_behaves_like "tokenable" do
    let(:object) {Fabricate(:user)}
  end
  describe "#queued_videos?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be true
    end
    it "returns false when the user has not queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      user.queued_video?(video).should be false
    end
  end

  describe "#follows?" do
    it "returns true if a user has a following relationship with another user" do
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      Fabricate(:relationship, leader: alice, follower: bob)
      expect(bob.follows?(alice)).to be true
    end
    it "returns false if a user does not have a following relationship with another user" do
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      expect(bob.follows?(alice)).to be false
    end
  end

  describe "#follow" do
    it "follows another user" do
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      alice.follow(bob)
      expect(alice.follows?(bob)).to be_true
    end
    it "does not follow one self" do
      bob = Fabricate(:user)
      bob.follow(bob)
      expect(bob.follows?(bob)).to be_false
    end
  end
end
