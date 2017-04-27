//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require semantic-ui
//= require main
//= require underscore
//= require gmaps/google
//= require Chart
//= require_tree .

window.onresize = function(event) {
  initialize_refuges();
};
