class VkToken < ActiveRecord::Base
  attr_accessible :token, :expires_in

  after_validation :actualize

  scope :active, where(:active => true)

  default_value_for :active, true

  def self.check
    if (Time.zone.now - VkToken.active.first.created_at) >= VkToken.active.first.expires_in
      VkToken.rottenize
    end
  end

  def self.active_token
    active.first.token
  end

  private
    def actualize
      VkToken.rottenize
    end

    def self.rottenize
      VkToken.update_all(:active => false)
    end
end
