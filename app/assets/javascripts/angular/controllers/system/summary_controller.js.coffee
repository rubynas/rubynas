window.SystemSummaryController = ($scope, SystemInformation) ->
  $scope.system_information = SystemInformation.get()
