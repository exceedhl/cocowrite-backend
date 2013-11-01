require 'api/all'

class Application < Goliath::API
  
  def response(env)
    puts Goliath.env
    path = env['REQUEST_PATH']
    m = /^\/github(.*)/.match(path)
    if m
      headers = { "Accept" => env["HTTP_ACCEPT"] }
      response = env["githubClient"].get m[1], headers
      [response.status, response.header, response.body]
    elsif /^\/(login_status)/.match(path)
      [200, {}, {}]
    else
      Cocowrite::API::All.call(env)
    end
  end

end
