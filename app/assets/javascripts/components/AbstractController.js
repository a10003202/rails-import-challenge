module.controller('abstract-controller',[
    '$scope',
    'URL_ROOT',
    'SwalConfigBuilder',
    'LOCALE',
    function($scope, URL_ROOT, SwalConfigBuilder, LOCALE){

        $scope.errors = {};
        $scope.saving = false;

        $scope.index = function(){
            window.location.pathname = URL_ROOT;
        };

        $scope.create = function(){
            window.location.pathname = URL_ROOT + '/new';
        };

        $scope.show = function(id){
            window.location.pathname = URL_ROOT + '/' + id;
        };

        $scope.edit = function(id){
            window.location.pathname = URL_ROOT + '/' + id + '/edit';
        };

        $scope.update = function(){
            throw "Not implemented";
        };

        $scope.store = function(){
            throw "Not implemented";
        };

        $scope.delete = function(){
            throw "Not implemented";
        };

        $scope.clearErrors = function(){
            angular.forEach($scope.errors, function(value, key){
                $scope.errors[key] = null;
            });
        };

        $scope.handleError = function(response){
            console.log(response)
            $scope.saving = false;
            Swal.close();
            if(response.status == 422) {
                if(response.data.errors){
                    $scope.errors.messages = response.data.errors;
                }else{
                    angular.forEach(response.data, function (value, key) {
                        $scope.errors[key] = response.data[key][0];
                    });
                }
            } else{
                swal(SwalConfigBuilder.buildNotificationConfig(
                    'Error',
                    'Se a presentado un error en nuestros servidores, intente de nuevo en unos minutos, si el problema persiste contacte a un administrador',
                    SwalConfigBuilder.TYPES.error
                ));
            }
        };

    }]);