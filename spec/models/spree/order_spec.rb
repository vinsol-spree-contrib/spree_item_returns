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

  describe '#has_returnable_products?' do
    let(:order) { create(:order_with_line_items) }
    let(:order_line_items) { order.line_items }

    context 'when order has returnable products' do
      it { expect(order.has_returnable_products?).to be true }
    end

    context 'when order has no returnable products' do
      before do
        order_line_items.each do |line_item|
          line_item.product.update_column(:returnable, false)
        end
      end
      it { expect(order.has_returnable_products?).to be false }
    end
  end

end
