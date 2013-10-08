class CompiledDocument < ActiveRecord::Base
  
  enum_accessor :status, [ :pending, :compilation_succeed, :compilation_fail ]
  
  belongs_to :project
  
end
