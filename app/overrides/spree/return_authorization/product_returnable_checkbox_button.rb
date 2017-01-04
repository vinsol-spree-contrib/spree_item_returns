Deface::Override.new(
  virtual_path: 'spree/admin/products/_form',
  name: 'product_returnable_checkbox_button',
  insert_after: "[data-hook='admin_product_form_promotionable']",
  text: "<div data-hook='admin_product_form_returnable'>
          <%= f.field_container :returnable, class: ['form-group'] do %>
            <%= f.label :returnable, Spree.t(:returnable) %>
            <%= f.error_message_on :returnable %>
            <%= f.check_box :returnable, class: 'form-control' %>
          <% end %>
        </div>"
)
