/*global angular*/
/*jslint browser:true*/
(function () {
    var directive = function () {
        var link = function (scope) {

        };

        return {
            restrict: 'E',
            link: link,
            templateUrl: 'app/shared/spin/spin.template.html',
            scope : {
                options : '=?source'
            }
        };
    };
    angular.module('Spin', []).directive('spin', directive);

})();