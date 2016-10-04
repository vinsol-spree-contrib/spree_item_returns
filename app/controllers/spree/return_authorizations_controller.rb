module Spree
  class ReturnAuthorizationsController < Spree::BaseController
    before_action :load_order, only: [:new, :create, :show]
    before_action :load_return_authorization, only: [:new, :create, :show]
    before_action :load_form_data, only: [:new, :show]
    before_action :authorize_action
    before_action :assign_return_authorization_attributes, only: :create

    def index
      @return_authorizations = Spree::ReturnAuthorization.includes(:order).where(order_id: spree_current_user.orders.ids).order(created_at: :desc)
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
        respond_with(@return_authorization) do |format|
          format.html do
            load_form_data
            flash.now[:error] = @return_authorization.errors.full_messages.join(", ")
            render action: :new
          end
          format.js { render layout: false }
        end
      end
    end

    def show
    end

    private

    def load_form_data
      load_return_items
      load_return_authorization_reasons
    end

    # To satisfy how nested attributes works we want to create placeholder ReturnItems for
    # any InventoryUnits that have not already been added to the ReturnAuthorization.
    def load_return_items
      all_inventory_units = @order.inventory_units
      associated_inventory_units = @return_authorization.return_items.map(&:inventory_unit)
      unassociated_inventory_units = all_inventory_units - associated_inventory_units

      new_return_items = unassociated_inventory_units.map do |new_unit|
        @return_authorization.return_items.build(inventory_unit: new_unit).tap(&:set_default_pre_tax_amount)
      end

      @form_return_items = (@return_authorization.return_items + new_return_items).sort_by(&:inventory_unit_id).uniq
    end

    def load_return_authorization_reasons
      @reasons = Spree::ReturnAuthorizationReason.active
    end

    def load_order
      @order = Spree::Order.find_by(number: params[:order_id])
      unless @order
        flash[:error] = Spree.t('return_authorizations_controller.order_not_found')
        redirect_to account_path
      end
    end

    def load_return_authorization
      if [:new, :create].include?(action)
        @return_authorization = @order.return_authorizations.build
      else
        @return_authorization = @order.return_authorizations.find_by(number: params[:id])
        unless @return_authorization
          flash[:error] = Spree.t('return_authorizations_controller.return_authorization_not_found')
          redirect_to account_path
        end
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
      action_name.to_sym
    end
  end
end