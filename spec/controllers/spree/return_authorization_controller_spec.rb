require 'spec_helper'

describe Spree::ReturnAuthorizationsController, type: :controller do
  stub_authorization!

  describe '#index' do
    let(:user) { double(Spree::User, id: 1) }
    let(:order) { double(Spree::Order, id: 1, user_id: 1) }
    let(:orders) { [order] }
    let(:return_authorization) { double(Spree::ReturnAuthorization, order_id: order.id) }
    let(:return_authorizations) { [return_authorization] }

    before do
      allow(controller).to receive(:spree_current_user).and_return(user)
      allow(user).to receive_message_chain(:orders, :ids).and_return([order.id])
      allow(Spree::ReturnAuthorization).to receive_message_chain(:includes, :where).and_return(return_authorizations)
      allow(return_authorizations).to receive(:order).with(created_at: :desc).and_return(return_authorizations)
    end

    def send_request(params = {})
      get :index, params
    end

    it "expected to receive return_authorizations" do
      expect(Spree::ReturnAuthorization).to receive_message_chain(:includes, :where).and_return(return_authorizations)
      send_request
    end

    it 'expected to assign return_authorizations' do
      send_request
      expect(assigns(:return_authorizations)).to match_array(return_authorizations)
    end

    it 'expected to render template index' do
      send_request
      expect(response).to render_template :index
    end
  end

  describe '#new' do
    let(:user) { double(Spree::User, id: 1) }
    let(:order) { double(Spree::Order, id: 1, user_id: 1, number: 12345) }
    let(:return_item) { double(Spree::ReturnItem) }
    let(:inventory_unit) { double(Spree::InventoryUnit) }
    let(:return_authorization) { double(Spree::ReturnAuthorization, order_id: order.id) }
    let(:return_authorizations) { [return_authorization] }
    let(:return_items) { [return_item] }
    let(:inventory_units) { [inventory_unit] }

    before do
      allow(Spree::Order).to receive(:find_by).and_return(order)
      allow(order).to receive_message_chain(:return_authorizations, :build).and_return(return_authorization)

      allow(return_authorization).to receive_message_chain(:order, :inventory_units).and_return(inventory_units)
      allow(return_authorization).to receive(:return_items).and_return([])
      allow(Spree::ReturnItem).to receive(:new).and_return(return_item)
      allow(return_item).to receive(:set_default_pre_tax_amount).and_return(true)
      allow(return_item).to receive(:inventory_unit_id).and_return(1)
    end

    def send_request(params = {})
      get :new, { order_id: order.number }.merge(params)
    end

    it 'expected to assign return_authorizations' do
      send_request
      expect(assigns(:return_authorization)).to eq(return_authorization)
    end

    it 'expected to render template new' do
      send_request
      expect(response).to render_template :new
    end
  end

  describe '#create' do

    let(:order) { double(Spree::Order, id: 1, number: 12345) }
    let(:return_authorization) { double(Spree::ReturnAuthorization, order_id: order.id) }
    let(:return_authorization_reason_id) { create(:return_authorization_reason_id, id: 1) }

    before do
      allow(Spree::Order).to receive(:find_by).and_return(order)
      allow(order).to receive_message_chain(:return_authorizations, :build).and_return(return_authorization)
      allow(return_authorization).to receive(:user_initiated=).and_return(true)
      allow(return_authorization).to receive(:attributes=).and_return(true)
      allow(return_authorization).to receive(:save).and_return(true)
    end

    def send_request(params = {})
      post :create, { order_id: order.number }.merge(params)
    end

    context 'when record is created successfully' do
      it 'expected to set success-flash' do
        send_request(return_authorization: { return_authorization_reason_id: 1, memo: 'sample memo', return_items_attributes: [ inventory_unit_id: 1, _destroy: false, exchange_variant_id: 1] })
        expect(flash[:success]).to eq(Spree.t(:successfully_created, resource: 'Item return'))
      end

      it 'expected to redirect to return_authorization_path' do
        send_request(return_authorization: { return_authorization_reason_id: 1, memo: 'sample memo', return_items_attributes: [ inventory_unit_id: 1, _destroy: false, exchange_variant_id: 1] })
        expect(response).to redirect_to(return_authorizations_path)
      end
    end

    context 'when record is not created' do

      let(:inventory_unit) { double(Spree::InventoryUnit) }
      let(:inventory_units) { [inventory_unit] }
      let(:return_item) { double(Spree::ReturnItem) }

      before do
        allow(return_authorization).to receive(:save).and_return(false)
        allow(return_authorization).to receive_message_chain(:errors, :full_messages, :join).and_return('')

        allow(return_authorization).to receive_message_chain(:order, :inventory_units).and_return(inventory_units)
        allow(return_authorization).to receive(:return_items).and_return([])
        allow(Spree::ReturnItem).to receive(:new).and_return(return_item)
        allow(return_item).to receive(:set_default_pre_tax_amount).and_return(true)
        allow(return_item).to receive(:inventory_unit_id).and_return(1)
      end

      it 'expected to set error-flash' do
        send_request(return_authorization: { return_authorization_reason_id: 1, memo: 'sample memo', return_items_attributes: [ inventory_unit_id: 1, _destroy: false, exchange_variant_id: 1] })
        expect(flash[:error]).to eq(return_authorization.errors.full_messages.join(", "))
      end

      it 'expected to save the record' do
        send_request(return_authorization: { return_authorization_reason_id: 1, memo: 'sample memo', return_items_attributes: [ inventory_unit_id: 1, _destroy: false, exchange_variant_id: 1] })
        expect(response).to render_template :new
      end
    end
  end

  describe '#show' do
    let(:user) { double(Spree::User, id: 1) }
    let(:order) { double(Spree::Order, id: 1, user_id: 1, number: 12345) }
    let(:return_item) { double(Spree::ReturnItem) }
    let(:inventory_unit) { double(Spree::InventoryUnit) }
    let(:return_authorization) { double(Spree::ReturnAuthorization, order_id: order.id) }
    let(:return_authorizations) { [return_authorization] }
    let(:return_items) { [return_item] }
    let(:inventory_units) { [inventory_unit] }

    before do
      allow(Spree::Order).to receive(:find_by).and_return(order)
      allow(Spree::ReturnAuthorization).to receive(:find_by).and_return(return_authorization)

      allow(return_authorization).to receive_message_chain(:order, :inventory_units).and_return(inventory_units)
      allow(return_authorization).to receive(:return_items).and_return([])
      allow(Spree::ReturnItem).to receive(:new).and_return(return_item)
      allow(return_item).to receive(:set_default_pre_tax_amount).and_return(true)
      allow(return_item).to receive(:inventory_unit_id).and_return(1)
    end

    def send_request(params = {})
      get :show, { order_id: order.number, id: 12345 }.merge(params)
    end

    it 'expected to assign return_authorizations' do
      send_request
      expect(assigns(:return_authorization)).to eq(return_authorization)
    end

    it 'expected to render template new' do
      send_request
      expect(response).to render_template :show
    end
  end
end
