# encoding: utf-8

class SaunaDecorator < SuborganizationDecorator
  decorates :sauna

  def characteristics_on_list
    characteristics_by_type("features offers")
  end

  def characteristics_on_show
    #"Find me at #{__FILE__}:#{__LINE__}"
  end
end
