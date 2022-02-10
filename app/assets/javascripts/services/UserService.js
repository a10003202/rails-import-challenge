module.factory('UserService',UserService);
UserService.$inject = ['$http', 'URL_ROOT', 'AUTHENTICITY_TOKEN', 'LOCALE'];

function UserService($http, URL_ROOT, AUTHENTICITY_TOKEN, LOCALE) {
    var TIMEOUT = 10000;
    var service = new AbstractService($http,URL_ROOT, AUTHENTICITY_TOKEN,LOCALE,TIMEOUT);
    return service;
}