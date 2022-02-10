module.controller('MapController',[
    '$scope',
    'NgMap',
    '$filter',
    function($scope, NgMap, $filter){
        $scope.map = {};
        $scope.model = {
            gmap_shapes: [],
            markers: [],
        };
        $scope.map_params = {
            search : "Mérida, Yucatan, Mexico",
            marker: 'Mérida, Yucatan, Mexico',
            zoom: 14,
            min_shapes: null,
            max_shapes: null,
            min_markers: null,
            max_markers: 1
        };
        $scope.errors = {};
        $scope.drawingManagerOptions = {
            drawingMode: null,
            drawingControl: true,
            drawingControlOptions: {position: 'TOP_CENTER',drawingModes:['polygon','rectangle','circle','polyline']}
        }
        $scope.selectedShape = null;
        $scope.SHAPE_IDENTIFIER = "shape_";
        $scope.GMAP_SHAPE_TYPES = {
            POLYGON: "polygon",
            POLYLINE: "polyline",
            RECTANGLE: "rectangle",
            CIRCLE: "circle"
        }

        /* Functions to handle map and map interaction */
        $scope.loadMap = function(){
            NgMap.getMap().then(function(map){
                $scope.initMap(map);
            });
        };

        $scope.initMap = function(map){
            google.maps.event.addListener($scope.map, 'click', $scope.onMapClick);
            if($scope.model.gmap_shapes){
                angular.forEach($scope.model.gmap_shapes, function (gmap_shape, key) {
                    gmap_shape.gmap_shape_args.editable = false;
                    var shape = $scope.map.shapes[$scope.SHAPE_IDENTIFIER + key];
                    gmap_shape.shape = function () {
                        return shape;
                    }
                });
            }
        };

        $scope.setModel = function(model, isMarker=false){
            $scope.model.markers = model.markers || [];
            $scope.model.gmap_shapes = model.gmap_shapes || [];
            if(isMarker) {
                $scope.model.markers.push(model)
                $scope.map_params.marker = model.latitude + ', ' + model.longitude;
            }
        }

        $scope.setMapParams = function(map_params){
            map_params = map_params || {};
            $scope.map_params.search = map_params.search || $scope.map_params.search;
            $scope.map_params.marker = map_params.marker || $scope.map_params.marker;
            $scope.map_params.zoom = map_params.zoom || $scope.map_params.zoom;
            $scope.map_params.min_shapes = map_params.min_shapes || $scope.map_params.min_shapes;
            $scope.map_params.max_shapes = map_params.max_shapes || $scope.map_params.max_shapes;
            $scope.map_params.min_markers = map_params.min_markers || $scope.map_params.min_markers;
            $scope.map_params.max_markers = map_params.max_markers || $scope.map_params.max_markers;
        }

        $scope.setMapLocation = function(latitude, longitude){
            $scope.map_params.search = $scope.map_params.marker = latitude + ' , ' + longitude;
        };

        $scope.updateLocation = function(marker){
            $scope.model.longitude = marker.position.lng();
            $scope.model.latitude = marker.position.lat();
        };

        $scope.setMarkerLocation = function(response){
            $scope.map_params.marker = $scope.map_params.search;
        };

        $scope.onMapClick = function(data){
            if(!$scope.map_params.max_markers || $scope.model.markers.length < $scope.map_params.max_markers){
                $scope.model.markers.push({latitude: data.latLng.lat(), longitude: data.latLng.lng()})
            }else{
                if($scope.map_params.max_markers == 1 && $scope.model.markers.length == 1){
                    $scope.model.markers[0].latitude = data.latLng.lat();
                    $scope.model.markers[0].longitude = data.latLng.lng();
                }
            }
            $scope.map_params.marker = data.latLng.lat() + ', '+ data.latLng.lng();
        };

        $scope.placeChanged = function() {
            console.log(this.getPlace().geometry.location)
        }

        $scope.dragEnd = function(event, markerModel) {
            console.log("bounds changed");
            $scope.updateMarkerModel(markerModel, this);
        };

        $scope.dragStart = function(event) {
            console.log("drag start");
        }
        $scope.drag = function(event) {
            console.log("dragging");
        }
        $scope.updateMarkerModel = function(markerModel, marker){
            console.log(markerModel, marker)
            markerModel.latitude = marker.position.lat();
            markerModel.longitude = marker.position.lng();
        }
        $scope.shapeChanged = function(event, gmap_shape) {
            $scope.updateShapeModel(gmap_shape, this);
        }

        $scope.onMapOverlayCompleted = function(e){
            if (e.type != google.maps.drawing.OverlayType.MARKER) {
                // Switch back to non-drawing mode after drawing a shape.
                $scope.map.mapDrawingManager[0].setDrawingMode(null);
                const newShape = e.overlay;
                var newGmapShape = {
                    name: e.type,
                    gmap_shape_args: {},
                    gmap_shape_type: e.type,
                    shape: function () {
                        var idx = $scope.model.gmap_shapes.indexOf(this);
                        return $scope.map.shapes[$scope.SHAPE_IDENTIFIER + idx];
                    }
                };
                var gmap_shapes_not_destroyed = $filter('filter')($scope.model.gmap_shapes, function(value){
                    return !value._destroy;
                });
                if(!$scope.map_params.max_shapes || (gmap_shapes_not_destroyed.length < $scope.map_params.max_shapes)) {
                    $scope.updateShapeModel(newGmapShape, newShape);
                    $scope.model.gmap_shapes.push(newGmapShape);
                    $scope.setSelectedShape(null, newGmapShape);
                }
                newShape.setMap(null)
            }
        };

        $scope.clearSelectedShape = function(){
            if ($scope.selectedShape) {
                $scope.selectedShape.gmap_shape_args.editable = false;
                $scope.selectedShape = null;
            }
        }
        $scope.setSelectedShape = function(event, gmap_shape){
            $scope.clearSelectedShape();
            $scope.selectedShape = gmap_shape;
            $scope.selectedShape.gmap_shape_args.editable = true;
        };

        $scope.removeSelectedShape = function(){
            if($scope.selectedShape){
                $scope.selectedShape._destroy = true;
                $scope.clearSelectedShape();
            }
        }

        $scope.updateShapeModel = function (gmap_shape, shape){
            var paths, coords;
            gmap_shape.gmap_shape_args = {
                strokeColor: "#000000",
                strokeOpacity: 0.8,
                strokeWeight: 2,
                fillColor: "#000000",
                fillOpacity: 0.35,
                editable: false
            }
            switch (gmap_shape.gmap_shape_type){
                case $scope.GMAP_SHAPE_TYPES.POLYLINE:
                    paths = shape.getPath().getArray();
                    coords = paths.map(function(a){
                        return {lat: a.lat(), lng: a.lng()};
                    });
                    gmap_shape.gmap_shape_args.path = coords;
                case $scope.GMAP_SHAPE_TYPES.POLYGON:
                    paths = shape.getPath().getArray();
                    coords = paths.map(function(a){
                        return {lat: a.lat(), lng: a.lng()};
                    });
                    gmap_shape.gmap_shape_args.paths = coords;
                    break;
                case $scope.GMAP_SHAPE_TYPES.CIRCLE:
                    const center = [shape.getCenter().lat(), shape.getCenter().lng()]
                    const radius = shape.getRadius();
                    gmap_shape.gmap_shape_args.center = center;
                    gmap_shape.gmap_shape_args.radius = radius;
                    break;
                case $scope.GMAP_SHAPE_TYPES.RECTANGLE:
                    const bounds = shape.getBounds().toJSON();
                    gmap_shape.gmap_shape_args.bounds = bounds;
                    break;
            }
        }

        $scope.onSubmit = function(){
            angular.forEach($scope.model.gmap_shapes, function(gmap_shape){
                if(gmap_shape.shape()) {
                    $scope.updateShapeModel(gmap_shape, gmap_shape.shape());
                }
            });
        }

        $scope.validate = function(){
            $scope.errors = {};
            var is_valid = true;
            var gmap_shapes_not_destroyed = $filter('filter')($scope.model.gmap_shapes, function(value){
                return !value._destroy;
            });
            if($scope.map_params.min_shapes && gmap_shapes_not_destroyed.length < $scope.map_params.min_shapes ){
                is_valid = false;
                $scope.errors.min_shapes = true;
            }
            if($scope.map_params.min_markers && $scope.model.markers.length < $scope.map_params.min_markers){
                is_valid = false;
                $scope.errors.min_markers = true;
            }
            return is_valid;
        }

        $scope.$on("$destroy", function() {
            $scope.$emit('map_controller_destroyed', $scope);
        });


    }]);