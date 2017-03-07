class Unauthorized < StandardError
  def initialize(msg="Unauthorized use.")
    super
  end
end
