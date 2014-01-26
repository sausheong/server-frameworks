require './settings'
require './models'
require './helpers'

Cuba.use Rack::MethodOverride
Cuba.plugin Helper

Cuba.define do
  on authenticated do        
    on root do
      index = Views::Index.new
      page = param("page").call.nil? ? 1 : param("page").call.first.to_i
      index.page = page
      index.posts = Post.all
      res.write Views::Layout.new(index).authenticated.render        
    end

    on get, "post" do            
      on "new" do
        view = Views::Post::New.new
        res.write Views::Layout.new(view).authenticated.render
      end
    
      on "edit/:id" do |id|
        view = Views::Post::Edit.new
        view.post = Post.find(id)
        res.write Views::Layout.new(view).authenticated.render      
      end
      
      on "view/:id" do |id|
        view = Views::Post::View.new
        view.post = Post.find(id)
        res.write Views::Layout.new(view).authenticated.render
      end      
    end

    on "logout" do
      session.clear
      res.redirect "/"
    end

    on post do
      on "post" do
        on param("heading"), param("content") do |heading, content|
          on param("id") do |id|
            Post.find(id).update_attributes(heading: heading, content: content)
            res.redirect "post/view/#{id}"
          end
          
          on default do
            post = Post.create user: User.find_by(email: session[:user]), heading: heading, content: content            
            res.redirect "post/view/#{post.id}"
          end
        end    
      end
      
      on "comment" do
        on param("content") do |content|
          on param("id") do |id|
            Comment.find(id).update_attributes(content: content)
            res.redirect "post/view/#{comment.post.id}"
          end
          
          on param("post_id") do |post_id|
            post = Post.find(post_id)
            Comment.create post: post, user: User.find_by(email: session[:user]), content: content            
            res.redirect "post/view/#{post_id}"
          end
        end             
      end      
    end   
    
    on delete do
      on "post", param("id") do |id|        
        post = Post.find(id)
        raise "You didn't write this post so you can't remove it." unless post.user.email == session[:user]
        post.destroy
        res.redirect "/"
      end
      
      on "comment", param("post_id"), param("id") do |post_id, id|
        post = Post.find(post_id)
        comment = post.comments.find(id)
        raise "You didn't write this comment so you can't remove it." unless comment.user.email == session[:user]
        comment.destroy        
        res.redirect "/post/view/#{post_id}"
      end
    end         
  end
  
  on root do
    index = Views::Index.new
    page = param("page").call.nil? ? 1 : param("page").call.first.to_i
    index.page = page
    index.posts = Post.all
    res.write Views::Layout.new(index).render      
  end

  on post, "signin" do
    on param("email"), param("password") do |email, password|
      user = User.find_by email: email
      hashed_pwd = Digest::SHA1.hexdigest password
      raise "Wrong email or password" unless user.password == hashed_pwd
      session[:user] = user.email
      res.redirect "/"    
    end
    
    on default do
      raise "User name and password required"
    end
  end
  
  on "post/view/:id" do |id|
    post_view = Views::Post::View.new
    post_view.post = Post.find(id)
    res.write Views::Layout.new(post_view).render
  end
end