// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// JQuery
//= require jquery3
//= require jquery-ui
//= require popper
// Bootstrap
//= require bootstrap
// FontAwesome
//= require @fortawesome/fontawesome-free/js/all
// Angular
//= require angular
//= require angular-messages
//= require angular-animate
//= require angular-aria
//= require angular-material
//= require ui-select
//= require ui-bootstrap4/dist/ui-bootstrap
//= require ui-bootstrap4/dist/ui-bootstrap-tpls
//= require angular-datatables/angular-datatables.min
//= require ng-file-upload/dist/ng-file-upload-all
// Components
//= require components/datatables
// Node modules
//= require sweetalert2/dist/sweetalert2.all.min
//= require moment/moment
//= require dropzone/dist/dropzone
// Vendor plugins
//= require pace/pace.min
//= require simplebar/js/simplebar.min
//= require metismenu/js/metisMenu.min
//= require perfect-scrollbar/js/perfect-scrollbar.js
// Rails
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_self

window.swal = function (...args) {
    return Swal.fire(...args);
};
