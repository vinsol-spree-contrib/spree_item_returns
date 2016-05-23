module Spree
  class ReturnAuthorizationMailer < BaseMailer

    def notify_return_initialization_to_admin(return_auth_number)
      @return_authorization = Spree::ReturnAuthorization.find_by(number: return_auth_number)
      mail(to: admin_notification_address, from: from_address, subject: "ReturnAuthorization #{ return_auth_number } Initiated by User")
    end

    def notify_return_initialization_to_user(return_auth_number)
      @return_authorization = Spree::ReturnAuthorization.find_by(number: return_auth_number)
      to_address = @return_authorization.order.user.email
      mail(to: @return_authorization, from: from_address, subject: "ReturnAuthorization #{ return_auth_number } has been Initiated")
    end

    private
      def admin_notification_address
        (Spree::Config[:return_initiation_admin_mail_address]).split(',').collect(&:strip)
      end
  end
end