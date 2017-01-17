function ReturnItemOptionsSelection() {
}

ReturnItemOptionsSelection.prototype.bindEvents = function() {
  this.hideExchangeOptionsDropdownForRefundItems();
  this.bindClickEventOnReturnOptionRadioButtons();
  this.bindCheckedEventOnLineItemsSelection();
}

ReturnItemOptionsSelection.prototype.bindCheckedEventOnLineItemsSelection = function() {
  var _this = this;
  $('input[type=checkbox]').on('change', function() {
    _this.updateSuggestedAmount();
  });
}

ReturnItemOptionsSelection.prototype.hideExchangeOptionsDropdownForRefundItems = function() {
  $('[value=refund]:checked').each(function() {
    $(this).closest('tr')
           .find('.return-item-exchange-selection')
           .val('')
           .hide();
  });
}

ReturnItemOptionsSelection.prototype.bindClickEventOnReturnOptionRadioButtons = function() {
  var _this = this;

  $('.return-options').on('change', function(event) {
    event.stopPropagation();

    var $exchangeDropdown = $(this).closest('tr')
                                   .find('.return-item-exchange-selection');

    _this.updateSuggestedAmount();

    if($(event.target).is('[value=refund]')) {
      $exchangeDropdown.val('').hide();
    } else if($(event.target).is('[value=exchange_for]')) {
      var defaultSelectedItem = $exchangeDropdown.find('option:first').val();
      $exchangeDropdown.val(defaultSelectedItem).show();
    }
  });
}

ReturnItemOptionsSelection.prototype.updateSuggestedAmount = function() {
  var totalPretaxRefund = 0;
  var formFields = $("[data-hook='admin_return_authorization_form_fields']");
  var checkedItems = formFields.find('input.add-item:checked');

  $.each(checkedItems, function(i, checkbox) {
    var $selectedItemRow = $(checkbox).parents('tr');

    if($selectedItemRow.find('.return-options:checked').is($('[value=exchange_for]'))) {
      return true;
    }

    totalPretaxRefund += parseFloat($selectedItemRow.find('.refund-amount-input').val());
  });

  var displayTotal = isNaN(totalPretaxRefund) ? '' : totalPretaxRefund.toFixed(2);
  formFields.find('span#total_pre_tax_refund').html(displayTotal);
}

$(document).ready(function() {
  new ReturnItemOptionsSelection().bindEvents();
});
