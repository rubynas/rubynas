window.VolumeController = ($scope, $location, $routeParams, Volume) ->
  unless $routeParams.id == 'new'
    $scope.volume = Volume.get(id: $routeParams.id)
  else
    $scope.volume = new Volume()
  
  $scope.save = () ->
    if $routeParams.id == 'new'
      Volume.save($scope.volume)
    else
      # update
      Volume.update({id: $routeParams.id}, $scope.volume)
    $location.path('/volumes')
