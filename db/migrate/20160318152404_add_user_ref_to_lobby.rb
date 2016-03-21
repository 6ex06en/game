class AddUserRefToLobby < ActiveRecord::Migration
  def change
    add_reference :lobbies, :user, index: true, foreign_key: true
  end
end
