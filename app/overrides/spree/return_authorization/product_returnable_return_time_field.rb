Deface::Override.new(
  virtual_path: 'spree/admin/products/_form',
  name: 'product_return_time_field',
  insert_after: "[data-hook=admin_product_form_returnable]",
  text: "
        <div data-hook='admin_product_form_return_time' class='alpha two columns'>
          <%= f.field_container :return_time, class: ['form-group'] do %>
            <%= f.label :return_time, Spree.t(:return_time, scope: [:model, :backend, :product]) %>
            <%= f.text_field :return_time, class: 'form-control' %>
            <p><b><small>(0 - returnable anytime)</small></b></p>
            <%= f.error_message_on :return_time %>
          <% end %>
        </div>
        "
)
