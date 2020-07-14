module SpreeItemReturns::ReturnAuthorizationDecorator

  def self.prepended(base)
    stock_location_validations = base._validators[:stock_location]
    if stock_location_validations.present?
      stock_location_validations.reject! { |validation| validation.is_a? ActiveRecord::Validations::PresenceValidator }
    end

    base._validate_callbacks.each do |callback|
      callback.raw_filter.attributes.delete :stock_location if callback.raw_filter.is_a?(ActiveModel::Validations::PresenceValidator)
    end

    base.validates :stock_location, presence: true, unless: :user_initiated?
    base.validates :return_items, presence: true, if: :user_initiated?

    base.after_commit :notify_admin, :notify_user, on: :create, if: :user_initiated?
  end

  def allow_return_item_changes?
    !customer_returned_items?
  end

  private
    def notify_admin
      Spree::ReturnAuthorizationMailer.notify_return_initialization_to_admin(number).deliver_later
    end

    def notify_user
      Spree::ReturnAuthorizationMailer.notify_return_initialization_to_user(number).deliver_later
    end

end

Spree::ReturnAuthorization.prepend SpreeItemReturns::ReturnAuthorizationDecorator
