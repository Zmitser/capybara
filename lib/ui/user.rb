require 'securerandom'
require 'digest/md5'
class User
  attr_accessor :username, :password, :email, :hash_email, :message
  def values_at(*attributes)
    attributes.map { |attribute| send(attribute) }
  end
  def initialize(params = {})
    @username = SecureRandom.hex(3)
    @password =  SecureRandom.hex(3)
    @email = "#{SecureRandom.hex(3)}#{params[:email_domain]}"
    @hash_email = Digest::MD5.new.update(email).hexdigest
  end
end