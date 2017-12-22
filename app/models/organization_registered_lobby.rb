class OrganizationRegisteredLobby < ActiveRecord::Base

  belongs_to :organization
  belongs_to :registered_lobby

end
