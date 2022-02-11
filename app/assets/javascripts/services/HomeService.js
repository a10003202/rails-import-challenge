module.factory('HomeService',HomeService);
HomeService.$inject = ['$http', 'URL_ROOT', 'AUTHENTICITY_TOKEN', 'LOCALE', 'Upload'];

function HomeService($http, URL_ROOT, AUTHENTICITY_TOKEN, LOCALE, Upload) {
    var TIMEOUT = 10000;
    var service = new AbstractService($http,URL_ROOT, AUTHENTICITY_TOKEN,LOCALE,TIMEOUT);

    service.importPurchases = importPurchases;
    return service;

    function importPurchases(params){
        params.locale_t = LOCALE;
        params.authenticity_token = AUTHENTICITY_TOKEN;
        params.timeout = TIMEOUT;
        return Upload.upload({
            url: URL_ROOT + '/import_purchases.json',
            data: params,
            disableProgress: true //Fix pace.js error
        }).then();
    }
}