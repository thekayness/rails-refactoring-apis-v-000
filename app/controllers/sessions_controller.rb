class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create

  def create
    github = GithubService.new
   	get_code = Faraday.get("https://github.com/login/oauth/authorize") do |request|
      request.params['client_id'] = ENV['GITHUB_CLIENT']
  	end
  	auth_code = params[:code]
   	session['token'] = github.authenticate!(ENV['GITHUB_CLIENT'], ENV['GITHUB_SECRET'], auth_code)
    session[:username] = github.get_username(session['token'])

    redirect_to '/'
  end
end