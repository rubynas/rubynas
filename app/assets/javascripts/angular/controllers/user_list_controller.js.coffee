window.UserListController = ($scope, $location, User) ->
  $scope.users = User.query()
  
  $scope.remove = (cn) ->
    User.delete(cn: cn)
    $scope.users = User.query()

  $scope.edit = (cn) ->
    $location.path("/users/" + cn)
    
  $scope.addNew = () ->
    $location.path("/users/new")