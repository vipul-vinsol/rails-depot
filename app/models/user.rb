class User < ApplicationRecord

  VALIDATE_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates :name, presence: true, uniqueness: true
  has_secure_password

  after_create :notify_with_welcome_email, if: :email?
  before_update :check_if_user_is_admin
  before_destroy :check_if_user_is_admin
  after_destroy :ensure_an_admin_remains

  validates :email, allow_nil: true, uniqueness: true, format: {
    with: VALIDATE_EMAIL_REGEX,
    message: 'incorrect email format'
  }

  has_many :orders

  has_many :line_items, through: :orders

  class Error < StandardError
  end

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't delete last user"
      end
    end

    def notify_with_welcome_email
      UserMailer.created(self).deliver
    end

    def check_if_user_is_admin
      if email == 'admin@depot.com'
        errors.add(:email, 'cannot update or delete admin')
        throw :abort
      end
    end
end
