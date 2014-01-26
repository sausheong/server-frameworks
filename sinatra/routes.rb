get "/" do  
  page = params[:page] || 1
  page_size = params[:page_size] || 5
  @posts = Post.reverse_order(:created_at).paginate(page.to_i, page_size.to_i)
  must_login if session[:user]
  haml :index
end

get "/post/view/:id" do
  @post = Post[params[:id]]
  must_login if session[:user]
  haml :'post/view'
end

get "/post/new" do
  must_login
  @post = Post.new
  haml :'post/new'
end

get "/post/edit/:id" do
  must_login
  @post = Post[params[:id]]
  raise 'Cannot find this post' unless @post
  haml :'post/edit'
end

delete "/post" do
  must_login
  post = Post[params[:id]]
  raise "You didn't write this post so you can't remove it." unless post.user == @user
  post.destroy
  redirect "/"
end

delete "/comment" do
  must_login
  comment = Comment[params[:id]]
  raise "You didn't write this comment so you can't remove it." unless comment.user == @user
  post_id = comment.post.id
  comment.destroy
  redirect "/post/view/#{post_id}"
end


post "/post" do
  must_login
  unless post = Post[params[:id]]
    post = Post.new user: @user
  end
  post.heading, post.content = params['heading'], params['content']
  post.save
  redirect "/"
end

post "/comment" do
  must_login
  post = Post[params[:post_id]]
  raise "Cannot find a post for you to comment on" unless post  
  unless comment = Comment[params[:id]]
    comment = Comment.new post: post, user: @user
  end
    comment.content = params['content']
    comment.save
    redirect "/post/view/#{post.id}"
end


post "/register" do
  password = rand(36**8).to_s(36)
  hashed_pwd = Digest::SHA1.hexdigest(password)
  User.create name: params[:name], email: params[:email], password: hashed_pwd
  SendRegisterConfirmJob.new.async.perform params[:email], password
  redirect "/"
end


post "/signin" do
  @user = User.first email: params[:email]
  hashed_pwd = Digest::SHA1.hexdigest(params[:password])
  raise "Wrong email or password" unless @user.password == hashed_pwd
  session[:user] = @user.email
  redirect "/"
end

get "/logout" do
  session.clear
  redirect "/"
end