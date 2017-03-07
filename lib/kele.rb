require 'httparty'
require 'json'
require 'pry'

require_relative 'unauthorized'
require_relative 'roadmap'

class Kele
  include HTTParty
  include Roadmap

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

  def get_messages(page=nil)
    if page == nil
      response = self.class.get(api_url("message_threads"), headers: { "authorization" => @auth_token })
    else
      response = self.class.get(api_url("message_threads?page=#{page}"), headers: { "authorization" => @auth_token })
    end
    @messages = JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, stripped_text)
    response = self.class.post(api_url("messages"),
    body: {
      sender: sender,
      recipient_id: recipient_id,
      token: token,
      subject: subject,
      stripped_text: stripped_text
    },
    headers: { "authorization" => @auth_token })
  end

  private
  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
end
