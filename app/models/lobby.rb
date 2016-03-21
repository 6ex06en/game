class Lobby < ActiveRecord::Base
  belongs_to :user
  belongs_to :guest, foreign_key: "guest_id", class_name: "User"

  validates :name, presence: true
end
