class User < ApplicationRecord

  VALIDATE_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates :name, presence: true, uniqueness: true
  has_secure_password

  after_destroy :ensure_an_admin_remains

  validates :email, allow_nil: true, uniqueness: true, format: {
    with: VALIDATE_EMAIL_REGEX,
    message: 'incorrect email format'
  }

  class Error < StandardError
  end

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't delete last user"
      end
    end     
end
