def leave_review
  fill_in "Thoughts", with: "so so"
  select '3', from: 'Rating'
  click_button 'Leave Review'
end
