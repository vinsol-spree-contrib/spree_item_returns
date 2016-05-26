Spree::AppConfiguration.class_eval do
  preference :return_initiation_admin_mail_address, :string, default: 'spree@example.com'
end
