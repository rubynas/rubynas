angular.module('layout', []).
  directive 'layout', () ->
    restrict: 'E'
    transclude: true
    scope:
      title: '@'
    templateUrl: "/assets/widgets/layout.html"
    replace: true
    controller: ($scope, $location) ->
      $scope.open = (path) ->
        $location.path(path)
    link: ($scope) ->
      # Holder IMG templates
      Holder.run()
      
      # Twitter bootstrap
      $("a[rel=popover]").popover()
      $(".tooltip").tooltip()
      $("a[rel=tooltip]").tooltip()
