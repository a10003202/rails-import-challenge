module.factory('ImageService',ImageService);
ImageService.$inject = ['$http', 'URL_ROOT', 'AUTHENTICITY_TOKEN', 'LOCALE', 'Upload'];

function ImageService($http, URL_ROOT, AUTHENTICITY_TOKEN, LOCALE, Upload) {
    var TIMEOUT = 10000;
    URL_ROOT = '/galleries';
    var service = new AbstractService($http,URL_ROOT, AUTHENTICITY_TOKEN,LOCALE,TIMEOUT);

    service.save = save;
    service.update = update;
    service.getByOwner = getByOwner;
    service.destroyImages =destroyImages;
    service.orderImages = orderImages;
    service.getBaseUrl = getBaseUrl;

    return service;

    function save(params){
        params.locale_t = LOCALE;
        params.authenticity_token = AUTHENTICITY_TOKEN;
        params.timeout = TIMEOUT;
        return Upload.upload({
            url: URL_ROOT + '.json',
            data: params,
            disableProgress: true //Fix pace.js error
        }).then();
    }

    function update(id, params){
        params.locale_t = LOCALE;
        params.authenticity_token = AUTHENTICITY_TOKEN;
        params.timeout = TIMEOUT;
        return Upload.upload({
            url: URL_ROOT + '/' + id + '.json',
            data: params,
            method: 'PUT',
            disableProgress: true //Fix pace.js error
        }).then();
    }

    function destroyImages(images){
        var config = {
            timeout: TIMEOUT,
            params:{
                authenticity_token: AUTHENTICITY_TOKEN,
                locale_t: LOCALE,
                images:images
            },
            paramSerializer: '$httpParamSerializerJQLike'
        };
        return $http.delete(URL_ROOT + '/destroy_images', config).then();
    }

    function getByOwner(owner_id, owner_type) {
        var config = {
            timeout: TIMEOUT,
            params:{
                owner_id: owner_id,
                owner_type: owner_type,
                locale_t: LOCALE
            }
        };
        return $http.get(URL_ROOT + '/get_by_owner', config).then();
    }

    function orderImages(params) {
        params.locale_t = LOCALE;
        params.authenticity_token =AUTHENTICITY_TOKEN;
        params.timeout=TIMEOUT;
        return $http.put(URL_ROOT + '/order_images', params).then();
    }

    function getBaseUrl() {
        return URL_ROOT;
    }

}