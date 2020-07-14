module SpreeItemReturns::AppConfigurationDecorator

  def self.prepended(base)
    base.preference :return_initiation_admin_mail_address, :string, default: 'spree@example.com'
  end
end

Spree::AppConfiguration.prepend SpreeItemReturns::AppConfigurationDecorator
