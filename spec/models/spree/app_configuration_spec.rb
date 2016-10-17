require "spec_helper"

describe Spree::AppConfiguration do
  it "expect set preference min_amount_required_to_get_loyalty_points"  do
    expect(Spree::Config.return_initiation_admin_mail_address).to eq('spree@example.com')
  end
end
