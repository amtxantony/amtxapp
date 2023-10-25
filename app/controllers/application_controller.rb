class ApplicationController < ActionController::Base
	helper_method :current_user, :logged_in? 


	private

	def log_in(user)
	    session[:user_id] = user.id
	  end

	  def current_user
	    @current_user ||= User.find_by(id: session[:user_id])
	  end

	  def logged_in?
	  	!current_user.nil?
	  end

	  def to_login_if_no_session
	  	if current_user.nil? && "#{params[:controller]}/#{params[:action]}" != "sessions/new"
	    	redirect_to "/sessions/new"
	    end
	  end

	  def log_out
	    session.delete(:user_id)
	    @current_user = nil
	  end
end
