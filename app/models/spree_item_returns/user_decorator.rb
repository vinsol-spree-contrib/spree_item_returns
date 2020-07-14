module SpreeItemReturns::UserDecorator

  def self.prepended(base)
    base.has_many :return_authorizations, through: :orders
  end
end

Spree::User.prepend SpreeItemReturns::UserDecorator