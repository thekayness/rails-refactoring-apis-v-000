class GithubService

  attr_reader :access_token

  def initialize(access_hash = nil)
    @access_token = access_hash["access_token"] if access_hash
  end

  def authenticate!(client_id, client_secret, code)
    auth = Faraday.post("https://github.com/login/oauth/access_token") do |request|
      request.params['client_id'] = client_id
      request.params['client_secret'] = client_secret
      request.params['code'] = code
      request.headers = { Accept: 'application/json' }
    end
    access_hash = JSON.parse(auth.body)
    @access_token = access_hash["access_token"]
  end

  def get_username(token)
    user_response = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{token}", 'Accept' => 'application/json'}
    user_json = JSON.parse(user_response.body)
    user_json["login"]
  end

  def get_repos(token)
    response = Faraday.get "https://api.github.com/user/repos", {}, {'Authorization' => "token #{token}", 'Accept' => 'application/json'}
    repos_array = JSON.parse(response.body)
    repos_array.map{|repo| GithubRepo.new(repo) }
  end

  def create_repo(name, token)
    Faraday.post "https://api.github.com/user/repos", {name: name}.to_json, {'Authorization' => "token #{token}", 'Accept' => 'application/json'}
  end

end