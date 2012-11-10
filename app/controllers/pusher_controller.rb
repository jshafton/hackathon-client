class PusherController < ApplicationController
  def auth
    player_id = params[:player_name]
    player_name = params[:player_name]
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => player_id,
      :user_info => { # => optional - for example
        :name => player_name,
        :private_channel => "private-#{player_name}"
      }
    })
    render :json => response
  end
end
