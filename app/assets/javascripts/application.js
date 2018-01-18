// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require dependencies/foundation-datepicker
//= require_tree ./dependencies/foundation-datepicker-locales
//= require social-share-button
//= require organizations
//= require statistics
//= require infringement_email
//= require respond.min
//= require rem.min
//= require tinymce

$(function() {
  $(document).foundation();

  tinymce.init({
    selector : "textarea:not(.mceNoEditor)",
    language : 'es'
  });
});
