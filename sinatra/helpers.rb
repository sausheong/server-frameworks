require 'digest'

module Helper
  include SuckerPunch::Job
  
  def markdown(content)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true).render(content)
  end
  
  def snippet(page, options={})
    haml page, options.merge!(layout: false)
  end
    
  def toolbar
    haml :toolbar, layout: false
  end
  
  def must_login
    raise "You have not signed in yet. Please sign in first!" unless session[:user]
    @user = User.first(email: session[:user])
    true
  end
end


class SendRegisterConfirmJob
  include SuckerPunch::Job
  
  def perform(email, password)
    body = "Your blogs account password is: #{password}"
    Pony.mail(:to => email, subject: 'You have registered an account with Blogs', body: body)    
  end
end