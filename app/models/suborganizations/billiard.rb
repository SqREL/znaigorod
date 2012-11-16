class Billiard < Entertainment
  has_many :pool_tables, :dependent => :destroy
end
