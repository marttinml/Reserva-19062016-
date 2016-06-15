/*global angular*/
/*jslint browser:true*/

(function () {

    var controller = function ($scope, $rootScope) {
        $scope.options = {
            reserved: {
                name: ($rootScope.session.employee.reservedBy).toTitleCase(),
                mail: $rootScope.session.employee.mail,
                accept: function(){
                    window.location = '#/';
                }
            }
        };
    };

    controller.$inject = ['$scope', '$rootScope'];
    angular.module('Hall').controller('ReservacionController', controller);

})();