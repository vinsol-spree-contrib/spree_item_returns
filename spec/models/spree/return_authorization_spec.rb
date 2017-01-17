require "spec_helper"

describe Spree::ReturnAuthorization do
  let(:order) { create(:shipped_order) }
  let(:stock_location) { create(:stock_location) }
  let(:rma_reason) { create(:return_authorization_reason) }
  let(:return_item) { create(:return_item, inventory_unit: order.inventory_units.last) }
  let(:variant) { order.variants.first }

  let(:return_authorization) do
    Spree::ReturnAuthorization.new(order: order,
      return_item_ids: return_item.id,
      return_authorization_reason_id: rma_reason.id)
  end

  describe 'validations' do
    context 'has valid stock location' do
      before do
        return_authorization.stock_location_id = stock_location.id
      end

      it "is valid with valid attributes" do
        expect(return_authorization).to be_valid
      end
    end

    context 'when stock location is empty' do
      before do
        return_authorization.stock_location_id = nil
      end

      it "expect to be invalid with empty stock location" do
        expect(return_authorization).to be_invalid
      end
    end

    context 'when initated by user' do
      before do
        return_authorization.stock_location_id = nil
        return_authorization.user_initiated = true
      end

      it "expected to be valid with empty stock location" do
        expect(return_authorization).to be_valid
      end

      context 'when return_items are not present' do
        before do
          return_authorization.user_initiated = true
          return_authorization.return_items.clear
        end

        it "expect return_authorization to be invalid" do
          expect(return_authorization).to be_invalid
        end
      end

      context 'when return_items are present' do
        before do
          return_authorization.user_initiated = true
        end

        it "expect return_authorization to be valid" do
          expect(return_authorization).to be_valid
        end
      end
    end
  end

  describe 'allow_return_item_changes?' do
    let(:customer_return) { create(:customer_return) }
    let(:return_item) { customer_return.return_items.first }
    let(:return_authorization) { return_item.return_authorization }

    context 'when customer returns exists' do
      it { expect(return_authorization.allow_return_item_changes?).to be false }
    end

    context 'when customer returns not exists' do
      before do
        return_authorization.customer_returns = []
        return_authorization.save
      end

      it { expect(return_authorization.allow_return_item_changes?).to be true }
    end
  end

  describe 'notify_user' do
    let!(:return_item) { create(:return_item) }
    let!(:return_authorization) { create(:return_authorization, user_initiated: true, return_item_ids: return_item.id) }

    it 'is expected to send mail to user on return authorization initiation' do
      expect { return_authorization.send(:notify_user) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe 'notify_admin' do
    let!(:return_item) { create(:return_item) }
    let!(:return_authorization) { create(:return_authorization, user_initiated: true, return_item_ids: return_item.id) }

    it 'is expected to send mail to admin on return authorization initiation' do
      expect { return_authorization.send(:notify_admin) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe 'callbacks' do
    it { is_expected.to callback(:notify_admin).after(:commit).if(:user_initiated?) }
    it { is_expected.to callback(:notify_user).after(:commit).if(:user_initiated?) }
  end
end
