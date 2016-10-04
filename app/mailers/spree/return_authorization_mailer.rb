module Spree
  class ReturnAuthorizationMailer < BaseMailer

    def notify_return_initialization_to_admin(return_auth_number)
      @return_authorization = Spree::ReturnAuthorization.find_by(number: return_auth_number)
      ##FIXME_NISH: Please move subject to en.yml.
      mail(to: admin_notification_address, from: from_address, subject: "ReturnAuthorization #{ return_auth_number } Initiated by User")
    end

    def notify_return_initialization_to_user(return_auth_number)
      @return_authorization = Spree::ReturnAuthorization.find_by(number: return_auth_number)
      ## FIXME_NISH: Please use order.email instead of order.user.email.
      to_address = @return_authorization.order.user.email
      mail(to: @return_authorization.order.user.email, from: from_address, subject: "ReturnAuthorization #{ return_auth_number } has been Initiated")
    end

    private
      def admin_notification_address
        ## FIXME_NISH: Please confirm I guess we can pass comma separated email addresses.
        addresses = Spree::Config[:return_initiation_admin_mail_address]
        (addresses = addresses.split(',').collect(&:strip)) if addresses.is_a?(Array)
        addresses
      end
  end
end