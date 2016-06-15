/*global angular*/
(function () {
    var Directive = function () {
        var self = this;
        self.link = function ($scope) {
            console.log($scope.options);
        };
        return {
            restrict: 'A',
            templateUrl: 'app/shared/ng-chabe/chabe.template.html',
            link: self.link,
            scope: {
                options: '=source'
            }
        };
    };
    var BlurDirective = function () {
        return function (scope, element, attributes) {
            scope.$watch(attributes.ngTriggerBlur, function (newVal) {
                if (newVal) {
                    element[0].blur();
                }
            });
        };
    };
    angular
        .module('ChabeDirective', [])
        .directive('ngChabe', Directive)
        .directive('ngTriggerBlur', BlurDirective);
})();