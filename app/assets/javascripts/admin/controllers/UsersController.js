module.controller('UsersController', UsersController);
UsersController.$inject = [
    '$scope',
    '$controller',
    'URL_ROOT',
    'LOCALE',
    'UserService',
    'SwalConfigBuilder',
    'DTColumnBuilder',
    'DatatablesConfigBuilder',
    '$uibModal'
];
function UsersController($scope, $controller, URL_ROOT, LOCALE, UserService, SwalConfigBuilder, DTColumnBuilder, DatatablesConfigBuilder, $uibModal){
    //Variables
    $scope.model = {};
    $scope.errors = {};
    $scope.saving = false;
    $scope.formats = {
        datetime: "DD/MM/YYYY hh:mm A",
        date: "DD/MM/YYYY",
        time: "hh:mm A"
    };
    $scope.patterns = {
        positive_integer_leading_zeros: /^\d*[1-9]+\d*$/,
        positive_integer: /^[1-9]\d*$/,
        non_negative_integer: /^\d+$/,
        phone: /^\+?\d{2}[- ]?\d{3}[- ]?\d{5}$/,
        price: /^\d{0,9}(\.\d{1,9})?$/
    };
    $controller('abstract-controller',{
        $scope : $scope
    });
    $controller('abstract-datatables-controller',{
        $scope : $scope,
        AbstractService: UserService
    });
    $scope.datatable_filters = {};

    //Functions
    $scope.loadDatatable = loadDatatable;
    $scope.store = store;
    $scope.update = update;
    $scope.destroy = destroy;
    $scope.loadModel = loadModel;
    $scope.validate = validate;
    $scope.setParams = setParams;

    function loadDatatable() {
        $scope.datatable_columns = [
            DTColumnBuilder.newColumn('type_user.name_translated'),
            DTColumnBuilder.newColumn('email'),
            DTColumnBuilder.newColumn('laboratory').notSortable(),
            DTColumnBuilder.newColumn('id').notSortable().renderWith(function(data,type,full,meta){
                var options = '<button type="button" ng-click="show('+full.id+')" class="btn btn-sm btn-default" style=""><span class="fa fa-eye"></span></button>';
                options += '<button type="button" ng-click="edit('+full.id+')" class="btn btn-sm btn-default" style=""><span class="fa fa-edit"></span></button>';
                options += '<button ng-click="destroy('+full.id+')" type="button" class="btn btn-sm btn-default" style=""><span class="fa fa-trash"></span></button>';
                return options;
            })
        ];
    }

    // Add new Model
    function store() {
        $scope.clearErrors();
        if(!$scope.validate()) {
            return;
        }
        $scope.saving = true;
        $scope.setParams();
        UserService.save($scope.model).then(function (response) {
            //$scope.model = response.data;
            var swal_config = SwalConfigBuilder.buildNotificationConfig('Exito!', 'Información guardada exitosamente.', SwalConfigBuilder.TYPES.success);
            swal(swal_config).then(function (result) {
                $scope.index();
            });
            $scope.saving = false;
        }, $scope.handleError);

    }

    // update the given model
    function update() {
        $scope.clearErrors();
        if(!$scope.validate()) {
            return;
        }
        $scope.saving = true;
        $scope.setParams();
        UserService.update($scope.model.id, $scope.model).then(function (response) {
            //$scope.model = response.data;
            var swal_config = SwalConfigBuilder.buildNotificationConfig('Exito!', 'Información actualizada exitosamente.', SwalConfigBuilder.TYPES.success);
            swal(swal_config).then(function (result){
                $scope.index();
            });
            $scope.saving = false;
        }, $scope.handleError);

    }

    // delete the given model
    function destroy(id) {
        swal(SwalConfigBuilder.buildConfirmationConfig(
            'Eliminar!',
            '¿Esta seguro que desea eliminar este registro?',
            SwalConfigBuilder.TYPES.warning
        )).then(function(result){
            if (result.value) {
                UserService.destroy(id).then(function () {
                    var swal_config = SwalConfigBuilder.buildNotificationConfig('Exito!', 'Información borrada exitosamente.', 'success');
                    swal(swal_config).then(function () {
                        $scope.index();
                    })
                }, $scope.handleError);
            }
        });

    }

    function loadModel(id){
        swal(SwalConfigBuilder.buildNotificationConfig('','Cargando información espere...', SwalConfigBuilder.TYPES.info));
        swal.showLoading();
        UserService.find(id).then(function(response){
            $scope.model = response.data;
            swal.close();
        }, $scope.handleError);
    }

    function setParams(){
        if($scope.model.city) {
            $scope.model.city_id = $scope.model.city.id;
        }
        if($scope.model.state){
            $scope.model.state_id = $scope.model.state.id;
        }
        $scope.model.schedules_attributes = $scope.model.schedules;
    }

    function validate(){
        var is_valid = true;
        if($scope.userForm.$invalid) {
            is_valid = false;
        }
        return is_valid;
    }

    $scope.openModalShow = function () {
        $scope.modalShow=$uibModal.open({
            animation: true,
            ariaLabelledBy: 'modal-title',
            ariaDescribedBy: 'modal-body',
            backdrop: 'static',
            templateUrl: 'modalShowUser.html',
            scope:$scope,
            size: 'lg'
        });
    };

    $scope.closeModal = function () {
        if($scope.modalShow) {
            $scope.modalShow.close();
        }
    };

}