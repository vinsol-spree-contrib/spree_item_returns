Deface::Override.new(
  virtual_path: 'spree/orders/show',
  name: 'user_return_authorization_initailization_button',
  insert_bottom: "#order_summary legend",
  text: "
        <% if @order.shipped? && @order.has_returnable_products? && @order.has_returnable_line_items? %>
          <%= link_to(spree.new_order_return_authorization_path(@order), class: 'btn btn-primary pull-right') do %>
            <span class='glyphicon glyphicon-send'></span>
            <%= Spree.t(:return_products) %>
          <% end %>
        <% end %>
        "
)
