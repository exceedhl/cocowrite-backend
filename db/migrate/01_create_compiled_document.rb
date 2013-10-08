class CreateCompiledDocument < ActiveRecord::Migration
  def up
    create_table :compiled_documents do |t|
      t.string :status, :default => 'pending'
      t.integer :project_id
      t.string :sha
      t.string :format
      t.datetime :created_at, :default => Time.now
    end
    
    def down
      drop_table :compiled_documents
    end
  end
end
