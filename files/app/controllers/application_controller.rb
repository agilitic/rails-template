class ApplicationController < ActionController::Base
  helper :all
  
  filter_parameter_logging :password
  helper_method :current_user
  
  # Filters ====================================================================
  
  def login_required
    redirect_to login_path unless current_user
  end
  
  def login_and_admin_required
    redirect_to login_path unless (current_user && current_user.admin?)
  end

  # Methods ====================================================================

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
end