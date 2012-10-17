class Sauna < ActiveRecord::Base
  belongs_to :organization
  # attr_accessible :title, :body
end
