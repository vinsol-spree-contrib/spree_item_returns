require 'spec_helper'
require 'cancan/matchers'

describe Spree::Ability, type: :model do
  let(:user) { create(:user) }
  let(:ability) { Spree::Ability.new(user) }

  context 'User' do

    context 'Return History' do
      let(:resource_user) { Spree.user_class.new }

      it 'reads returns history' do
        expect(ability).to be_able_to :read_returns_history, resource_user
      end
    end

    context 'Spree authorization' do
      let(:order) { create(:shipped_order) }
      let(:stock_location) { create(:stock_location) }
      let(:rma_reason) { create(:return_authorization_reason) }
      let(:return_item) { create(:return_item, inventory_unit: order.inventory_units.last) }
      let(:stock_location) { create(:stock_location) }
      let(:variant) { order.variants.first }

      let(:return_authorization) do
        Spree::ReturnAuthorization.new(order: order,
                                       return_item_ids: return_item.id,
                                       return_authorization_reason_id: rma_reason.id,
                                       stock_location_id: stock_location.id)
      end

      before :each do
        order.shipment_state = 'shipped'
        order.return_authorizations << return_authorization
        user.orders << order
      end

      it 'creates return authorization for shipped orders' do
        expect(ability).to be_able_to :create, return_authorization
      end

      it 'displays return authorizations' do
        expect(ability).to be_able_to :display, return_authorization
      end
    end

  end
end