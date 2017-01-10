Spree::FrontendHelper.class_eval do

  def exchange_for_item_return?(return_item)
    return_item.persisted? && return_item.exchange_variant_id?
  end

  def refund_for_item_return?(return_item)
    !return_item.exchange_variant_id?
  end

end
