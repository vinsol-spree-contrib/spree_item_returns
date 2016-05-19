module Spree
  class ReturnAuthorizationMailer < BaseMailer
    #This is to be send to specific admin/email(not all admins), which we can get from configurations.
    #Suggestion Invitied: Open Ended
    TO_ADDRESS = 'anurag.bhardwaj@vinsol.com'

    def notify_return_initialization_to_admin(return_auth_number)
      @return_authorization = Spree::ReturnAuthorization.find_by(number: return_auth_number)
      mail(to: TO_ADDRESS, from: from_address, subject: "ReturnAuthorization #{ return_auth_number } Initiated by User")
    end

    def notify_return_initialization_to_user(return_auth_number)
      @return_authorization = Spree::ReturnAuthorization.find_by(number: return_auth_number)
      to_address = @return_authorization.order.user.email
      mail(to: @return_authorization, from: from_address, subject: "ReturnAuthorization #{ return_auth_number } has been Initiated")
    end
  end
end