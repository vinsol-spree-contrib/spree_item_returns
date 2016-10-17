require "spec_helper"

describe Spree::ReturnAuthorization do
  let!(:order) { create(:order) }

  describe 'scopes' do
    describe '.shipped' do
      let!(:shipped_order) { create(:shipped_order) }

      before do
        shipped_order.update_columns(shipment_state: 'shipped')
      end

      subject { Spree::Order.shipped }

      it { is_expected.to include(shipped_order) }
      it { is_expected.to_not include(order) }
    end
  end
end
