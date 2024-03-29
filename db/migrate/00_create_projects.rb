class CreateProjects < ActiveRecord::Migration
  def up
    create_table :projects do |t|
      t.string :name
      t.string :full_name
      t.string :description
      t.string :url
      t.string :uuid
      t.datetime :created_at, :default => Time.now
    end
    
    def down
      drop_table :projects
    end
  end
end
