class SessionsController < ApplicationController
  def new
  end

  def create
    # Add your authentication logic here
    # For simplicity, let's assume a hardcoded username and password
    if params[:session][:username] == 'amtxlog' && params[:session][:password] == '4Mix162!'
      session[:user_id] = 1 # You might want to use a proper user ID
      redirect_to orders_path, notice: 'Login successful!'
    else
      flash.now[:alert] = 'Invalid username or password'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out successfully!'
  end
end