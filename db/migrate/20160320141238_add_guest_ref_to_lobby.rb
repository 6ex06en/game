class AddGuestRefToLobby < ActiveRecord::Migration
  def change
    add_reference :lobbies, :guest, index: true, foreign_key: true
  end
end
