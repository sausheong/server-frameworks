require './helper'

feature "As an owner, I want to write blog posts", js: true do
  given(:seed)   {Seeder.new}
  given(:post)   {seed.post}
  given(:md)     {seed.post(:md)}
  given(:adam)   {seed.user(:adam)}
  given(:brad)   {seed.user(:brad)}
  given(:cindy)  {seed.user(:cindy)}
  
  scenario "I cannot write new post without logging in" do
    visit "/"
    page.should_not have_link "New Post"
  end
  
  scenario "When I log in as Adam I can write new post" do    
    visit "/"
    sign_in adam.email, adam.password
    page.should have_link "New Post"    

    click_on "New Post"
    fill_in "heading", with: post.heading
    fill_in "content", with: post.content
    click_on "Add"
    
    page.should have_content post.heading
    page.should have_content post.content
    
  end

  scenario "When I log in as Adam I can write a new post with Markdown" do
    visit "/"
    sign_in adam.email, adam.password
    page.should have_link "New Post"

    click_on "New Post"
    fill_in "heading", with: md.heading
    fill_in "content", with: md.content
    click_on "Add"
    
    page.should have_content md.heading
    page.should have_selector "img[src='/test.jpg']"
    page.should have_link "Barack Obama"
  end

  scenario "When I log in as Cindy I can write new post" do   
    visit "/" 
    sign_in cindy.email, cindy.password
    page.should have_link "New Post"    
    
    click_on "New Post"
    fill_in "heading", with: post.heading
    fill_in "content", with: post.content
    click_on "Add"
    
    page.should have_content post.heading
    page.should have_content post.content    
  end


  scenario "When I log in as Brad (who doesn't have access), I cannot write a new post" do
    visit "/"
    sign_out_facebook
    sign_in brad.email, brad.password
    page.should have_no_link "New Post"
  end

  
end