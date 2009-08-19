class UserSessionsController < BaseController
  # Filters ====================================================================
  
  before_filter :login_required,
    :only => [:destroy]
    
  before_filter :no_login_required,
    :only => [:new, :create]
  
  # Actions ====================================================================
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if current_user.admin?
        redirect_to admin_root_path
      else
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to root_url
  end
end