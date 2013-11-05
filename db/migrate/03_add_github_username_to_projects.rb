class AddGithubUsernameToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :github_username, :string
  end
end
