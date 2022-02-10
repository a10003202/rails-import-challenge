var module = angular.module("ModuleAdmin",
    [
        'datatables',
        'ui.select',
        'ui.bootstrap',
        'ngMessages',
        'ngMap',
        'thatisuday.dropzone',
        'ngFileUpload'
    ]
);
/*
$(document).on('turbolinks:load', function() {
    // Start angular module always load turbolinks
    angular.bootstrap(document.body, ['ModuleAdmin']);
});*/
//Fix to add show class
module.config(['$uibModalProvider', function($uibModalProvider) {
    $uibModalProvider.options.windowClass = 'show';
    $uibModalProvider.options.backdropClass = 'show';
}]);
module.config(['$provide',function($provide){
    $provide.constant('AUTHENTICITY_TOKEN', CSRF_TOKEN);
    $provide.constant('LOCALE',LOCALE);
    console.log(URL_ROOT)
    $provide.constant('URL_ROOT', URL_ROOT);

}]);
module.directive('customValidator', [function() {
    return {
        restrict: 'A',
        require: ['ngModel', "^form"],
        link: function(scope, elem, attr, controls) {
            var control = controls[0];
            var form = controls[1];
            scope.$watch(function() {return [control.$error, control.$touched, form.$submitted]}, function() {
                if(control.$invalid){
                    if(control.$$element[0].setCustomValidity) {
                        control.$$element[0].setCustomValidity("Invalid.");
                    }else {
                        if(control.$touched || form.$submitted) {
                            $(control.$$element).removeClass('is-valid').addClass('is-invalid');
                        }
                    }
                }
                if(control.$valid){
                    if(control.$$element[0].setCustomValidity) {
                        control.$$element[0].setCustomValidity("");
                    }else {
                        if(control.$touched || form.$submitted) {
                            $(control.$$element).removeClass('is-invalid').addClass('is-valid');
                        }
                    }
                }
            }, true);
        }
    }
}]);