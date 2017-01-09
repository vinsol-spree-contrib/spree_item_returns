function ReturnableProduct() {
}

ReturnableProduct.prototype.bindEvents = function() {
  this.showHideReturnTime($('#product_returnable'));
  this.bindCheckedEventOnReturnableCheckbox();
}

ReturnableProduct.prototype.bindCheckedEventOnReturnableCheckbox = function() {
  var _this = this;
  $('#product_returnable').on('click', function() {
    _this.showHideReturnTime($(this));
  });
}

ReturnableProduct.prototype.showHideReturnTime = function(element) {
  var $returnTimeElement = $('[data-hook=admin_product_form_return_time]');
  if(element.prop('checked')) {
    $returnTimeElement.show();
  } else {
    $returnTimeElement.hide();
  }
}

$(document).ready(function() {
  new ReturnableProduct().bindEvents();
});
