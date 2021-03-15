class EventMailer < ApplicationMailer

  def registration
    @user = params[:user]
    @event = params[:event]

    mail(to: @user.email, subject: 'Registration')
  end

  def recall
    @user = params[:user]
    @event = params[:event]

    mail(to: @user.email, subject: 'Notification')
  end

  def thank_you
    @user = params[:user]
    @event = params[:event]

    mail(to: @user.email, subject: 'Thank You')
  end
end
