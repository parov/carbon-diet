class ProfileController < ApplicationController
  before_filter :get_current_user

  def index
    if not @current_user.nil? and (params[:login] == @current_user.login or params[:login].nil?)
      @profile = @current_user
    else
      @profile = User.find_by_login_and_public(params[:login], true)
    end
    if @profile.nil?
      flash[:notice] = "Profile not found!"
      redirect_to :controller => 'search'
      return
    end
    # Get emissions data
    @period = report_period
    @pie_url = url_for(:controller => "xml_chart", :action => "pie_all", :period => @period, :user => @profile.id)
    @line_url = url_for(:controller => "xml_chart", :action => "line_all", :period => @period, :user => @profile.id)
    @line_settings_url = url_for(:controller => "xml_chart", :action => "line_all_settings", :period => @period, :user => @profile.id)
    @show_flight_controls = @profile.flights.count > 0 ? true : false;
    @totals = @profile.calculate_totals(@period)
    # Get comments
    @comments = @profile.comments.find(:all, :limit => 5)
    # Get actions
    @actions = get_actions(3) if @profile == @current_user
  end

  def feed
    @user = User.find_by_guid(params[:id])
    @comments = @user.comments.find(:all, :order => "created_at DESC", :limit => 10)
    # Send data
    headers["Content-Type"] = "application/atom+xml"
    render :action => 'atom.rxml', :layout => false
  end

private

  def report_period
    days = Date::today - @profile.date_of_first_data
    return days < 365 ? days : 365
  end
  
end