require 'vkontakte_api'

class Manage::VkController < Manage::ApplicationController
  def get_token
    redirect_to VkontakteApi.authorization_url(scope: 'photos', redirect_uri: manage_new_vk_token_url, response_type: 'token')
  end

  def new_token
    @vk_token = VkToken.new
  end

  def create_token
    @vk_token = VkToken.new(params[:vk_token])

    if @vk_token.save
      redirect_to manage_root_path
    else
      render :new_token
    end
  end
end
