class UsersController < ApplicationController
  respond_to :html #, :json, :datatables

  expose(:users) { User.all }
  expose(:user)
  
  def create
    if user.save
      flash[:notice] = 'User was successfully created.' 
      redirect_to users_path
    else
      flash[:error] = 'User could not be saved. Please check your input.'
      respond_with user
    end
  end

  def update
    if user.update_attributes(params[:user])  
      flash[:notice] = 'User was successfully updated.'
      redirect_to users_path
    else
      flash[:error] = 'User could not be saved. Please check your input.'
      respond_with user 
    end  
  end  

  def destroy
    user.destroy
    flash[:notice] = 'User was successfully deleted.'
    redirect_to users_path
  end
  
end
