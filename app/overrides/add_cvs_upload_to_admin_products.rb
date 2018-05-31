Deface::Override.new(
  virtual_path:  'spree/admin/shared/sub_menu/_product',
  insert_bottom: "[data-hook='admin_product_sub_tabs']",
  text:          "<%= tab :product_uploads, match_path: '/product_uploads' %>",
  name:          'product_uploads'
)
