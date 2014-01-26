require './helper'

feature "As a reader, I want to read posts", js: true do

  scenario "I can read without logging in and posts have heading and content" do
    visit "/"
    page.should have_selector ".post-heading"
    page.should have_selector ".post-content"
  end
  
  scenario "I can view a single post page" do
    visit "/"
    click_on first '.post-heading'
    
    page.should have_selector ".post-heading"
    page.should have_selector ".post-content"
  end
end
