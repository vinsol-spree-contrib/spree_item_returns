Deface::Override.new(
  virtual_path: 'spree/orders/show',
  name: 'user_return_authorization_initailization_button',
  insert_bottom: ".order-show-number",
  text: "
        <% if spree_current_user.present? && @order.shipped? && @order.has_returnable_products? && @order.has_returnable_line_items? %>
          <%= link_to(spree.new_order_return_authorization_path(@order), class: 'btn btn-primary float-right') do %>
            <span class='glyphicon glyphicon-send'><%= icon(name: 'send', classes: 'd-none d-xl-inline-block', width: 25, height: 25)  %></span>
            <%= Spree.t(:return_products) %>
          <% end %>
        <% end %>
        "
)
