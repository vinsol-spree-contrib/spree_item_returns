Spree::Order.class_eval do
  scope :shipped, -> { where(shipment_state: 'shipped') }
end