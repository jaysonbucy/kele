require 'httparty'

class Kele
  include HTTParty

  def initialize(email, password)
    response = self.class.post(session_url("sessions"), body: { "email": email, "password": password })
  end
end
