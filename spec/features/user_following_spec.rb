require "spec_helper"

feature "user following" do
  scenario "user follows and unfollows someone" do
    alice = Fabricate(:user)
    comedies = Category.create(name: 'comedies')
    video = Fabricate(:video, category: comedies)
    Fabricate(:review, user: alice, video: video)
    sign_in

    click_on_home_page_video(video)
    click_link alice.full_name
    click_link "Follow"

    expect(page).to have_content(alice.full_name)

    unfollow(alice)

    expect(page).not_to have_content(alice.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end
