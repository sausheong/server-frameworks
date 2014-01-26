require './models'
require './helpers'

configure do
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] ||= 'sausheong_secret_stuff'
  set :show_exceptions, false

  Pony.options = { from: 'noreply@blogs', 
                   via: :smtp, 
                   via_options: { address: 'smtp.sendgrid.net',
                                  port: '25',
                                  user_name: 'sausheong@gmail.com',
                                  password: 'chang123',
                                  authentication: :plain }  
                 }
end

helpers Helper

error RuntimeError do
  @error = request.env['sinatra.error'].message
  haml :error
end

require './routes'