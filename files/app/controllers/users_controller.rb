class UsersController < BaseController
  # Actions ====================================================================  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new
    if @user.save
      redirect_to users_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to users_path
    else
      render :action => 'edit'
    end
  end
end