window.SharedFolderController = ($scope, $routeParams, $location) ->
  if $routeParams.id == 'new'
    $scope.sharedFolder = {}
  else
    $scope.sharedFolder =
      id: $routeParams.id
      path: "/home/admin"
      users: [
        { common_name: 'pete' }
      ]
      exposed_via_services: [
        { id: 'nfs',   enabled: true },
        { id: 'afp',   enabled: true },
        { id: 'smb',   enabled: false },
        { id: 'rsync', enabled: false },
        { id: 'cifs',  enabled: false }
      ]
      capabilities: [
        { id: 'timemachine', enabled: true}
      ]

  $scope.cancel = () ->
    $location.path('/shared_folders')

  $scope.save = () ->
    if $routeParams.id == 'new'
      # create
    else
      # update
    $location.path('/shared_folders')
