module Message

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
    }, headers: { "authorization" => @auth_token })
  end

end
