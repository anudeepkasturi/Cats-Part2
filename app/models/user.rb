# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :user_name, uniqueness: true

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat

  attr_reader :password

  after_initialize :ensure_session_token

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    bc_object = BCrypt::Password.new(self.password_digest)
    bc_object.is_password?(password)
  end

  def self.reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def self.find_by_credentials(user_name, password)
    possible_user = User.find_by(user_name: user_name)
    return nil unless possible_user
    possible_user.is_password?(password) ? possible_user : nil
  end


end
