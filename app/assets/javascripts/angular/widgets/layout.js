angular.module('layout', []).
  directive('layout', function() {
    return {
      restrict: 'E',
      transclude: true,
      scope: { title: '@' },
      controller: function($scope, $location) {
        $scope.open = function(path) {
          $location.path(path);
        }
      },
      link: function($scope) {
        Holder.run();
      },
      templateUrl: "/assets/widgets/layout.html",
      replace: true
    };
  });
