require 'api/all'

class Application < Goliath::API
  
  def response(env)
    path = env['REQUEST_PATH']
    m = /^\/github(.*)/.match(path)
    if m
      env.logger.debug "Proxying github #{env['REQUEST_METHOD']} request: #{env['REQUEST_PATH']}"
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
