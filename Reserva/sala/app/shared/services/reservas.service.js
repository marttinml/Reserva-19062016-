/* global angular, front, unbindhandlers*/
/* jslint browser:true */
/* exported cargaDatosresp */

unbindhandlers.reserva = {
    cargaDatos: function () {}
};

front.reserva = {
    cargresid: function (obj) {
        obj = JSON.parse(obj) || {};
        console.log(obj);
        angular.element(document.getElementsByTagName("home")[0]).scope().$parent.$emit('notify-cargadatosresp', obj);
        angular.element(document.getElementsByTagName("home")[0]).scope().$parent.$apply();
        unbindhandlers.reserva.cargaDatos();
        unbindhandlers.reserva.cargaDatos = function () {};
    }
};

(function () {

    var ReservaProvider = function ($rootScope) {

        var Reservas = {
            getcargaDatos: function (dn, callback) {
                $rootScope.spin = true;
                unbindhandlers.reserva.cargaDatos = $rootScope.$on('notify-cargadatosresp', callback);
                window.location = 'datoscancelar:' + dn;
            }
        };

        return Reservas;
    };

    angular.module('reservaProvider', []).factory('$reserva', ReservaProvider);

})();