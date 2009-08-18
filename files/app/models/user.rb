class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_confirmation_of :password
end