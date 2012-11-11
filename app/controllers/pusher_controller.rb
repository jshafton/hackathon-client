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
    player_email = params[:player_email]

    if player_email
      hash = Digest::MD5.hexdigest(player_email)
      gravatar_url = "https://www.gravatar.com/avatar/#{hash}"
    end

    channel_name = player_name.gsub(/[^A-Za-z0-9_\-=@,.;]/, '')

    Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => player_id,
      :user_info => { # => optional - for example
        :name            => player_name,
        :email           => player_email,
        :gravatar_url    => gravatar_url,
        :private_channel => "private-#{channel_name}"
      }
    })
  end
end
