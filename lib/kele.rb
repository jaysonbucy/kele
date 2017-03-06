require 'httparty'

class Kele

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: { email: email, password: password })
  end

  private
  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
end
