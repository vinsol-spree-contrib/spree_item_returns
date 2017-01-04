Spree::LineItem.class_eval do

  def is_returnable?
    return true if product.return_time.zero?
    Time.current < (order.completed_at + product.return_time.days)
  end

end
