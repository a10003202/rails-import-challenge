module.factory('SwalConfigBuilder', SwalConfigBuilder);

function SwalConfigBuilder(){

    var TYPES = {
        info: 'info',
        warning: 'warning',
        error: 'error',
        success: 'success',
        question: 'question'
    };

    var INPUT_TYPES = {
        text: 'text',
        email: 'email',
        url: 'url',
        password: 'password',
        textarea: 'textarea',
        select: 'select',
        radio: 'radio',
        checkbox: 'checkbox',
        file: 'file',
        range: 'range'
    };

    var NOTIFICATION_TEMPLATE = {
        allowOutsideClick: false,
        allowEscapeKey: false,
        showConfirmButton: true,
    };

    var CONFIRMATION_TEMPLATE = {
        showCancelButton: true,
        confirmButtonText: 'Confirmar',
        cancelButtonText: 'Cancelar',
        allowOutsideClick: false,
        allowEscapeKey: false,
    };

    var REQUEST_TEMPLATE = {
        showCancelButton: true,
        confirmButtonText: 'Ok',
        cancelButtonText: 'Cancelar',
        allowOutsideClick: false,
        allowEscapeKey: false,
        icon: null,
    };

    function buildNotificationConfig(config = {}){
        var notification_config = NOTIFICATION_TEMPLATE;
        Object.assign(notification_config, config);

        return notification_config;
    }

    function buildConfirmationConfig(config = {}){
        var confirmation_config = CONFIRMATION_TEMPLATE;
        Object.assign(confirmation_config, config);

        return confirmation_config;
    }

    function buildRequestConfig(config = {}){
        var request_config = REQUEST_TEMPLATE;
        Object.assign(request_config, config);

        return request_config;
    }

    function buildSuccessNotificationConfig(config = {}){
        var request_config = NOTIFICATION_TEMPLATE;
        request_config.icon = TYPES.success;
        request_config.title = "Éxito!";
        Object.assign(request_config, config);

        return request_config;
    }

    function buildErrorNotificationConfig(config = {}){
        var request_config = NOTIFICATION_TEMPLATE;
        request_config.icon = TYPES.error;
        request_config.title = "Error!";
        Object.assign(request_config, config);

        return request_config;
    }

    function buildInfoNotificationConfig(config = {}){
        var request_config = NOTIFICATION_TEMPLATE;
        request_config.icon = TYPES.info;
        request_config.title = "Información!";
        Object.assign(request_config, config);

        return request_config;
    }

    function buildWarningNotificationConfig(config = {}){
        var request_config = NOTIFICATION_TEMPLATE;
        request_config.icon = TYPES.warning;
        request_config.title = "Advertencia!";
        Object.assign(request_config, config);

        return request_config;
    }

    var service = {};
    service.TYPES = TYPES;
    service.INPUT_TYPES = INPUT_TYPES;
    service.buildNotificationConfig = buildNotificationConfig;
    service.buildConfirmationConfig = buildConfirmationConfig;
    service.buildRequestConfig = buildRequestConfig;
    service.buildSuccessNotificationConfig = buildSuccessNotificationConfig;
    service.buildErrorNotificationConfig = buildErrorNotificationConfig;
    service.buildInfoNotificationConfig = buildInfoNotificationConfig;
    service.buildWarningNotificationConfig = buildWarningNotificationConfig;


    return service;
}