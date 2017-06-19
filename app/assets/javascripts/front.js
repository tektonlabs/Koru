//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require main
//= require bootstrap-sprockets
//= require semantic-ui
//= require underscore
//= require gmaps/google
//= require Chart
//= require twitter/typeahead.min
//= require_tree ./front

window.onresize = function(event) {
  initialize_refuges();
};

function initMap(refuge, locale){
  loadMapWithRefuge(refuge, locale);
};