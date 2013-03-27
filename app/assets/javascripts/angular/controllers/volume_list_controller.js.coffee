window.VolumeListController = ($scope, $location, $routeParams, Volume) ->
  $scope.volumes = Volume.query()
  
  $scope.remove = (id) ->
    Volume.delete(id: id)
    $scope.volumes = Volume.query()

  $scope.edit = (id) ->
    $location.path("/volumes/" + id)
    
  $scope.addNew = () ->
    $location.path("/volumes/new")
  