function AbstractService($http, URL_ROOT, AUTHENTICITY_TOKEN, LOCALE, TIMEOUT) {
    var service = {};
    service.all = all;
    service.find = find;
    service.destroy = destroy;
    service.save = save;
    service.update = update;
    service.search = search;

    return service;

    function all(params) {
        var config = {
            timeout: TIMEOUT,
            locale_t: LOCALE,
            params: params,
            paramSerializer: '$httpParamSerializerJQLike' //To serialize array in get request
        };
        return $http.get(URL_ROOT + '.json', config).then();
    }

    function find(id){
        var config = {timeout: TIMEOUT, locale_t: LOCALE};
        return $http.get(URL_ROOT + '/' + id + '.json', config).then();
    }

    function destroy(id){
        var config = {
            timeout: TIMEOUT,
            locale_t: LOCALE,
            params: {
                authenticity_token: AUTHENTICITY_TOKEN
            }
        };
        return $http.delete(URL_ROOT+'/'+id + '.json', config).then();
    }

    function save(params){
        params.locale_t = LOCALE;
        params.authenticity_token = AUTHENTICITY_TOKEN;
        params.timeout = TIMEOUT;
        return $http.post(URL_ROOT + '.json', params).then();
    }

    function update(id, params){
        params.locale_t = LOCALE;
        params.authenticity_token = AUTHENTICITY_TOKEN;
        params.timeout = TIMEOUT;
        return $http.put(URL_ROOT + '/' + id + '.json', params).then();
    }

    function search(params){
        var config = {
            timeout: TIMEOUT,
            locale_t: LOCALE,
            params: params,
            paramSerializer: '$httpParamSerializerJQLike' //To serialize array in get request
        };
        return $http.get(URL_ROOT + '/search.json', config).then();
    }

}