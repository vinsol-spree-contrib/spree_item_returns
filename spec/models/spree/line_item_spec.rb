require "spec_helper"

describe Spree::LineItem do
  let(:line_item) { create(:line_item) }

  describe '#is_returnable?' do
    context 'when product return time is 0 days' do
      it { expect(line_item.is_returnable?).to be true }
    end

    context 'when product return time is other than 0' do
      context 'when order has no returnable line items' do
        before do
          line_item.product.update_column(:return_time, 20)
          line_item.order.update_column(:completed_at, Time.current - 30.days)
        end
        it { expect(line_item.is_returnable?).to be false }
      end

      context 'when order has returnable line items' do
        it { expect(line_item.is_returnable?).to be true }
      end
    end
  end

end
