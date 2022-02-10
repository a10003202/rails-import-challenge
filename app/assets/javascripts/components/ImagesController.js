module.controller('ImagesController', ImagesController);
ImagesController.$inject = [
    '$scope',
    '$q',
    '$compile',
    'ImageService'
];
Dropzone.autoDiscover = false;
function ImagesController($scope, $q, $compile, ImageService) {
    $scope.IMAGE_TYPE = {
        NORMAL: 0,
        LOGO: 1,
        THUMBNAIL: 2,
        BANNER: 3
    };
    $scope.images = [];
    $scope.thumbnails = [];
    $scope.images_to_delete = [];
    $scope.model = {};
    $scope.model.image = {};
    $scope.model.images = [];
    $scope.owner_type = null;
    $scope.owner_id = null;
    $scope.dzMethods = {};
    $scope.dz_container_selector = null;
    $scope.image_validations = {
        max_size: 3145728,
        max_width: 2048,
        max_height: 2048
    };

    $scope.dzOptions = {
        url: ImageService.getBaseUrl() + '/create_images',
        paramName: 'images',
        acceptedFiles: 'image/*',
        uploadMultiple : true,
        parallelUploads: 10,
        maxFiles:10,
        addRemoveLinks: true,
        autoProcessQueue: false,
        autoQueue: true,
        init: function() {

        }
    };

    $scope.dzCallbacks = {
        'sending': function (file, xhr, formData) {
            formData.append('owner_type', $scope.owner_type);
            formData.append('owner_id', $scope.owner_id);
            if(file.order){
                formData.append('orders[]', file.order);
            }
        },
        'addedfile': function (file) {
            $scope.images.push(file);
        },
        'success': function (file, response_data) {

        },
        'error': function (file, error, xhr) {

        },
        'successmultiple': function (files, response_data) {

        },
        'removedfile': function (file) {
            var index = $scope.images.indexOf(file);
            var index_thumbnails = $scope.thumbnails.indexOf(file);
            if (index > -1) {
                $scope.images.splice(index, 1);
            }
            if (index_thumbnails > -1) {
                $scope.thumbnails.splice(index_thumbnails, 1);
            }
            if(file.id){
                $scope.images_to_delete.push(file.id);
            }
        },
        'thumbnail': function (file) {
            $scope.thumbnails.push(file);
        }
    };

    $scope.initDropzone = function (selector, owner_id) {
        $scope.owner_id = null;
        if(owner_id) {
            $scope.owner_id = owner_id;
        }else{
            if($scope.model.id) {
                $scope.owner_id = $scope.model.id;
            }
        }
        $scope.dz_container_selector = selector;
        var element = angular.element($($scope.dz_container_selector));
        element.html('<ng-dropzone class="dropzone" options="dzOptions" callbacks="dzCallbacks" methods="dzMethods"></ng-dropzone>');
        $compile(element.contents())($scope);
        if($scope.owner_id) {
            ImageService.getByOwner($scope.owner_id, $scope.owner_type).then(function (response) {
                $scope.model.images = response.data;
                angular.forEach($scope.model.images, function (image, key) {
                    var mockFile = {
                        id: image.id,
                        name: image.name,
                        size: image.size
                    };
                    $scope.dzMethods.getDropzone().emit("addedfile", mockFile);
                    $scope.dzMethods.createThumbnailFromUrl(mockFile, image.file.url, function () {
                        $scope.dzMethods.getDropzone().emit("complete", mockFile);
                    }, "anonymous");
                });
            }, $scope.handleError);
        }
        $($scope.dz_container_selector).sortable({
            items:'.dz-preview',
            cursor: 'move',
            opacity: 0.5,
            containment: $scope.dz_container_selector,
            distance: 20,
            tolerance: 'pointer',
            update: function (event, ui) {
                angular.forEach($scope.images, function (image, index) {
                    $(image.previewElement).attr('data-image-index', index);
                });
                $($scope.dz_container_selector+ ' .dz-preview').each(function (count, element) {
                    var image_index = $(element).attr('data-image-index');
                    $scope.images.forEach(function(file, index) {
                        if ($(file.previewElement).attr('data-image-index') === image_index) {
                            file.order = count
                        }
                    });
                });
                ImageService.orderImages({images: $scope.images}).then(function (response) {
                    console.log('Images ordered');
                });

            }
        });
    };

    $scope.initController = function(owner_type, owner_id){
        $scope.owner_type = owner_type;
        $scope.owner_id = null;
        if(owner_id){
            $scope.owner_id = owner_id;
        }
    }

    $scope.setImage = function(image){
        $scope.model.image = image;
    }

    $scope.getImage = function() {
        return $scope.model.image;
    }

    $scope.startUploadImages = function (owner_id) {
        $scope.owner_id = owner_id;
        if($scope.images_to_delete.length > 0){
            ImageService.destroyImages($scope.images_to_delete).then(function (response) {
                $scope.images_to_delete = [];
            });
        }
        var defered = $q.defer();
        var promise = defered.promise;
        if($scope.dzMethods.getAllFiles().length > 0) {
            $scope.dzMethods.processQueue();
            $scope.dzMethods.getDropzone().on('successmultiple', function (files, response_data) {
                defered.resolve(files, response_data);
            });
            $scope.dzMethods.getDropzone().on('error', function (file, error, xhr) {
                defered.reject(file, error, xhr);
            });
        }else{
            defered.resolve([], {success:true});
        }

        return promise;
    };

    $scope.uploadImage = function(owner_id){
        $scope.owner_id = owner_id;
        var params = $scope.model.image;
        params.owner_id = $scope.owner_id;
        params.owner_type = $scope.owner_type;
        if(params.file && params.file.url){
            params.file = params.file.url;
        }
        if(params.id){
            return ImageService.update(params.id, params).then();
        }
        return ImageService.save(params).then();
    };

    $scope.deleteImage = function (image) {
        var index = $scope.model.images.indexOf(image);
        swal({
            title: "Eliminar imagen",
            text: "¿Estás seguro que deseas eliminar esta imagen?",
            type: "warning",
            showCancelButton: true,
            confirmButtonText: "Eliminar",
            cancelButtonText: "Cancelar",
            showLoaderOnConfirm: true,
            allowOutsideClick: false,
            allowEscapeKey: false,
        }).then(function (confirm) {
            if(confirm.value) {
                ImageService.destroy(image.id).then(function (response) {
                    swal({
                        title: response.data.title,
                        text: response.data.message,
                        type: 'success',
                        allowOutsideClick: false,
                        allowEscapeKey: false
                    }).then(function () {
                        $scope.model.images.splice(index);
                        location.reload();
                    });
                }, $scope.handleError);
            }
        });
    };

    $scope.validate_images = function () {
        /*if (!form_data.has('images[]')) {
            return true;
        }*/
        var files = $scope.dzMethods.getAllFiles();
        for (var i = 0; i < files.length; i++) {
            if(files[i]['size'] > $scope.image_validations.max_size ||
                files[i]['width'] > $scope.image_validations.max_width ||
                files[i]['height'] > $scope.image_validations.max_height) {
                console.log(files[i]);
                return false;
            }
        }

        return true;
    };

}