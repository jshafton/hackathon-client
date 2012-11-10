class PusherController < ApplicationController
  def auth
    render :json => get_auth_json
  end

  def auth_jsonp
    response = get_auth_json
    render :text => params[:callback] + "(" + response.to_json + ")"
  end

  private

  def get_auth_json
    player_id = params[:player_name]
    player_name = params[:player_name]
    Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => player_id,
      :user_info => { # => optional - for example
        :name => player_name,
        :private_channel => "private-#{player_name}"
      }
    })
  end
end
