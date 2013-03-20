window.GroupListController = ($scope, $location, Group) ->
  $scope.groups = Group.query()

  $scope.remove = (cn) ->
    Group.delete(cn: cn)
    $scope.groups = Group.query()

  $scope.edit = (cn) ->
    $location.path("/groups/" + cn)

  $scope.addNew = () ->
    $location.path("/groups/new")
