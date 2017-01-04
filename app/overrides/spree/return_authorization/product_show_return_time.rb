Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'product_show_return_time',
  insert_after: "[data-hook=description]",
  partial: 'spree/products/return_time'
)
