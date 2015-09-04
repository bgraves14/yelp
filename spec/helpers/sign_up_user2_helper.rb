def sign_up_user2
  visit '/restaurants'
  click_link 'Sign up'
  fill_in 'Email', with: 'test2@test.com'
  fill_in 'Password', with: '12345678'
  fill_in 'Password confirmation', with: '12345678'
  click_button 'Sign up'
end
