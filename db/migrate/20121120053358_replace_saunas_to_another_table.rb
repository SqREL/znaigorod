# encoding: utf-8

class ReplaceSaunasToAnotherTable < ActiveRecord::Migration
  class LegacySauna < ActiveRecord::Base
    self.table_name = 'saunas'

    belongs_to :organization

    has_many :sauna_halls, :dependent => :destroy, :foreign_key => :sauna_id

    has_one :sauna_accessory,   :dependent => :destroy, :foreign_key => :sauna_id
    has_one :sauna_broom,       :dependent => :destroy, :foreign_key => :sauna_id
    has_one :sauna_alcohol,     :dependent => :destroy, :foreign_key => :sauna_id
    has_one :sauna_oil,         :dependent => :destroy, :foreign_key => :sauna_id
    has_one :sauna_child_stuff, :dependent => :destroy, :foreign_key => :sauna_id
    has_one :sauna_stuff,       :dependent => :destroy, :foreign_key => :sauna_id
    has_one :sauna_massage,     :dependent => :destroy, :foreign_key => :sauna_id
  end

  def attributes_for(record)
    attributes = record.attributes
    excluded_attributes = %w[created_at updated_at id sauna_id sauna_hall_id]

    attributes.delete_if { |attribute, _| excluded_attributes.include? attribute }
  end

  def up
    if ActiveRecord::Base.connection.table_exists?(:saunas)
      puts "=== Before ==="
      puts "LegacySauna.count             is #{LegacySauna.count}"
      puts "SaunaHall.count               is #{SaunaHall.count}"
      puts "SaunaHallBath.count           is #{SaunaHallBath.count}"
      puts "SaunaHallCapacity.count       is #{SaunaHallCapacity.count}"
      puts "SaunaHallEntertainment.count  is #{SaunaHallEntertainment.count}"
      puts "SaunaHallInterior.count       is #{SaunaHallInterior.count}"
      puts "SaunaHallPool.count           is #{SaunaHallPool.count}"
      puts "SaunaAccessory.count          is #{SaunaAccessory.count}"
      puts "SaunaBroom.count              is #{SaunaBroom.count}"
      puts "SaunaAlcohol.count            is #{SaunaAlcohol.count}"
      puts "SaunaOil.count                is #{SaunaOil.count}"
      puts "SaunaChildStuff.count         is #{SaunaChildStuff.count}"
      puts "SaunaMassage.count            is #{SaunaMassage.count}"
      puts "Entertainment.where(:type => nil, :category => 'Сауны').count is #{Entertainment.where(:type => nil, :category => 'Сауны').count}"

      LegacySauna.find_each do |legacy_sauna|
        organization = legacy_sauna.organization

        organization.update_attributes! :priority_suborganization_kind => 'sauna'

        sauna = organization.create_sauna!(:category => 'Сауны')

        legacy_sauna.sauna_halls.each do |legacy_sauna_hall|
          sauna_hall = sauna.sauna_halls.create!(attributes_for(legacy_sauna_hall))

          legacy_sauna_hall.sauna_hall_schedules.each do |sauna_hall_schedule|
            sauna_hall.sauna_hall_schedules.create! attributes_for(sauna_hall_schedule)
          end

          sauna_hall.create_sauna_hall_bath! attributes_for(legacy_sauna_hall.sauna_hall_bath) if legacy_sauna_hall.sauna_hall_bath
          sauna_hall.create_sauna_hall_capacity! attributes_for(legacy_sauna_hall.sauna_hall_capacity) if legacy_sauna_hall.sauna_hall_capacity
          sauna_hall.create_sauna_hall_entertainment! attributes_for(legacy_sauna_hall.sauna_hall_entertainment) if legacy_sauna_hall.sauna_hall_entertainment
          sauna_hall.create_sauna_hall_interior! attributes_for(legacy_sauna_hall.sauna_hall_interior) if legacy_sauna_hall.sauna_hall_interior
          sauna_hall.create_sauna_hall_pool! attributes_for(legacy_sauna_hall.sauna_hall_pool) if legacy_sauna_hall.sauna_hall_pool
        end

        sauna.create_sauna_accessory! attributes_for(legacy_sauna.sauna_accessory) if legacy_sauna.sauna_accessory
        sauna.create_sauna_broom! attributes_for(legacy_sauna.sauna_broom) if legacy_sauna.sauna_broom
        sauna.create_sauna_alcohol! attributes_for(legacy_sauna.sauna_alcohol) if legacy_sauna.sauna_alcohol
        sauna.create_sauna_oil! attributes_for(legacy_sauna.sauna_oil) if legacy_sauna.sauna_oil
        sauna.create_sauna_child_stuff! attributes_for(legacy_sauna.sauna_child_stuff) if legacy_sauna.sauna_child_stuff
        sauna.create_sauna_stuff! attributes_for(legacy_sauna.sauna_stuff) if legacy_sauna.sauna_stuff
        sauna.create_sauna_massage! attributes_for(legacy_sauna.sauna_massage) if legacy_sauna.sauna_massage

        legacy_sauna.destroy
      end


      puts "=== After ==="
      puts "LegacySauna.count             is #{LegacySauna.count}"
      puts "SaunaHall.count               is #{SaunaHall.count}"
      puts "SaunaHallBath.count           is #{SaunaHallBath.count}"
      puts "SaunaHallCapacity.count       is #{SaunaHallCapacity.count}"
      puts "SaunaHallEntertainment.count  is #{SaunaHallEntertainment.count}"
      puts "SaunaHallInterior.count       is #{SaunaHallInterior.count}"
      puts "SaunaHallPool.count           is #{SaunaHallPool.count}"
      puts "SaunaAccessory.count          is #{SaunaAccessory.count}"
      puts "SaunaBroom.count              is #{SaunaBroom.count}"
      puts "SaunaAlcohol.count            is #{SaunaAlcohol.count}"
      puts "SaunaOil.count                is #{SaunaOil.count}"
      puts "SaunaChildStuff.count         is #{SaunaChildStuff.count}"
      puts "SaunaMassage.count            is #{SaunaMassage.count}"

      Entertainment.where(:type => nil, :category => 'Сауны').destroy_all
      puts "Entertainment.where(:type => nil, :category => 'Сауны').count is #{Entertainment.where(:type => nil, :category => 'Сауны').count}"

      drop_table :saunas
    end
  end

  def down
  end
end
