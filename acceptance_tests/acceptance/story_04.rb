require './helper'

feature "As an owner or writer I want to be able to modify my own posts", js: true do
  given(:seed)   {Seeder.new}
  given(:post)   {seed.post}
  given(:adam)   {seed.user(:adam)}
  given(:cindy)  {seed.user(:cindy)}
  
  scenario "I cannot modify a post without logging in" do
    visit "/" 
    click_on first ".post-heading"
    
    page.should have_no_link 'edit'
  end
  
  scenario "When I log in as Adam, I can write a random post then modify it" do 
    visit "/"
    sign_out_facebook   
    sign_in adam.email, adam.password

    page.should have_link "New Post"        
    
    click_on "New Post"
    fill_in "heading", with: "This is a test blog post - testing for edit"
    fill_in "content", with: post.content
    click_on "Add"

    page.should have_content "This is a test blog post - testing for edit"
    page.should have_content post.content

    click_on first '.post-heading'
    
    page.should have_link 'edit'
    
    click_on 'edit'
    
    page.fill_in "heading", with: "Modified heading"
    page.fill_in "content", with: "Modified content"
    page.click_on "Modify"

    page.should have_content "Modified heading"
    page.should have_content "Modified content"
    
  end

  scenario "When I log in as Cindy, I cannot modify Adam's post" do
    visit "/"
    sign_out_facebook
    sign_in cindy.email, cindy.password
    page.should have_link "New Post"
      
    click_on first ".post-heading"
    page.should have_no_link 'edit'    
  end

end