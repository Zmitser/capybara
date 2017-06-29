
class User
  attr_accessor :username, :password

  def initialize(params = {})
    @username = params[:username]
    @password = params[:password]
  end
end