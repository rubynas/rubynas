window.UserController = ($scope, $location, $routeParams, User, Group) ->
  $scope.groups = Group.query()
  if $routeParams.cn == 'new'
    $scope.user = User.template()
  else
    $scope.user = User.get(cn: $routeParams.cn)
  
  # Available shells
  $scope.shells = [
    { path: "/bin/sh",    name: "Shell" },
    { path: "/bin/bash",  name: "BASH" },
    { path: "/bin/false", name: "No Login" }
  ]
  
  # Create default values for all other fields based on the entered common name.
  $scope.createDefaults = () ->
    if $scope.user.common_name?
      names = $scope.user.common_name.split(" ")
    
      # Email
      $scope.user.mail = names.join(".").toLowerCase() + "@"
    
      # Names
      $scope.user.surname = names.pop()
      $scope.user.given_name = names.join(" ")
    
      # Login
      names = $scope.user.common_name.split(" ")
      $scope.user.uid = (names[0][0] + names.pop()).toLowerCase()
      $scope.user.home_directory = "/home/" + $scope.user.uid
  
  $scope.save = () ->
    if $routeParams.cn == 'new'
      User.save $scope.user
    else
      # update
      User.update({cn: $routeParams.cn}, $scope.user)
    $location.path('/users')
