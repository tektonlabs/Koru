/* 

=========================================================================== 
Koru GPL Source Code 
Copyright (C) 2017 Tekton Labs
This file is part of the Koru GPL Source Code.
Koru Source Code is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, either version 3 of the License, or 
(at your option) any later version. 

Koru Source Code is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
=========================================================================== 

*/

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