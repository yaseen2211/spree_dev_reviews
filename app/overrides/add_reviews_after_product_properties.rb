Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'converted_product_properties',
  insert_after: '[data-hook="product-reviews"]',
  partial: 'spree/shared/reviews'
)
