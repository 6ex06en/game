module LobbiesHelper

  def has_lobby?
    lobby.present?
  end

  def lobby
    current_user.lobby || current_user.guest_lobby
  end
end
