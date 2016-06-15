/*global angular*/
/*exported resultEmployee*/
/*jslint browser:true*/

// Notificación - notify-get-session
var notify_getRegistros = function () {};
var resultEmployee = function (obj) {
    obj = JSON.parse(obj) || {};
    obj.filtrados = obj.filtrados || [];
    angular.element(document.getElementsByTagName('body')[0]).scope().$root.$broadcast('notify-get-registros', obj.filtrados);
    angular.element(document.getElementsByTagName('body')[0]).scope().$parent.$apply();
    notify_getRegistros();
    notify_getRegistros = function () {};
};
// Notificación - notify-get-session
// var notify_insertReserva = function () {};
// var insertReserva = function (obj) {
//     obj = JSON.parse(obj) || {};
//     obj.filtrados = obj.filtrados || [];
//     angular.element(document.getElementsByTagName('body')[0]).scope().$root.$broadcast('notify-insert-reserva', obj.filtrados);
//     angular.element(document.getElementsByTagName('body')[0]).scope().$parent.$apply();
//     notify_insertReserva();
//     notify_insertReserva = function () {};
// };

var closespin = function (str) {
    angular.element(document.getElementsByTagName('body')[0]).scope().$parent.spinLabel = '';
    angular.element(document.getElementsByTagName('body')[0]).scope().$parent.spin = false;
    angular.element(document.getElementsByTagName('body')[0]).scope().$parent.$apply();
};
var openspin = function (str) {
    angular.element(document.getElementsByTagName('body')[0]).scope().$parent.spinLabel = str;
    angular.element(document.getElementsByTagName('body')[0]).scope().$parent.spin = true;
    angular.element(document.getElementsByTagName('body')[0]).scope().$parent.$apply();
};

(function () {
    var providerService = function ($rootScope) {

        var sharedService = {};

        var Connextion = {
            init: function (method, objStr) {
            	console.log('xD');
                if(isMobile()){
                    if(detectar()){
                        this.iOS(method, objStr);
                    } else {
                        this.android(method, objStr); 
                    }
                }
            },
            iOS: function (method, objStr) {
                window.location = method + ':' + objStr;
            },
            android: function (method, objStr) {
                method(objStr);
            }
        };

        // Get Registros
        sharedService.getRegistros = function (str, callback) {
            var objStr = str;
            console.log('getRegistros: ' + objStr);
            notify_getRegistros = $rootScope.$on('notify-get-registros', callback);
            Connextion.init('predictivo', objStr);
        };
        // Save Reserva
        sharedService.insertReserva = function (obj) {
            var objNew = { reserva : obj };
            objStr = JSON.stringify(objNew);
            console.log('insertReserva: ' + objStr);
            Connextion.init('reservac', objStr);
        };

        return sharedService;

    };
    angular.module('PhoneProvider', []).factory('$phoneProvider', providerService);


})();