require 'rails_helper'

feature 'restaurants' do

  context 'with logged in user' do
    before(:each) do
      visit '/restaurants'
      click_link 'Sign up'
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'
    end

    context 'no restaurants have been added' do
      scenario 'should display a prompt to add a restaurant' do
        expect(page).to have_content 'No restaurants yet'
        expect(page).to have_link 'Add a restaurant'
      end

      context 'restaurants have been added' do
        before do
          Restaurant.create(name: 'KFC')
        end

        scenario 'display restaurants' do
          visit '/restaurants'
          expect(page).to have_content('KFC')
          expect(page).not_to have_content('No restaurants yet')
        end
      end
    end
    context 'creating restaurants' do
      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        click_button 'Create Restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end

      context 'an invalid restaurant' do
        it 'does not let you submit a name that is too short' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'kf'
          click_button 'Create Restaurant'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
        end
      end
    end
    context 'viewing restaurants' do

      let!(:kfc){Restaurant.create(name:'KFC')}

      scenario 'lets a user view a restaurant' do
        visit '/restaurants'

        click_link 'KFC'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq "/restaurants/#{kfc.id}"
      end
    end
    context 'editing restaurants' do

      scenario 'let a user edit a restaurant' do
        visit '/restaurants'
        add_restaurant
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(current_path).to eq '/restaurants'
      end
    end
    context 'deleting restaurants' do

      scenario 'removes a restaurant when a user clicks a delete link' do
        visit '/restaurants'
        add_restaurant
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end

      scenario 'removes all reviews of a restaurant when it is deleted' do
        visit '/restaurants'
        add_restaurant
        click_link 'Review KFC'
        fill_in 'Thoughts', with: 'so so'
        select '3', from: 'Rating'
        click_button 'Leave Review'
        expect(current_path).to eq restaurants_path
        click_link 'Delete KFC'
        expect(page).not_to have_content 'so so'
      end

      scenario 'can only delete restaurants you have created' do
        add_restaurant
        click_link 'Sign out'
        sign_up_user2
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).to have_content 'You can only delete restaurants you have created'
      end

      scenario 'can only edit a restaurant you have created' do
        add_restaurant
        click_link 'Sign out'
        sign_up_user2
        visit '/restaurants'
        click_link 'Edit KFC'
        expect(page).to have_content 'You can only edit restaurants you have created'
      end
    end
  end

  context 'without logged in user' do
    context 'user must be logged to do these following actions' do

      scenario 'create a restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        expect(page).to have_content "You need to sign in or sign up before continuing."
      end
    end
  end
end
