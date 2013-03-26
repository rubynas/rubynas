window.VolumeListController = ($scope, $location, $routeParams, $http, Volume) ->
  $scope.volumes = Volume.query()
  
  $scope.remove = (id) ->
    User.delete(id: id)
    $scope.users = User.query()

  $scope.edit = (id) ->
    $location.path("/volumes/" + id)
    
  $scope.addNew = () ->
    $location.path("/volumes/new")
  