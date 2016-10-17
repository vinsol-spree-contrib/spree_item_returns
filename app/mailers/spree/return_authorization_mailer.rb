module Spree
  class ReturnAuthorizationMailer < BaseMailer

    def notify_return_initialization_to_admin(return_auth_number)
      @return_authorization = Spree::ReturnAuthorization.find_by(number: return_auth_number)
      subject = Spree.t(:subject, scope: [:return_authorization_mailer, :notify_return_initialization_to_admin], return_auth_number: return_auth_number)
      mail(to: admin_notification_address, from: from_address, subject: subject)
    end

    def notify_return_initialization_to_user(return_auth_number)
      @return_authorization = Spree::ReturnAuthorization.find_by(number: return_auth_number)
      subject = Spree.t(:subject, scope: [:return_authorization_mailer, :notify_return_initialization_to_user], return_auth_number: return_auth_number)
      mail(to: @return_authorization.order.email, from: from_address, subject: subject)
    end

    private
    def admin_notification_address
      Spree::Config[:return_initiation_admin_mail_address]
    end
  end
end
