require 'spec_helper'

describe Video do

  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}

end

describe "search_by_title" do
  it "returns an empty array when search term does not match any titles" do
    futurama = Video.create(title: 'futurama', description: 'space travel')
    back_to_future = Video.create(title: 'back to the future', description: 'time travel')
    expect(Video.search_by_title("hello")).to eq([])

  end

  it "returns an array with a single value when search term finds an exact match" do
    futurama = Video.create(title: 'futurama', description: 'space travel')
    back_to_future = Video.create(title: 'back to the future', description: 'time travel')
    expect(Video.search_by_title("futurama")).to eq([futurama])
  end

  it "returns an array of one video when a partial match is found" do
    futurama = Video.create(title: 'futurama', description: 'space travel')
    back_to_future = Video.create(title: 'back to the future', description: 'time travel')
    expect(Video.search_by_title("futura")).to eq([futurama])
  end

  it "returns an array of matches in order of created_at" do
    futurama = Video.create(title: 'futurama', description: 'space travel', created_at: 1.day.ago)
    futurama2 = Video.create(title: 'futuramas', description: 'space travel', created_at: 3.day.ago)
    futurama3 = Video.create(title: 'futuramass', description: 'space travel', created_at: 2.day.ago)
    back_to_future = Video.create(title: 'back to the future', description: 'time travel')
    expect(Video.search_by_title("urama")).to eq([futurama, futurama3, futurama2])
  end
end
