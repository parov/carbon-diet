class FriendsController < AuthenticatedController

  def index
    redirect_to :action => 'list'
  end
 
  def list
    @pagename = 'My Friends'
    # Generate league table
    @leaguetable = []
    @current_user.friends.each { |u| @leaguetable << { :user => u, :total => (u.annual_emissions > 0 and u.public) ? u.annual_emissions : 9e99 } }
    @leaguetable << { :user => @current_user, :total => @current_user.annual_emissions > 0 ? @current_user.annual_emissions : 9e99 }
    @leaguetable = @leaguetable.sort{ |x,y| x[:total] <=> y[:total] }
    # Generate pie chart URL
    @pie_url = url_for(:controller => "xml_chart", :action => "pie_friends")
  end
 
  def add
    @current_user.add_friend(User.find(params[:id])) rescue flash[:notice] = 'Unknown user'
    redirect_to :action => 'list'
  end

  def remove
    @current_user.remove_friend(User.find(params[:id])) rescue flash[:notice] = 'Unknown user'
    redirect_to :action => 'list'
  end

  def accept
    @current_user.approve_friend_request(User.find(params[:id])) rescue flash[:notice] = 'Unknown user'
    redirect_to :action => 'list'
  end

  def reject
    @current_user.reject_friend_request(User.find(params[:id])) rescue flash[:notice] = 'Unknown user'
    redirect_to :action => 'list'
  end

  def send_invitations
    unless verify_recaptcha
      flash[:notice] = 'Incorrect word verification! Please try again.'
      params[:recaptcha_response_field] = ""
      render :action => 'invite'
      return
    end
    sent = 0
    10.times do |i|
      email = params[:email]["user#{i}"]
      unless email.blank? or email !~ /^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i        
        sent += 1 if UserMailer.deliver_friend_invitation(@current_user, email, params[:group][:id])
      end
    end
    if sent > 0
      flash[:notice] = "Invitations sent!"
    end
    redirect_to :action => 'list'
  end

  def invite
    @group_list = [["",0]]
    @current_user.groups.each { |group| @group_list << [group.name, group.id] }
  end

end
