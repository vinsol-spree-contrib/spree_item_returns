require 'spec_helper'

describe Spree::ReturnAuthorizationsController, type: :controller do
  stub_authorization!

  describe '#index' do
    let(:user) { mock_model(Spree::User) }
    let(:order) { mock_model(Spree::Order, user_id: user.id) }
    let(:orders) { [order] }
    let(:return_authorization) { mock_model(Spree::ReturnAuthorization, order_id: order.id) }
    let(:return_authorizations) { [return_authorization] }

    before do
      allow(controller).to receive(:spree_current_user).and_return(user)
      allow(user).to receive(:return_authorizations).and_return(return_authorizations)
      allow(return_authorizations).to receive(:includes).with(:order).and_return(return_authorizations)
      allow(return_authorizations).to receive(:order).with(created_at: :desc).and_return(return_authorizations)
    end

    def send_request(params = {})
      get :index, params
    end

    describe 'expect to receive' do
      it { expect(controller).to receive(:spree_current_user).and_return(user) }
      it { expect(user).to receive(:return_authorizations).and_return(return_authorizations) }
      it { expect(return_authorizations).to receive(:includes).with(:order).and_return(return_authorizations) }
      it { expect(return_authorizations).to receive(:order).with(created_at: :desc).and_return(return_authorizations) }

      after { send_request }
    end

    it 'expects to assign return_authorizations' do
      send_request
      expect(assigns(:return_authorizations)).to match_array(return_authorizations)
    end

    it 'expects to render template index' do
      send_request
      expect(response).to render_template :index
    end
  end

  describe '#new' do
    let(:user) { mock_model(Spree::User) }
    let(:order) { mock_model(Spree::Order, user_id: user.id, number: 12345) }
    let(:return_item) { mock_model(Spree::ReturnItem) }
    let(:inventory_unit) { mock_model(Spree::InventoryUnit) }
    let(:return_authorization) { mock_model(Spree::ReturnAuthorization, order_id: order.id) }
    let(:orders) { [order] }
    let(:return_authorizations) { [return_authorization] }
    let(:return_items) { [return_item] }
    let(:inventory_units) { [inventory_unit] }

    before do
      allow(controller).to receive(:spree_current_user).and_return(user)
      allow(user).to receive(:orders).and_return(orders)
      allow(orders).to receive(:shipped).and_return(orders)
      allow(orders).to receive(:find_by).and_return(order)

      allow(order).to receive(:return_authorizations).and_return(return_authorizations)
      allow(return_authorizations).to receive(:build).and_return(return_authorization)
      allow(controller).to receive(:load_form_data).and_return(true)
      allow(controller).to receive(:redirect_unauthorized_access).and_return(true)
    end

    def send_request(params = {})
      get :new, { order_id: order.number }.merge(params)
    end

    describe 'receive' do
      after do
        send_request
      end

      it { expect(order).to receive(:return_authorizations).and_return(return_authorizations) }
      it { expect(return_authorizations).to receive(:build).and_return(return_authorization) }
      it { expect(controller).to receive(:load_form_data).and_return(true) }
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

  describe '#show' do
    let(:user) { mock_model(Spree::User) }
    let(:order) { mock_model(Spree::Order, user_id: user.id, number: '12345') }
    let(:return_item) { mock_model(Spree::ReturnItem) }
    let(:inventory_unit) { mock_model(Spree::InventoryUnit) }
    let(:return_authorization) { mock_model(Spree::ReturnAuthorization, order_id: order.id, number: '12345') }
    let(:orders) { [order] }
    let(:return_authorizations) { [return_authorization] }
    let(:return_items) { [return_item] }
    let(:inventory_units) { [inventory_unit] }

    before do
      allow(controller).to receive(:spree_current_user).and_return(user)
      allow(user).to receive(:orders).and_return(orders)
      allow(orders).to receive(:shipped).and_return(orders)
      allow(orders).to receive(:find_by).and_return(order)

      allow(order).to receive(:return_authorizations).and_return(return_authorizations)
      allow(return_authorizations).to receive(:find_by).and_return(return_authorization)
      allow(controller).to receive(:load_form_data).and_return(true)
    end

    def send_request(params = {})
      get :show, { order_id: order.number, id: return_authorization.number }.merge(params)
    end

    describe 'receive' do
      after do
        send_request
      end

      it { expect(controller).to receive(:load_form_data).and_return(true) }
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
