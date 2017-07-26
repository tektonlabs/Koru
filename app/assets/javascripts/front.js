//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require main
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require semantic-ui
//= require underscore
//= require gmaps/google
//= require Chart
//= require twitter/typeahead.min
//= require jquery.inputmask
//= require jquery.inputmask.extensions
//= require jquery.inputmask.numeric.extensions
//= require jquery.inputmask.date.extensions
//= require_tree ./front

window.onresize = function(event) {
  initialize_refuges();
};

function initializeMap(refuge, locale){
  if (refuge !== undefined) {
    loadMapWithRefuge(refuge, locale);
    setTimeout(function (){
      $('#contact-primary_contact').height($('#contact-general').height());
    }, 450);
  }
};

function resize_panels(){
  setTimeout(function (){
    $('#infrastructure-partial').height($('#capacity-partial').height());
    $('#food-management-partial').height($('#water-management-partial').height());
    $('#light-management-partial').height($('#water-management-partial').height());
  }, 450);
};