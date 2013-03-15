window.UserListController = ($scope, $location, User, Group) ->
  $scope.groups = Group.query()
  $scope.users = User.query()
  
  $scope.remove = (cn) ->
    User.delete(cn: cn)
    $scope.users = User.query()

  $scope.edit = (cn) ->
    $location.path("/users/" + cn)
    
  $scope.addNew = () ->
    $location.path("/users/new")
  
  # finds the group by the passed gid_number
  $scope.groupFor = (gid_number) ->
    for group in $scope.groups
      return group.common_name if group.gid_number == gid_number
