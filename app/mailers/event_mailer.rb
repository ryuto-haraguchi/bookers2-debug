class EventMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"] 
  
  def event_notice_email(group, subject, content)
    @group = group
    @content = content
    mail(
      to: @group.members.pluck(:email),
      subject: subject
      )
  end
end