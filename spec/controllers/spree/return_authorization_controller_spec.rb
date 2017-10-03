require 'spec_helper'

describe Spree::ReturnAuthorizationsController, type: :controller do
  stub_authorization!

  before do
    allow(controller).to receive(:set_current_order).and_return(nil)
  end

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
      get :index, params: params
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
      allow(order).to receive(:has_returnable_products?).and_return(true)
      allow(order).to receive(:has_returnable_line_items?).and_return(true)
      allow(return_authorizations).to receive(:build).and_return(return_authorization)
      allow(controller).to receive(:load_form_data).and_return(true)
      allow(controller).to receive(:redirect_unauthorized_access).and_return(true)
    end

    def send_request(params = {})
      get :new, params: { order_id: order.number }.merge(params)
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

    context 'when order has no returnable products' do
      before do
        allow(order).to receive(:has_returnable_products?).and_return(false)
      end

      it 'expected to redirect to account_path' do
        send_request
        expect(response).to redirect_to account_path
      end

      it 'expected to have a error flash message' do
        send_request
        expect(flash.now[:error]).to eq(Spree.t('return_authorizations_controller.return_authorization_not_authorized'))
      end
    end

    context 'when order has no returnable line items' do
      before do
        allow(order).to receive(:has_returnable_line_items?).and_return(false)
      end

      it 'expected to redirect to account_path' do
        send_request
        expect(response).to redirect_to account_path
      end

      it 'expected to have a error flash message' do
        send_request
        expect(flash.now[:error]).to eq(Spree.t('return_authorizations_controller.return_authorization_not_authorized'))
      end
    end

    context 'when order has returnable products and returnable line items' do
      it 'expected to render template new' do
        send_request
        expect(response).to render_template :new
      end

      it 'expected to have a error flash message' do
        send_request
        expect(flash.now[:error]).to be nil
      end
    end

  end

  describe '#show' do
    let(:user) { mock_model(Spree::User) }
    let(:order) { mock_model(Spree::Order, user_id: user.id, number: '12345') }
    let(:inventory_unit) { mock_model(Spree::InventoryUnit) }
    let(:return_item) { mock_model(Spree::ReturnItem, inventory_unit_id: inventory_unit.id) }
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
    end

    def send_request(params = {})
      get :show, params: { order_id: order.number, id: return_authorization.number }.merge(params)
    end

    context "have full order as return" do

      before do
        allow(controller).to receive(:load_form_data).and_return(true)
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

      context 'return_authorization not found' do

        before do
          allow(return_authorizations).to receive(:find_by).and_return(nil)
        end

        it 'expected to redirect to account_path' do
          send_request
          expect(response).to redirect_to account_path
        end

        it 'expected to have a error flash message' do
          send_request
          expect(flash.now[:error]).to eq(Spree.t('return_authorizations_controller.return_authorization_not_found'))
        end

      end
    end

    context 'having partial returned orders' do

      let(:other_inventory_unit) { mock_model(Spree::InventoryUnit) }
      let(:new_inventory_unit) { mock_model(Spree::InventoryUnit) }
      let(:order_inventory_units) { [inventory_unit, other_inventory_unit] }
      let(:returned_inventroy_unit) { [inventory_unit] }
      let(:new_return_item) { mock_model(Spree::ReturnItem, inventory_unit_id: new_inventory_unit.id) }
      before do
        allow(return_authorization).to receive(:save).and_return(true)

        allow(order).to receive(:inventory_units).and_return(order_inventory_units)
        allow(return_authorization).to receive(:return_items).and_return(return_items)
        allow(return_items).to receive(:map).and_return(inventory_units)
        allow(return_items).to receive(:build).and_return(new_return_item)
        allow(new_return_item).to receive(:set_default_pre_tax_amount).and_return(new_return_item)
      end

      describe 'receive' do
        after do
          send_request
        end
      end

      it 'expected to assign return_authorizations' do
        send_request
        expect(assigns(:return_authorization)).to eq(return_authorization)
      end

      it 'expected to assign return_authorizations' do
        send_request
        expect(assigns(:form_return_items)).to eq([return_item, new_return_item])
      end

      it 'expected to render template new' do
        send_request
        expect(response).to render_template :show
      end

    end

  end

  describe '#create' do
    let(:user) { mock_model(Spree::User) }
    let(:order) { mock_model(Spree::Order, user_id: user.id, number: 12345) }
    let(:return_item) { mock_model(Spree::ReturnItem) }
    let(:variant) { mock_model(Spree::Variant) }
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
    end

    def send_request(params = {})
      default_params = { return_authorization: { return_authorization_reason_id: 1, memo: "", return_items_attributes: { inventory_unit_id: inventory_unit.id, _destroy: false, exchange_variant_id: variant.id } } }
      get :create, params: { order_id: order.number }.merge(default_params).merge(params)
    end

    context 'return authorization successfully created' do

      before do
        allow(return_authorization).to receive(:save).and_return(true)
      end

      describe 'receive' do
        after do
          send_request
        end

        it { expect(order).to receive(:return_authorizations).and_return(return_authorizations) }
        it { expect(return_authorizations).to receive(:build).and_return(return_authorization) }
      end

      it 'expected to assign return_authorizations' do
        send_request
        expect(assigns(:return_authorization)).to eq(return_authorization)
      end

      it 'expected to redirect to return authorization path' do
        send_request
        expect(response).to redirect_to return_authorizations_path
      end

      it 'expected to have a sucess flash message' do
        send_request
        expect(flash[:success]).to eq("Item return has been successfully created!")
      end


    end

    context 'return authorization can\'t created' do

      before do
        allow(return_authorization).to receive(:save).and_return(false)

        allow(order).to receive(:inventory_units).and_return(inventory_units)
        allow(return_authorization).to receive(:return_items).and_return(return_items)
        allow(return_items).to receive(:map).and_return(inventory_units)
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

      it 'expected to have a error flash message' do
        send_request
        expect(flash.now[:error]).to eq("")
      end

    end

    context 'order not found' do

      before do
        allow(orders).to receive(:find_by).and_return(nil)
      end

      it 'expected to redirect to account_path' do
        send_request
        expect(response).to redirect_to account_path
      end

      it 'expected to have a error flash message' do
        send_request
        expect(flash.now[:error]).to eq(Spree.t('order_not_found'))
      end

    end

  end
end
