Spree::Admin::ReturnAuthorizationsController.class_eval do
  before_action :allow_cancel_if_user_initiated, only: :fire

  private
    def allow_cancel_if_user_initiated
      ##FIXME_NISH: Please look why this method is required and provide it a proper name.
      @return_authorization.user_initiated = true
    end
end
