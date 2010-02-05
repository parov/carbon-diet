class MainController < ApplicationController

  def index
    redirect_to_main_page if @current_user
    session[:next] = params[:to] unless params[:to].nil?
    respond_to do |format|
      format.html
      format.iphone { render_iphone }
      format.wml
    end
  end

  def mobile
    # Force mobile mode - allow escape though...
    session[:wap] = (params[:enable] == "false" ? nil : true)
    redirect_to_main_page
  end

end
