module Spree
  class ReturnAuthorizationsController < Spree::BaseController
    before_action :load_order, only: [:new, :create, :show]
    before_action :load_return_authorization, only: [:new, :create, :show]
    before_action :load_form_data, only: [:new, :show]
    before_action :authorize_action
    before_action :assign_return_authorization_attributes, only: :create

    def index
      ## FIXME_NISH: Use joins here instead of making two queries.
      @return_authorizations = Spree::ReturnAuthorization.includes(:order).where(order_id: spree_current_user.orders.ids).order(created_at: :desc)
    end

    def new
    end

    def create
      ## FIXME_NISH: Please have a look can we refactor this method.
      if @return_authorization.save
        ## FIXME_NISH: In case of ajax request flash message should be set only for that request.
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
      ## FIXME_NISH: Please rename this method.
      load_return_items
      load_return_authorization_reasons
    end

    # To satisfy how nested attributes works we want to create placeholder ReturnItems for
    # any InventoryUnits that have not already been added to the ReturnAuthorization.
    def load_return_items
      ## FIXME_NISH: Please refactor this code.
      all_inventory_units = @order.inventory_units
      associated_inventory_units = @return_authorization.return_items.map(&:inventory_unit)
      unassociated_inventory_units = all_inventory_units - associated_inventory_units

      new_return_items = unassociated_inventory_units.map do |new_unit|
        @return_authorization.return_items.build(inventory_unit: new_unit).tap(&:set_default_pre_tax_amount)
      end

      @form_return_items = (@return_authorization.return_items + new_return_items).sort_by(&:inventory_unit_id).uniq
    end

    def load_return_authorization_reasons
      #FIXME_NISH: Rename this instance variable to return_authorization_reasons.
      @reasons = Spree::ReturnAuthorizationReason.active
    end

    def load_order
      @order = Spree::Order.find_by(number: params[:order_id])
      ## FIXME_NISH: Move all flash messages and error messages to en.yml.
      redirect_to(account_path, error: 'Order not found') unless @order
    end

    def load_return_authorization
      ## FIXME_NISH: Please don't create before_action for new and create.
      if [:new, :create].include?(action)
        @return_authorization = @order.return_authorizations.build
      else
        @return_authorization = @order.return_authorizations.find_by(number: params[:id])
        redirect_to(account_path, error: 'This ReturnAuthorization not found for the current order') unless @return_authorization
      end
    end

    def permitted_resource_params
      params.require(:return_authorization).permit(:return_authorization_reason_id, :memo, return_items_attributes: [:inventory_unit_id, :_destroy, :exchange_variant_id])
    end

    def authorize_action
      if @return_authorization
        authorize! action, @return_authorization
      else
        ## FIXME_NISH: Please rename this action.
        authorize! :read_returns_history, spree_current_user
      end
    end

    def assign_return_authorization_attributes
      ## FIXME_NISH: As we are not building a new return_authorization, we won't require this before_action.
      @return_authorization.user_initiated = true
      @return_authorization.attributes = permitted_resource_params
    end

    def action
      action_name.to_sym
    end
  end
end
