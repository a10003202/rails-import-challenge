module.factory('DatatablesConfigBuilder',DatatablesConfigBuilder);
DatatablesConfigBuilder.$inject = ['$compile', '$filter', 'DTOptionsBuilder'];

function DatatablesConfigBuilder($compile, $filter, DTOptionsBuilder){
    var languages = {
        es:{
            "sProcessing":     "Procesando...",
            "sLengthMenu":     "Mostrar _MENU_ registros",
            "sZeroRecords":    "No se encontraron resultados",
            "sEmptyTable":     "Ningún dato disponible en esta tabla",
            "sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
            "sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
            "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
            "sInfoPostFix":    "",
            "sSearch":         "Buscar:",
            "sUrl":            "",
            "sInfoThousands":  ",",
            "sLoadingRecords": "Cargando...",
            "oPaginate": {
                "sFirst":    "Primero",
                "sLast":     "Último",
                "sNext":     "Siguiente",
                "sPrevious": "Anterior"
            },
            "oAria": {
                "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
                "sSortDescending": ": Activar para ordenar la columna de manera descendente"
            }
        },
    };

    function buildPromiseCompatibleConfig($scope, ResourceRequest, ErrorHandler){
        var configuration = DTOptionsBuilder.newOptions();
        configuration.withPaginationType('full_numbers');
        configuration.withFnServerData(function(sSource, aoData, fnCallback, oSettings){
            var params = {};
            angular.forEach(aoData, function (param) {
                params[param.name] = param.value;
            });
            ResourceRequest(params).then(function(result){
                var response = result.data;
                fnCallback(response);
            }, ErrorHandler);
        });
        configuration.withDataProp('data');
        configuration.withOption('processing', true);
        configuration.withOption('serverSide',true);
        configuration.withOption('paging', true);
        configuration.withOption('createdRow', function(row,data,dataIndex){
            $compile(angular.element(row).contents())($scope);
        });
        configuration.withLanguage(languages.es);

        return configuration
    }

    function buildAjaxCompatibleConfig($scope, ajaxOption){
        var configuration = DTOptionsBuilder.newOptions();
        configuration.withDataProp('data');
        configuration.withOption('processing', true);
        configuration.withOption('serverSide', true);
        configuration.withPaginationType('full_numbers');
        configuration.withLanguage(languages.es);
        configuration.withOption('ajax', ajaxOption);
        configuration.withOption('createdRow', function (row, data, dataIndex) {
            $compile(angular.element(row).contents())($scope);
        });
        return configuration;
    }

    var service = {};
    service.buildPromiseCompatibleConfig = buildPromiseCompatibleConfig;
    service.buildAjaxCompatibleConfig = buildAjaxCompatibleConfig;

    return service;
}