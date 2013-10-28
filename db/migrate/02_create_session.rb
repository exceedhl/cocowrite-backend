class CreateSession < ActiveRecord::Migration
  def up
    create_table :sessions do |t|
      t.string :uuid
      t.string :github_token
      t.string :github_username
      t.datetime :created_at, :default => Time.now
    end
    
    def down
      drop_table :sessions
    end
  end
end
