/*global angular*/

// var resultEmployee = function(obj){
//     obj = obj || {};
//     obj.filtrados = obj.filtrados|| [];
    
//     angular.element(document.getElementsByTagName("confirmacion")[0]).scope().reLoadEmployee(obj.filtrados);
// };


(function () {

    var controller = function ($scope) {
        $scope.employeeList = [];
        console.log($scope.employeeList);

        $scope.reLoadEmployee = function(arr){
           $scope.sourceAlert.employeeList = arr;        
        };
        $scope.eventTyping = function(val){
        window.location = 'predictivo:'+val;
            console.log('eventTyping');
        };
            
            //window.location = "funcionHoms:"+val;
       
        
        $scope.message = 'Aquí esta el ConfirmacionController!';
        $scope.sourceAlert = {
            employeeList: $scope.employeeList,
            confirm: {
                title: "Reserva Cancelada",
                accept: function () {
                    $scope.alerts.confirm = !$scope.alerts.confirm;
                    $scope.clock = !$scope.clock;
                    location.reload();
                }
            }
        };
    };
        
    
    controller.$inject = ['$scope'];
    angular.module('Hall').controller('ConfirmacionController', controller);

})();