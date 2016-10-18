describe Spree::ReturnAuthorizationMailer do
  let(:admin_notification_address) { 'spree@example.com' }
  let(:from_address) { 'member@test.com' }
  let(:return_authorization) { mock_model(Spree::ReturnAuthorization) }
  let(:return_item) { mock_model(Spree::ReturnItem) }
  let(:return_items) { [return_item] }
  let(:variant) { mock_model(Spree::Variant) }
  let(:order) { mock_model(Spree::Order) }
  let(:reason) { mock_model(Spree::ReturnAuthorizationReason) }

  let(:notify_return_initialization_to_admin) { Spree::ReturnAuthorizationMailer.notify_return_initialization_to_admin(return_authorization.id) }
  let(:notify_return_initialization_to_user) { Spree::ReturnAuthorizationMailer.notify_return_initialization_to_user(return_authorization.id) }


  before do
    allow(return_authorization).to receive(:order).and_return(order)
    allow(return_authorization).to receive(:return_items).and_return(return_items)
    allow(return_authorization).to receive(:reason).and_return(reason)
    allow(reason).to receive(:name).and_return('')
    allow(return_item).to receive(:variant).and_return(variant)
    allow(variant).to receive(:name).and_return('')
    allow(variant).to receive(:price).and_return(100)
    allow(Spree::ReturnAuthorization).to receive(:find_by).and_return(return_authorization)
  end

  describe '#notify_return_initialization_to_admin' do
    it { expect(notify_return_initialization_to_admin.subject).to eq "ReturnAuthorization #{return_authorization.id} Initiated by User" }
    it { expect(notify_return_initialization_to_admin.to).to include admin_notification_address }
  end

  describe '#notify_return_initialization_to_user' do

    before do
      allow(order).to receive(:email).and_return('member@example.com')
    end

    it { expect(notify_return_initialization_to_user.subject).to eq "ReturnAuthorization #{return_authorization.id} has been Initiated" }
    it { expect(notify_return_initialization_to_user.to).to include 'member@example.com' }
  end

end
