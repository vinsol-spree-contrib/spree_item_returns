module Spree
  class ReturnAuthorizationMailer < BaseMailer

    def notify_return_initialization_to_admin(return_auth_number)
      @return_authorization = Spree::ReturnAuthorization.find_by(number: return_auth_number)
      subject = Spree.t(:subject, scope: [:return_authorization_mailer, :notify_return_initialization_to_admin], return_auth_number: return_auth_number)
      mail(to: admin_notification_address, from: from_address, subject: subject)
    end

    def notify_return_initialization_to_user(return_auth_number)
      @return_authorization = Spree::ReturnAuthorization.find_by(number: return_auth_number)
      to_address = @return_authorization.order.user.email
      subject = Spree.t(:subject, scope: [:return_authorization_mailer, :notify_return_initialization_to_user], return_auth_number: return_auth_number)
      mail(to: @return_authorization.order.user.email, from: from_address, subject: subject)
    end

    private
      def admin_notification_address
        addresses = Spree::Config[:return_initiation_admin_mail_address]
        (addresses = (addresses).split(',').collect(&:strip)) if addresses.is_a?(Array)
        addresses
      end
  end
end