# frozen_string_literal: true

require 'bcrypt'

# Model for user
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :password_digest, type: String

  attr_accessor :password

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i
  PASSWORD_REGEX = /\A
      (?=.{8,16}) # 8 to 16 characters
      (?=.*[a-z]) # at least one lowercase letter
      (?=.*[A-Z]) # at least one uppercase letter
  /x

  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :password_digest, presence: true, format: { with: PASSWORD_REGEX }, allow_nil: true

  before_save :encrypt_password

  def authenticate(password)
    if BCrypt::Password.new(password_digest) == password
      self
    else
      false
    end
  end

  private

  def encrypt_password
    self.password_digest = BCrypt::Password.create(password)
  end
end
