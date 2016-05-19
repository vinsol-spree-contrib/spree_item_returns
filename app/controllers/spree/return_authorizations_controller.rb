module Spree
  class ReturnAuthorizationsController < Spree::BaseController
    before_action :load_order, only: [:new, :create]
    before_action :load_return_authorization, only: [:new, :create]
    before_action :load_form_data, only: :new
    before_action :authorize_action
    before_action :assign_return_authorization_attributes, only: :create

    def index
      @orders = spree_current_user.orders.includes(:return_authorizations)
    end

    def new
    end

    def create
      if @return_authorization.save
        flash[:success] = Spree.t(:successfully_created, resource: 'Item return')
        respond_with(@return_authorization) do |format|
          format.html { redirect_to return_authorizations_path }
          format.js   { render layout: false }
        end
      else
        load_form_data
        respond_with(@return_authorization) do |format|
          format.html do
            flash.now[:error] = @return_authorization.errors.full_messages.join(", ")
            render action: :new
          end
          format.js { render layout: false }
        end
      end
    end

    private

    def load_form_data
      load_return_items
      load_return_authorization_reasons
    end

    # To satisfy how nested attributes works we want to create placeholder ReturnItems for
    # any InventoryUnits that have not already been added to the ReturnAuthorization.
    def load_return_items
      @form_return_items =  @return_authorization.order.inventory_units.map do |new_unit|
        Spree::ReturnItem.new(inventory_unit: new_unit).tap(&:set_default_pre_tax_amount)
      end
    end

    def load_return_authorization_reasons
      @reasons = Spree::ReturnAuthorizationReason.active
    end

    def load_order
      @order = Spree::Order.find_by(number: params[:order_id])
      redirect_to account_path, error: 'Order not found' unless @order
    end

    def load_return_authorization
      if [:new, :create].include?(action_name.to_sym)
        @return_authorization = @order.return_authorizations.build
      else
        @return_authorization = Spree::ReturnAuthorization.find_by(number: params[:id], order_id: @order.id)
        redirect_to account_path, error: 'This ReturnAuthorization not found for the current order' unless @return_authorization
      end
    end

    def permitted_resource_params
      params.require(:return_authorization).permit(:return_authorization_reason_id, :memo, return_items_attributes: [:inventory_unit_id, :_destroy, :exchange_variant_id])
    end

    def authorize_action
      if @return_authorization
        authorize! action, @return_authorization
      else
        authorize! :read_returns_history, spree_current_user
      end
    end

    def assign_return_authorization_attributes
      @return_authorization.user_initiated = true
      @return_authorization.attributes = permitted_resource_params
    end

    def action
      params[:action].to_sym
    end
  end
end
