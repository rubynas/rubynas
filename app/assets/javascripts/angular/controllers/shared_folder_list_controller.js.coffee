window.SharedFolderListController = ($scope, $location) ->
  $scope.sharedFolders = [
    {
      id: 1
      path: "/home/admin"
    },
    {
      id: 2
      path: "/"
    }
  ]

  $scope.edit = (id) ->
    $location.path("/shared_folders/" + id)
    
  $scope.addNew = () ->
    $location.path("/shared_folders/new")
    