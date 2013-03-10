window.UserController = ($scope, $location, $routeParams, User) ->
  if $routeParams.cn == 'new'
    $scope.user = new User()
  else
    $scope.user = User.get(cn: $routeParams.cn)
  
  $scope.save = () ->
    if $routeParams.cn == 'new'
      User.save($scope.user)
    else
      # update
      User.update({cn: $routeParams.cn}, $scope.user)