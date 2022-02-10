module.controller('abstract-datatables-controller',[
    '$scope',
    'DatatablesConfigBuilder',
    'AbstractService',
    function($scope, DatatablesConfigBuilder, AbstractService){
        $scope.datatable_instance = {};
        $scope.datatable_options = DatatablesConfigBuilder.buildPromiseCompatibleConfig($scope, function(params){
            params["filters"] = $scope.datatable_filters;
            return AbstractService.search(params);
        }, $scope.handleError);
        $scope.datatable_columns = [];
        $scope.errors = {};
        $scope.datatable_filters = {};

        $scope.reload = function(){
            $scope.datatable_instance.rerender();
        };

    }]);