require "spec_helper"

describe Spree::Order do
  let!(:order) { create(:order) }

  describe 'Constants' do
    it 'is expected to initialize SHIPPED_STATES' do
      expect(Spree::Order::SHIPPED_STATES).to eq(['shipped', 'partial'])
    end
  end

  describe 'scopes' do
    describe '.returned' do
      let!(:shipped_order) { create(:order, shipment_state: 'shipped') }
      let!(:partial_order) { create(:order, shipment_state: 'partial') }

      subject { Spree::Order.returned }

      it { is_expected.to include(shipped_order) }
      it { is_expected.to include(partial_order) }
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
    let(:order_products) { order.products }


    context 'when order has returnable line_items' do
      before do
        order_products.each do |product|
          product.update_column(:returnable, true)
        end
      end

      it { expect(order.has_returnable_line_items?).to be true }
    end

    context 'when order has no returnable line_items' do
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
