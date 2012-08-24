# encoding: utf-8


class ApplicationController < ActionController::Base

  helper_method :banners, :hot_offers, :page, :per_page

  layout 'public'

  def main_page
    @affiche_today = AfficheToday.new('movie')
    @affiches = AfficheDecorator.decorate(@affiche_today.affiches)
    @photoreport = Photoreport.new
    @photoreports = PhotoreportDecorator.decorate(@photoreport.reports_for_main_page)
  end

  private
    def page
      params[:page].blank? ? 1 : params[:page].to_i
    end

    def per_page
      @per_page ||= Settings['pagination.per_page'] || 10
    end

    def paginate_options
      {
        :page       => page,
        :per_page   => per_page
      }
    end

    def hot_offers
      all_offers[-6..-1]
    end

    def all_offers
      [
        'meals/Пиццерии',
        'meals/Завтраки',
        'meals/Бизнес-Ланч',
        'meals/Детские Кафе',
        'entertainments/Бильярдные Залы',
        'meals/Столовые',
        'meals/Кофейни',
        'meals/Wi-Fi',
        'entertainments/Боулинг',
      ]
    end

    def banners
      Affiche.with_images.with_showings.latest(4)
    end

end
