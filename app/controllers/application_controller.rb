class ApplicationController < ActionController::Base
	#before_action :authenticate_user!

	private

	def authenticate_user!
		redirect_to root_path, alert: 'Unauthorized access!' unless session[:user_id].present?
	end
end
