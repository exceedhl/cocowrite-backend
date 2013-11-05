require 'api/github-client'
require 'model/session'
require 'http-cookie'

class GithubAuthenticator
  include Goliath::Rack::AsyncMiddleware
  
  def call(env)
    unless /^\/(authenticated)/.match(env['REQUEST_PATH'])
      origin = env["HTTP_ORIGIN"] || "http://unknown"
      cookie = env["HTTP_COOKIE"] || ""
      session_id = find_session_id(origin, cookie)
      return [401, {"Content-type" => "applicaiton/json"}, '{"error": "no session found"}'] if session_id.nil?
      session  = Session.where(uuid: session_id).first
      return [401, {"Content-type" => "application/json"}, '{"error":"session invalid"}'] if session.nil?
      env["githubClient"] = Cocowrite::API::GithubClient.new({"access_token" => session.github_token})
      env["session"] = session
    end
    super(env)
  end
  
  private
  def find_session_id(origin, cookie)
    if cookie.is_a?(String) 
      return parse_session_id(cookie, origin)
    end
    if cookie.is_a?(Array)
      cookie.each do |cc|
        return parse_session_id(cookie, origin)
      end
    end
  end
  
  def parse_session_id(cookie, origin)
    c= HTTP::Cookie.parse(cookie, origin)
    c[0].value if c.size > 0 && c[0].name = "session_id"
  end
end
