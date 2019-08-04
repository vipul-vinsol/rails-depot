class HandleAjaxRequest {
  constructor(form) {
    this.formElement = form;
  }

  init() {
    this.ajaxSuccessRequest();
    this.ajaxErrorRequest();
  }

  ajaxSuccessRequest() {
    this.formElement.on("ajax:success", function(event, data, status, xhr) {
      alert('Product successfully rated');
    });
  }

  ajaxErrorRequest() {
    this.formElement.on("ajax:error", function() {
      alert('There was some issue with the product rating form. Please try again');
    });
  }
}

$(document).ready(function(){
  let form = $('.rating-form');
  let ratingFormResponse = new HandleAjaxRequest(form);
  ratingFormResponse.init();
});