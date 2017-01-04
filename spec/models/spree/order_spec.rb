require "spec_helper"

describe Spree::Order do
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
      before do
        order_line_items.each do |line_item|
          line_item.product.update_column(:returnable, true)
        end
      end
      it { expect(order.has_returnable_products?).to be true }
    end

    context 'when order has no returnable products' do
      it { expect(order.has_returnable_products?).to be false }
    end
  end

  describe '#has_returnable_line_items?' do
    let(:order) { create(:completed_order_with_totals) }

    context 'when order has returnable line_items' do
      it { expect(order.has_returnable_line_items?).to be true }
    end

    context 'when order has no returnable line_items' do
      let(:order_products) { order.products }

      before do
        order_products.each do |product|
          product.update_column(:return_time, 20)
        end
        order.update_column(:completed_at, Time.current - 30.days)
      end
      it { expect(order.has_returnable_line_items?).to be false }
    end
  end

end
