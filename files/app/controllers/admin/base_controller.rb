class Admin::BaseController < ApplicationController
  layout 'admin'
  
  # Filters ====================================================================
  
  before_filter :login_and_admin_required
  
  # Actions ====================================================================
  
  # Methods ====================================================================
  
  protected
end