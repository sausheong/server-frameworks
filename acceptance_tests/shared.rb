module Features
  module Shared
    def click_on(item, options={})
      if item.class == Capybara::Node::Element
        item.click 
      else
        click_link_or_button item, options
      end
    end
    
    def sign_in(username, password)      
      page.visit "/"
      page.click_on "Sign in"
      unless page.has_link? "New Post"
        page.fill_in "Email", with: username
        page.fill_in "Password", with: password
        page.click_on "Log In"            
      end
    end
    
    def sign_out
      page.find('.icon-user').click
      page.click_on "Sign out"
    end
    
    def sign_out_facebook
      page.visit("http://www.facebook.com")

      if page.first("#navAccountLink")
        page.first("#navAccountLink").click
        page.first("#logout_form").click_on("Log Out")
        page.visit "/"
      end
    end
        
  end
end