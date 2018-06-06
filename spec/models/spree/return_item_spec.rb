require 'spec_helper'

RSpec.describe Spree::ReturnItem, type: :model do

  let(:order) { create(:shipped_order) }
  let(:return_item) { create(:return_item, inventory_unit: order.inventory_units.last) }
  let(:inventory_unit) { return_item.inventory_unit }
  let(:variant) { inventory_unit.variant }
  let(:product) { variant.product }

  describe '#returnable?' do
    context 'when product is returnable' do
      before { product.update_column(:returnable, true) }

      it 'is expected to return true' do
        expect(return_item.returnable?).to eq(true)
      end
    end

    context 'when product is not returnable' do
      before { product.update_column(:returnable, false) }

      it 'is expected to return false' do
        expect(return_item.returnable?).to eq(false)
      end
    end
  end

  describe '#returned?' do
    context 'when inventory_unit is shipped' do
      let(:customer_return) { create(:customer_return) }
      let(:return_item) { customer_return.return_items.first }
      let(:return_authorization) { return_item.return_authorization }
      let(:reimbursement) { create(:reimbursement, customer_return: customer_return) }

      before do
        inventory_unit.update_column(:state, 'shipped')
      end

      context 'when return_authorization allows return item changes' do
        before do
          return_authorization.customer_returns = []
          return_authorization.save
        end

        context 'when reimbursement is not made' do
          before do
            return_item.reimbursement = nil
          end

          it 'is expected to return true' do
            expect(return_item.returned?).to eq(true)
          end
        end

        context 'when reimbursement is made' do
          before do
            return_item.reimbursement = reimbursement
          end

          it 'is expected to return false' do
            expect(return_item.returned?).to eq(false)
          end
        end
      end

      context 'when return_authorization does not allow return item changes' do

        it 'is expected to return false' do
          expect(return_item.returned?).to eq(false)
        end
      end
    end

    context 'when inventory_unit is not shipped' do
      before do
        inventory_unit.update_column(:state, 'ready')
      end

      it 'is expected to return false' do
        expect(return_item.returned?).to eq(false)
      end
    end
  end
end
