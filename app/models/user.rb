class User < ActiveRecord::Base
  has_one :lobby, dependent: :destroy
  has_one :guest_lobby, class_name: "Lobby", foreign_key: "guest_id"

  validates :name,  presence: true, length: { maximum: 50 }
  validates :password, length: { minimum: 6 }, confirmation: true
  validates :password_confirmation, presence: true, on: :create
  has_secure_password

  before_create :create_remember_token

  def User.new_remember_token
      SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
  end

  def join_lobby(id)
    Lobby.find_by(id: id).update_attributes(guest_id: self.id)
  end

  def leave_lobby
    guest_lobby.update_attributes(guest_id: nil) if guest_lobby
    lobby.destroy if lobby
  end

  def owner_lobby?
    !!lobby
  end

  private

  def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
  end
end
