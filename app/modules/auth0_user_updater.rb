module Auth0UserUpdater
  require 'net/http'
  require 'json'
  require 'uri'

  def self.update_name(new_email:, auth0_id:)
    # 1. Access Tokenの取得
    uri = URI("https://#{AUTH0_CONFIG['auth0_domain']}/oauth/token")
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = {
      grant_type: 'client_credentials',
      client_id: AUTH0_CONFIG['auth0_client_id'],
      client_secret: AUTH0_CONFIG['auth0_client_secret'],
      audience: "https://#{AUTH0_CONFIG['auth0_domain']}/api/v2/",
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
    access_token = JSON.parse(response.body)['access_token']

    # 2. ユーザーの更新
    # auth0_idが | を含んでいるためencord
    encoded_auth0_id = CGI.escape(auth0_id)
    update_uri = URI("https://#{AUTH0_CONFIG['auth0_domain']}/api/v2/users/#{encoded_auth0_id}")

    update_request =
      Net::HTTP::Patch.new(
        update_uri,
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{access_token}",
      )
    update_request.body = { name: "#{new_email}" }.to_json

    update_response =
      Net::HTTP.start(update_uri.hostname, update_uri.port, use_ssl: true) { |http| http.request(update_request) }

    if update_response.code == '200'
      updated_data = JSON.parse(update_response.body)
      updated_data['name']
    else
      nil
    end
  end
end
