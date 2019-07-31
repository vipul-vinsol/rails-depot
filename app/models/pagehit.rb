class Pagehit < ApplicationRecord
  validates :page, presence: true
  validates :page, uniqueness: true
end
