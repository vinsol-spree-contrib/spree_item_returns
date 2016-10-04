require 'spec_helper'

describe Spree::Admin::ReturnAuthorizationsController, type: :controller do
  stub_authorization!
  let(:user) { double(Spree::User, id: 1) }
  let(:order) { create(:shipped_order, user_id: user.id) }
  let(:return_item) { create(:return_item) }
  let(:return_authorization) { create(:return_authorization, user_initiated: false, return_item_ids: return_item.id, order_id: order.id) }

  describe '#fire' do

    def send_request
      @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
      put :fire, { order_id: order.id, id: return_authorization.id }
    end

    before do
      allow(controller).to receive(:spree_current_user).and_return(user)
      allow(controller).to receive(:generate_admin_api_key).and_return(true)
      allow(controller).to receive(:load_resource).and_return(true)
      controller.instance_variable_set(:@return_authorization, return_authorization)
    end

    it 'expected to set the vale of user_initiated to true' do
      send_request
      expect(controller.instance_variable_get(:@return_authorization).user_initiated).to eql(true)
    end
  end
end
