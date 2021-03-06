require 'httparty'
require 'json'
require 'pry'

require_relative 'unauthorized'
require_relative 'roadmap'
require_relative 'message'

class Kele
  include HTTParty
  include Roadmap
  include Message

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: { email: email, password: password })
    raise Unauthorized, "Invalid email or password." if response.code == 404
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url("users/me"), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def create_submission(assignment_branch, assignment_comment_link, checkpoint_id, comment, enrollment_id)
    response = self.class.post(api_url("checkpoint_submissions"),
    body: {
      assignment_branch: assignment_branch,
      assignment_comment_link: assignment_comment_link,
      checkpoint_id: checkpoint_id,
      comment: comment,
      enrollment_id: enrollment_id
      }, headers: { "authorization" => @auth_token })
  end

  private
  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
end
