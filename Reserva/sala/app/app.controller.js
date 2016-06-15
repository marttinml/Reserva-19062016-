var cargres = function(obj){
	var obj = JSON.parse(obj);
	console.log(obj);
};
var unbindhandlers = {};
var front = {};

(function(){

	var controller = function($scope, $rootScope, $route, $routeParams, $location) {
        
        /* Creación de la session Root */
        $rootScope.session = {
            arrToSave: [],
            horario: {},
            employee: {},
            codigo: ''
        };
        
        $rootScope.codigoIncorrecto = true;

        $rootScope.spin = false;
        $rootScope.spinLabel = '';
    };

	 controller.$inject = ['$scope', '$rootScope', '$route', '$routeParams', '$location'];
	 angular.module('Hall').controller('AppController',controller);
})();