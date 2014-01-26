require './helper'

feature "As a reader I want to be able to delete my own comments", js: true do
  given(:seed)   {Seeder.new}
  given(:post)   {seed.post}
  given(:adam)   {seed.user(:adam)}
  given(:brad)   {seed.user(:brad)}
    
  scenario "When I log in as Adam, I can comment on a post and delete my comment" do 
    visit "/"
    sign_out_facebook   
    sign_in adam.email, adam.password

    page.should have_link "New Post"    
    
    click_on "New Post"
    fill_in "heading", with: post.heading
    fill_in "content", with: post.content
    click_on "Add"

    click_on first '.post-heading'
    page.should have_button 'Add comment'
    
    fill_in "content", with: seed.comment
    click_on "Add comment"
    
    page.should have_content seed.comment
    
    click_on 'delete comment'
    page.should have_no_content seed.comment
 
  end  

  scenario "I cannot delete a comment without logging in" do
    visit "/"
    click_on first '.post-heading'
    page.should have_no_link 'delete comment'
  end

  scenario "When I log in as Brad, I can comment on a post and delete my own comment" do 
    visit "/"
    sign_out_facebook   
    sign_in brad.email, brad.password
    
    click_on first '.post-heading'
    page.should have_button 'Add comment'
    
    fill_in "content", with: seed.comment
    click_on "Add comment"
    
    page.should have_content seed.comment
    click_on first '.comment-delete'
    page.should have_no_content seed.comment    
 
  end  
  
end