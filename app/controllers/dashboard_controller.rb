class DashboardController < ApplicationController
  before_action :to_login_if_no_session
  def home
  end

  #   redirect_to orders_path, notice: 'Orders synchronized successfully!'
  # end
end
