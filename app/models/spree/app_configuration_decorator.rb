Spree::AppConfiguration.class_eval do
  preference :return_initiation_admin_mail_address, :string
  preference :return_order_days, :integer
end
