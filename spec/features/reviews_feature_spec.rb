require 'rails_helper'

feature 'reviewing' do

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    sign_up_user2
    add_restaurant
    click_link 'Review KFC'
    leave_review
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'users can only leave one review per restaurant' do
    visit '/restaurants'
    sign_up_user2
    add_restaurant
    click_link 'Review KFC'
    leave_review
    click_link 'Review KFC'
    leave_review
    expect(page).to have_content 'You can only leave one review per restaurant'
  end
end
