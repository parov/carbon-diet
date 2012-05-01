require 'spec_helper'

describe "UserMailer", ActiveSupport::TestCase do

  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  fixtures :users
  fixtures :groups

  #include ActionMailer::Quoting

  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    #@expected = TMail::Mail.new
    #@expected.set_content_type "text", "plain", { "charset" => CHARSET }
    #@expected.mime_version = '1.0'
  end

  it "reminder" do
    pending 'actionmailer fixes'
    user = User.find(1)
    @expected.subject = 'A reminder from the Carbon Diet'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = user.confirmed_email
    @expected.body    = read_fixture('reminder')
    @expected.date    = Time.now
    assert_equal @expected.encoded, UserMailer.create_reminder(user, @expected.date).encoded
  end

  it "password change" do
    pending 'actionmailer fixes'
    # Change user password
    srand(42)
    User.find(1).reset_password
    # Send reminder email
    @expected.subject = 'Carbon Diet: Password change request'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = 'james@carbondiet.org'
    @expected.body    = read_fixture('password_change')
    @expected.date    = Time.now
    assert_equal @expected.encoded, UserMailer.create_password_change(User.find(1).email, "http://www.carbondiet.org/user/change_password/" + User.find(1).password_change_code, @expected.date).encoded
  end

  it "group invitation" do
    pending 'actionmailer fixes'
    @expected.subject = 'Carbon Diet: Group invitation'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = 'james@carbondiet.org'
    @expected.body    = read_fixture('group_invitation')
    @expected.date    = Time.now
    assert_equal @expected.encoded, UserMailer.create_group_invitation(Group.find(1), User.find(1), @expected.date).encoded
  end

  it "friend request" do
    pending 'actionmailer fixes'
    user = User.find(2)
    friend = User.find(1)
    @expected.subject = 'Carbon Diet: Friend request'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = friend.confirmed_email
    @expected.body    = read_fixture('friend_request')
    @expected.date    = Time.now
    assert_equal @expected.encoded, UserMailer.create_friend_request(user, friend, @expected.date).encoded
  end

  it "comment notification" do
    pending 'actionmailer fixes'
    @expected.subject    = 'Carbon Diet: Someone wrote a comment on your profile!'
    @expected.from       = 'info@carbondiet.org'
    @expected.to         = 'james@carbondiet.org'
    @expected.body       = read_fixture('comment_notification')
    @expected.date       = Time.now
    assert_equal @expected.encoded, UserMailer.create_comment_notification(User.find(1), User.find(2), @expected.date).encoded
  end

  it "email confirmation" do
    pending 'actionmailer fixes'
    # Set email confirmation code
    user = User.find(44)
    user.email  = "james@carbondiet.org"
    user.save!
    # Prepare expected response
    @expected.subject    = 'Carbon Diet: Please confirm your email address'
    @expected.from       = 'info@carbondiet.org'
    @expected.to         = user.email
    @expected.body       = read_fixture('email_confirmation')
    @expected.date       = Time.now
    assert_equal @expected.encoded, UserMailer.create_email_confirmation(user, @expected.date).encoded
  end

  it "friend invitation" do
    pending 'actionmailer fixes'
    @expected.subject    = 'An invitation to join The Carbon Diet'
    @expected.from       = 'info@carbondiet.org'
    @expected.to         = 'james@carbondiet.org'
    @expected.body       = read_fixture('friend_invitation')
    @expected.date       = Time.now
    assert_equal @expected.encoded, UserMailer.create_friend_invitation(User.find(1), "james@carbondiet.org", "0", @expected.date).encoded
  end

  it "friend invitation with group" do
    pending 'actionmailer fixes'
    @expected.subject    = 'An invitation to join The Carbon Diet'
    @expected.from       = 'info@carbondiet.org'
    @expected.to         = 'james@carbondiet.org'
    @expected.body       = read_fixture('friend_invitation_with_group')
    @expected.date       = Time.now
    assert_equal @expected.encoded, UserMailer.create_friend_invitation(User.find(1), "james@carbondiet.org", "2", @expected.date).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/user_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
