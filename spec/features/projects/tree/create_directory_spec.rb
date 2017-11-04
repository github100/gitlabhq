require 'spec_helper'

feature 'Multi-file editor new directory', :js do
  include WaitForRequests

  let(:user) { create(:user) }
  let(:project) { create(:project, :repository) }

  before do
    project.add_master(user)
    sign_in(user)

    page.driver.set_cookie('new_repo', 'true')

    visit project_tree_path(project, :master)

    wait_for_requests
  end

  it 'creates directory in current directory' do
    find('.add-to-tree').click

    click_link('New directory')

    page.within('.popup-dialog') do
      find('.form-control').set('foldername')

      click_button('Create directory')
    end

    fill_in('commit-message', with: 'commit message')

    click_button('Commit 1 file')

    expect(page).to have_content('Your changes have been committed')
    expect(page).to have_selector('td', text: 'commit message')

    click_link('foldername')

    expect(page).to have_selector('td', text: 'commit message', count: 2)
    expect(page).to have_selector('td', text: '.gitkeep')
  end
end
