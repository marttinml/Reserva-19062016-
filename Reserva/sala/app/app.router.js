(function(){
	var router = function($routeProvider){
			$routeProvider.when('/', {
	   	              templateUrl : 'app/components/home/home.view.html',
	   	              controller  : 'HomeController'
//	   	             templateUrl : 'app/components/calendar/calendar.view.html',
//	   	             controller  : 'HomeController'
	   	         });
			$routeProvider.when('/calendar', {
	   	             templateUrl : 'app/components/calendar/calendar.view.html',
	   	             controller  : 'HomeController'
	   	         });
			$routeProvider.when('/confirma', {
	   	             templateUrl : 'app/components/confirmacion/confirmacion.view.html',
	   	             controller  : 'ConfirmacionController'
	   	         });
			$routeProvider.when('/busqueda', {
	   	             templateUrl : 'app/components/busqueda/busqueda.view.html',
	   	             controller  : 'BusquedaController'
	   	         });
			$routeProvider.when('/reservacion', {
	   	             templateUrl : 'app/components/reservacion/reservacion.view.html',
	   	             controller  : 'ReservacionController'
	   	         });
	};

	router.$inject = ['$routeProvider'];
	angular.module('Hall').config(router);
})();