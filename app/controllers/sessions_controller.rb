class SessionsController < ApplicationController
  layout "full"
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.password_digest == params[:password]
      log_in user
      redirect_to "/dashboard/home"
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to :controller => 'sessions', :action => 'new'
  end
end