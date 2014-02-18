require 'spec_helper'

feature 'Admin panel' do
  context "on admin homepage" do
    it "can see a list of recent posts" do
      page.driver.browser.authorize 'geek', 'jock'

      Post.create!(title: "Title", content: "Content")
      visit root
      page.should have_content("Title")
    end

    it "can edit a post by clicking the edit link next to a post" do
      page.driver.browser.authorize 'geek', 'jock'

      Post.create!(title: "Title", content: "Content")
      visit admin_posts_path
      click_link "Edit"
      expect(page).to have_content("Edit Title")
    end

    it "can delete a post by clicking the delete link next to a post" do
      page.driver.browser.authorize 'geek', 'jock'

      Post.create!(title: "Title", content: "Content")
      visit admin_posts_path
      click_link "Delete"
      expect(page).to have_no_content("Title")
    end

    it "can create a new post and view it" do
       visit new_admin_post_url

       expect {
         fill_in 'post_title',   with: "Hello world!"
         fill_in 'post_content', with: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat."
         page.check('post_is_published')
         click_button "Save"
       }.to change(Post, :count).by(1)

       page.should have_content "Published: true"
       page.should have_content "Post was successfully saved."
     end
  end

  context "editing post" do
    it "can mark an existing post as unpublished" do
      page.driver.browser.authorize 'geek', 'jock'

      Post.create!(title: "Title", content: "Content", is_published: true)
      visit admin_posts_path
      click_link "Edit"
      uncheck('post_is_published')
      click_button "Save"
      page.should have_content "Published: false"
    end
  end

  context "on post show page" do
    it "can visit a post show page by clicking the title" do
      page.driver.browser.authorize 'geek', 'jock'

      post = Post.create!(title: "Title", content: "Content", is_published: true)
      visit admin_posts_path
      expect(find_link('Title')[:href]).to eq(admin_post_url(post))
    end

    it "can see an edit link that takes you to the edit post path" do
      page.driver.browser.authorize 'geek', 'jock'
      post = Post.create!(title: "Title", content: "Content", is_published: true)
      visit admin_post_path(post)
      expect(find_link('Edit')[:href]).to eq(edit_admin_post_url(post))
    end

    it "can go to the admin homepage by clicking the Admin welcome page link" do
      page.driver.browser.authorize 'geek', 'jock'
      post = Post.create!(title: "Title", content: "Content", is_published: true)
      visit admin_post_path(post)
      expect(find_link('Admin welcome page')[:href]).to eq(admin_posts_url)
    end
  end
end
