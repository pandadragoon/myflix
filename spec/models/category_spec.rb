require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
end

describe '#recent_videos' do
  it "returns all records in reverse chronological order by created at" do
    category = Category.create(name: "name")
    futurama = Video.create(title: 'futurama', description: 'space travel', category_id: 1, created_at: 1.day.ago)
    fam_guy = Video.create(title: 'fam_guy', description: 'space travel', category_id: 1)
    expect(category.recent_videos).to eq([fam_guy, futurama])
  end
  it "returns all records when less then six" do
    category = Category.create(name: "comedy")
    4.times do
      Video.create(title: 'futurama', description: 'space travel', category_id: 1)
    end
    expect(category.recent_videos.count).to eq(4)
  end
  it "returns six records when more then six" do
    category = Category.create(name: "comedy")
    8.times do
      Video.create(title: 'futurama', description: 'space travel', category_id: 1)
    end
    expect(category.recent_videos.count).to eq(6)
  end
  it "returns the most recent six records" do
    category = Category.create(name: "comedy")
    6.times do
      Video.create(title: 'futurama', description: 'space travel', category_id: 1)
    end
    monk = Video.create(title: 'monk', description: 'a guy', category_id: 1, created_at: 1.day.ago)
    expect(category.recent_videos).not_to include(monk)
  end

  it "returns empty array if category doesn't have videos" do
    category = Category.create(name: 'comedy')
    expect(category.recent_videos).to eq([])
  end
end