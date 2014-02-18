require 'spec_helper'

feature 'User browsing the website' do
  context "on homepage" do
    it "sees a list of recent posts titles" do

      post1 = Post.create!(title: "Title", content: "Content")
      post2 = Post.create!(title: "Blah", content: "Content")
      visit root_url
      posts = []
      all('a').each { |a| posts << a[:href] }
      expect(posts[1]).to eq(post_url(post2))
      # page.body.should =~ /Blah.*Title/
    end

    it "can click on titles of recent posts and should be on the post show page" do
      post = Post.create!(title: "Title", content: "Content", is_published: true)
      visit root_url
      click_link "Title"
      expect(current_url).to eq(post_url(post))
    end
  end

  context "post show page" do
    it "sees title and body of the post" do
      post = Post.create!(title: "Title", content: "Content", is_published: true)
      visit root_url
      click_link "Title"
      expect(page).to have_content("Title")
      expect(page).to have_content("Content")
    end
  end
end
