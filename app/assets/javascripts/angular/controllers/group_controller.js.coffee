window.GroupController = ($scope, $location, $routeParams, Group) ->
  $scope.group = Group.get(cn: $routeParams.cn)
  
  $scope.save = () ->
    if $routeParams.cn == 'new'
      Group.save $scope.group
    else
      # update
      Group.update({cn: $routeParams.cn}, $scope.group)
    $location.path('/groups')
