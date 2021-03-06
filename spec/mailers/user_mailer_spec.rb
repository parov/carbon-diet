require 'spec_helper'

describe "UserMailer", ActiveSupport::TestCase do

  fixtures :users
  fixtures :groups

  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    #@expected = TMail::Mail.new
    #@expected.set_content_type "text", "plain", { "charset" => CHARSET }
    #@expected.mime_version = '1.0'
  end

  it "reminder" do
    user = User.find(1)
    @expected.subject = 'A reminder from the Carbon Diet'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = user.confirmed_email
    @expected.body    = read_mail_fixture('user_mailer', 'reminder')
    @expected.date    = Time.now
    assert_equal @expected.body.encoded, UserMailer.reminder(user, @expected.date).body.encoded
  end

  it "password change" do
    # Change user password
    srand(42)
    User.find(1).reset_password
    # Send reminder email
    @expected.subject = 'Carbon Diet: Password change request'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = 'james@carbondiet.org'
    @expected.body    = read_mail_fixture('user_mailer', 'password_change')
    @expected.date    = Time.now
    assert_equal @expected.body.encoded, UserMailer.password_change(User.find(1).email, "http://www.carbondiet.org/user/change_password/" + User.find(1).password_change_code, @expected.date).body.encoded
  end

  it "group invitation" do
    @expected.subject = 'Carbon Diet: Group invitation'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = 'james@carbondiet.org'
    @expected.body    = read_mail_fixture('user_mailer', 'group_invitation')
    @expected.date    = Time.now
    assert_equal @expected.body.encoded, UserMailer.group_invitation(Group.find(1), User.find(1), @expected.date).body.encoded
  end

  it "friend request" do
    user = User.find(2)
    friend = User.find(1)
    @expected.subject = 'Carbon Diet: Friend request'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = friend.confirmed_email
    @expected.body    = read_mail_fixture('user_mailer', 'friend_request')
    @expected.date    = Time.now
    assert_equal @expected.body.encoded, UserMailer.friend_request(user, friend, @expected.date).body.encoded
  end

  it "comment notification" do
    @expected.subject    = 'Carbon Diet: Someone wrote a comment on your profile!'
    @expected.from       = 'info@carbondiet.org'
    @expected.to         = 'james@carbondiet.org'
    @expected.body       = read_mail_fixture('user_mailer', 'comment_notification')
    @expected.date       = Time.now
    assert_equal @expected.body.encoded, UserMailer.comment_notification(User.find(1), User.find(2), @expected.date).body.encoded
  end

  it "email confirmation" do
    # Set email confirmation code
    user = User.find(44)
    user.email  = "james@carbondiet.org"
    user.save!
    # Prepare expected response
    @expected.subject    = 'Carbon Diet: Please confirm your email address'
    @expected.from       = 'info@carbondiet.org'
    @expected.to         = user.email
    @expected.body       = read_mail_fixture('user_mailer', 'email_confirmation')
    @expected.date       = Time.now
    assert_equal @expected.body.encoded, UserMailer.email_confirmation(user, @expected.date).body.encoded
  end

  it "friend invitation" do
    @expected.subject    = 'An invitation to join The Carbon Diet'
    @expected.from       = 'info@carbondiet.org'
    @expected.to         = 'james@carbondiet.org'
    @expected.body       = read_mail_fixture('user_mailer', 'friend_invitation')
    @expected.date       = Time.now
    assert_equal @expected.body.encoded, UserMailer.friend_invitation(User.find(1), "james@carbondiet.org", "0", @expected.date).body.encoded
  end

  it "friend invitation with group" do
    @expected.subject    = 'An invitation to join The Carbon Diet'
    @expected.from       = 'info@carbondiet.org'
    @expected.to         = 'james@carbondiet.org'
    @expected.body       = read_mail_fixture('user_mailer', 'friend_invitation_with_group')
    @expected.date       = Time.now
    assert_equal @expected.body.encoded, UserMailer.friend_invitation(User.find(1), "james@carbondiet.org", "2", @expected.date).body.encoded
  end
  
end
