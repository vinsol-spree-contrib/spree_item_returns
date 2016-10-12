Spree::User.class_eval do
  has_many :return_authorizations, through: :orders
end