require 'uuidtools'

class Session < ActiveRecord::Base
  
  after_initialize :default_values

  private
  def default_values
    self.uuid ||= UUIDTools::UUID.random_create.to_s
  end
end
