class RegisteredLobby < ActiveRecord::Base

  has_many :organization_registered_lobbies, dependent: :destroy
  has_many :organizations, through: :organization_registered_lobby

end
