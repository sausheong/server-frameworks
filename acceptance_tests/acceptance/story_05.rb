require './helper'

feature "As a reader, I want to comment on a post", js: true do
  given(:seed)   {Seeder.new}
  given(:post)   {seed.post}
  given(:adam)   {seed.user(:adam)}
  given(:brad)   {seed.user(:brad)}
    
  scenario "When I log in as Adam, I can comment on a post" do 
    visit "/"
    sign_out_facebook   
    sign_in adam.email, adam.password

    page.should have_link "New Post"      
    
    click_on "New Post"
    fill_in "heading", with: post.heading
    fill_in "content", with: post.content
    click_on "Add"

    page.should have_content post.heading
    page.should have_content post.content

    click_on first ".post-heading"
    page.should have_button 'Add comment'
    
    fill_in "content", with: seed.comment
    click_on "Add comment"
    
    page.should have_content seed.comment
 
  end  

  scenario "I cannot add a comment without logging in" do
    visit "/"
    click_on first ".post-heading"
    page.should have_no_button 'Add comment'
  end

  scenario "When I log in as Brad, I can comment on a post" do 
    visit "/"
    sign_out_facebook   
    sign_in brad.email, brad.password

    click_on first '.post-heading'
    page.should have_button 'Add comment'
    
    fill_in "content", with: seed.comment
    click_on "Add comment"
    
    page.should have_content seed.comment
 
  end  
  
end