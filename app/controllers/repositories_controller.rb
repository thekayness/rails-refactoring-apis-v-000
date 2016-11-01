class RepositoriesController < ApplicationController
  def index
    if logged_in?
      github = GithubService.new
      @repos_array = github.get_repos(session[:token])
    end
  end

  def create
  	if logged_in? && !params[:name].empty?
  		github = GithubService.new
  		github.create_repo(params[:name], session[:token])
      redirect_to root_path
  	end
  end
end
