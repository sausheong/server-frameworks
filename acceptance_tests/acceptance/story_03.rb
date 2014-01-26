require './helper'

feature "As an owner or writer I want to be able to delete my own posts", js: true do
  given(:seed)   {Seeder.new}
  given(:post)   {seed.post}
  given(:adam)   {seed.user(:adam)}
  given(:cindy)  {seed.user(:cindy)}
  
  scenario "I cannot delete a post without logging in" do
    visit "/"
    click_on first '.post-heading'
    page.should have_no_link 'delete'
  end
  
  scenario "When I log in as Adam, I can write a random post and delete the post" do 
    sign_out_facebook   
    sign_in adam.email, adam.password
    
    page.should have_link "New Post"    

    click_on "New Post"
    fill_in "heading", with: "This is a test blog post - testing for delete"
    fill_in "content", with: post.content
    click_on "Add"
    
    page.should have_content post.heading
    page.should have_content post.content
    
    click_on first '.post-heading'
    page.should have_link 'delete post'
    click_on 'delete post'
    
    page.should have_no_content "This is a test blog post - testing for delete"
  end

  scenario "When I log in as Cindy, I cannot delete Adam's post" do
    sign_out_facebook
    sign_in cindy.email, cindy.password
    page.should have_link "New Post"
      
    click_on first '.post-heading'
    
    page.should have_no_link 'delete post'    
  end

end