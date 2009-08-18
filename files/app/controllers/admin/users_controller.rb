class Admin::UsersController < Admin::BaseController
  # Actions ====================================================================
  def index
    @users = get_users
  end
  
  def show
    @user = get_user
  end
  
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
    @user = get_user
  end
  
  def update
    @user = get_user
    if @user.update_attributes(params[:user])
      redirect_to users_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = get_user
    @user.destroy
    redirect_to users_path
  end
  
  # Methods ====================================================================
  
  protected
  
  def get_users
    User.all(:order => 'username ASC')
  end
  
  def get_user
    User.find(params[:id])
  end
end