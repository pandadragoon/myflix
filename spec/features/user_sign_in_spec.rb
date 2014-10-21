require 'spec_helper'

feature 'user signs in' do
  scenario "with valid email and password" do
    bob = Fabricate(:user)
    sign_in(bob)
    expect(page).to have_content bob.full_name
  end
end
