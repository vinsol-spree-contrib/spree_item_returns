Spree::FrontendHelper.class_eval do

  def exchange_for_item_return?(return_item)
    return_item.persisted? && return_item.exchange_variant_id?
  end

  def refund_for_item_return?(return_item)
    !return_item.exchange_variant_id?
  end

  def line_item_returnable?(line_item)
    line_item.product.returnable? && line_item.is_returnable?
  end

  def all_item_refunded?
    return 'none' unless @form_return_items.any? do |return_item|
      return_item.inventory_unit.shipped? && @return_authorization.allow_return_item_changes? && !return_item.reimbursement
    end
  end

  def pre_refund_total
    sum = 0.00
    @form_return_items.each do |return_item|
      sum += return_item.pre_tax_amount unless return_item.inventory_unit.shipped? && @return_authorization.allow_return_item_changes? && !return_item.reimbursement
    end
    return sum.to_f
  end

end
