angular.module('rubynas', []).config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode(true)
  $routeProvider
    .when "/system/summary",
      controller: SystemSummaryController,
      templateUrl: "/assets/system/summary.html"
    .otherwise
      redirectTo: '/system/summary'