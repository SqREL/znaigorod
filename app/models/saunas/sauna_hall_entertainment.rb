class SaunaHallEntertainment < ActiveRecord::Base
  belongs_to :sauna_hall
  attr_accessible :aerohockey, :billiard, :ping_pong
  attr_accessible :hookah, :karaoke, :tv, :guitar
  attr_accessible :checkers, :chess, :backgammon
end

# == Schema Information
#
# Table name: sauna_hall_entertainments
#
#  id            :integer          not null, primary key
#  sauna_hall_id :integer
#  karaoke       :integer
#  tv            :integer
#  billiard      :integer
#  ping_pong     :integer
#  hookah        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  aerohockey    :integer
#  checkers      :integer
#  chess         :integer
#  backgammon    :integer
#  guitar        :integer
#

