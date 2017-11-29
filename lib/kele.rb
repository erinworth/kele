require 'httparty'
require 'json'

class Kele
  include HTTParty
  base_uri "https://www.bloc.io/api/v1"

  def initialize(email, password)
    post_response = self.class.post("/sessions", body: {email: email, password: password})
    @auth_token = post_response['auth_token']

    raise "Invalid Login Credentials" if @auth_token.nil?

    puts @auth_token
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end
end
