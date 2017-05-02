//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require main
//= require bootstrap-sprockets
//= require semantic-ui
//= require underscore
//= require gmaps/google
//= require Chart
//= require refuges

window.onresize = function(event) {
  initialize_refuges();
};
