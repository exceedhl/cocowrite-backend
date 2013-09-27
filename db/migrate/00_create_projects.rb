class CreateProjects < ActiveRecord::Migration
  def up
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :uuid
      t.datetime :created_at
    end
    
    def down
      drop_table :projects
    end
  end
end
