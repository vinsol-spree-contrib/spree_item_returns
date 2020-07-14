module SpreeItemReturns::ReturnItemDecorator

  def returnable?
    inventory_unit.variant.product.returnable?
  end

  def returned?
    inventory_unit.shipped? && return_authorization.allow_return_item_changes? && !reimbursement
  end
end

Spree::ReturnItem.prepend SpreeItemReturns::ReturnItemDecorator