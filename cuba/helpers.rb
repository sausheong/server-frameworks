require 'digest'

module Helper
    
  def markdown(content)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true).render(content)
  end
  
  def snippet(page, options={})
    haml page, options.merge!(layout: false)
  end
  
  def authenticated
    User.find_by(email: session[:user])
  end
end


class SendRegisterConfirmJob
  include SuckerPunch::Job
  
  def perform(email, password)
    body = "Your blogs account password is: #{password}"
    Pony.mail(:to => email, subject: 'You have registered an account with Blogs', body: body)    
  end
end