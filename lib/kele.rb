require 'httparty'
require 'json'
require './lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap
  base_uri "https://www.bloc.io/api/v1"

  def initialize(email, password)
    post_response = self.class.post("/sessions", body: {email: email, password: password})
    @auth_token = post_response['auth_token']

    raise "Invalid Login Credentials" if @auth_token.nil?

    puts @auth_token
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    JSON.parse(response.body).to_a
  end

  def get_messages(page = nil)
    if page.nil?
      response = self.class.get('/message_threads', headers: { "authorization" => @auth_token })
    else
      response = self.class.get('/message_threads', body: { page: page }, headers: { "authorization" => @auth_token })
    end
    JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, subject, stripped_text)
    response = self.class.post('/messages', body: { sender: sender, recipient_id: recipient_id, subject: subject, "stripped-text" => stripped_text }, headers: { "authorization" => @auth_token })
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id)
    response = self.class.post('/checkpoint_submissions', body: { checkpoint_id: checkpoint_id, assignment_branch: assignment_branch, assignment_commit_link: assignment_commit_link, comment: comment, enrollment_id: enrollment_id }, headers: { "authorization" => @auth_token })
  end
end
