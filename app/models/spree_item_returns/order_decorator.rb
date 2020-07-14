module SpreeItemReturns::OrderDecorator

  SHIPPED_STATES = ['shipped', 'partial']

  def self.prepended(base)
    base.scope :returned, -> { where(shipment_state: SHIPPED_STATES) }
  end

  def has_returnable_products?
    products.returnable.exists?
  end

  def has_returnable_line_items?
    line_items.any?(&:is_returnable?)
  end

end

Spree::Order.prepend SpreeItemReturns::OrderDecorator
