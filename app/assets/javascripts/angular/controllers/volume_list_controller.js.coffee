window.VolumeListController = ($scope, $location, $routeParams, Volume) ->
  $scope.volumes = Volume.query()
