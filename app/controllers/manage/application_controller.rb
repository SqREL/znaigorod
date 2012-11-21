class Manage::ApplicationController < InheritedResources::Base
  helper_method :per_page

  layout 'manage'

  private

  def per_page
    @per_page ||= Settings['pagination.per_page'] || 10
  end
end
