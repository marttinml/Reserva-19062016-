var cargresrango = function (obj) {
    var obj = JSON.parse(obj);
    obj = obj || {};
    obj.reservas = obj.reservas || [];

    angular.element(document.getElementsByTagName("calendar")[0]).scope().loadReservasByWeek(obj.reservas, true);
};

//var resultEmployee = function (obj) {
//    obj = JSON.parse(obj) || {};
//    obj.filtrados = obj.filtrados || [];
//    angular.element(document.getElementsByTagName("calendar")[0]).scope().reLoadEmployee(obj.filtrados);
//};

function getFirstWord(str) {
    var res = str.split(' ');
    return res[0];
}


(function () {

    var controller = function ($scope, $rootScope) {

        $scope.dateInit = new Date();
        $scope.dateInit.setMinutes(0);
        $scope.dateInit.setSeconds(0);
        $scope.dateInit.setMilliseconds(0);
        $scope.dateStart = new Date($scope.dateInit.setDate($scope.dateInit.getDate() - ($scope.dateInit.getDay() - 1)));
        $scope.dateEnd = new Date();
        $scope.dateEnd.setDate($scope.dateStart.getDate() + 5);
        $scope.dateStartString = $scope.dateStart.parseToStringShort();
        $scope.dateEndString = $scope.dateEnd.parseToStringShort();
        $scope.sourceCalendar = {};
        $scope.openConfirma = false;
        $scope.reserved = false;
        $scope.ocuped = false;

        $scope.formatReservas = function (arr) {

            var result = arr;
            for (var i = 0; i < result.length; i++) {
                result[i].timeStart = result[i].timeStart.parseToDate();
                result[i].timeEnd = result[i].timeEnd.parseToDate();
            }
            return result;
        };
        $scope.loadReservasByWeek = function (reservas, apply) {

            reservas = $scope.formatReservas(reservas);

            $scope.sourceCalendar = {
                dateStart: $scope.dateStart,
                dateEnd: $scope.dateEnd,
                reservas: reservas,
                date: new Date()
            };
            if (apply)
                $scope.$apply();

        };

        $scope.load = function (dStartString, dEndString) {

            window.location = "cargarresxrango:" + dStartString + "," + dEndString;
        };


        $scope.nextWeek = function (dStart, dEnd) {

            $scope.dateStart = dStart;
            $scope.dateEnd = dEnd;
            $scope.dateStartString = dStart.parseToStringShort();
            $scope.dateEndString = dEnd.parseToStringShort();
            $scope.loadReservasByWeek([], false);
            $scope.load($scope.dateStartString, $scope.dateEndString);
        };
        $scope.backWeek = function (dStart, dEnd) {

            $scope.dateStart = dStart;
            $scope.dateEnd = dEnd;
            $scope.loadReservasByWeek([], false);
            $scope.load(dStart.parseToStringShort(), dEnd.parseToStringShort());
        };


        $scope.employeeList = [];
        $scope.reLoadEmployee = function (arr) {
            $scope.sourceAlert.employeeList = arr;
            $scope.$apply();
        };
        $scope.eventTyping = function (val) {
            window.location = 'predictivo:' + val;
        };


        $scope.selectedItem = function (obj) {


            // for (var i = 0; i < $scope.arrToSave.length; i++) {
            //     $scope.arrToSave[i].reservedBy = obj.reservedBy;
            //     $scope.arrToSave[i].employeeId = obj.employeeId;
            //     $scope.arrToSave[i].mail = obj.mail;
            //     $scope.arrToSave[i].reservaId = $scope.arrToSave[0].reservaId
            // }

            // var message = '{ "reserva" : ' + JSON.stringify($scope.arrToSave) + '}';
            // window.location = 'reservac:' + message;

            // $scope.reserved = true;
            // $scope.sourceAlert = {
            //     reserved: {
            //         name: getFirstWord(obj.reservedBy),
            //         code: $scope.arrToSave[0].reservaId,
            //         photo: 'assets/img/09_iconoperfil.svg',
            //         accept: function () {
            //             $scope.reserved = false;
            //             window.location = '#/';
            //         }
            //     }
            // }

            // setTimeout(function () {
            //     $scope.load($scope.dateStartString, $scope.dateEndString);
            // }, 1000);
        };

        $scope.showSummary = function (obj) {

            console.log(obj);
            $scope.ocuped = true;
            $scope.sourceAlert = {

                ocuped: {
                    name: obj.reservedBy,
                    photo: 'assets/img/09_iconoperfil.svg',
                    motivo: obj.motivo,
                    start: obj.timeStart,
                    end: obj.timeEnd,
                    accept: function () {
                        $scope.ocuped = false;
                    }
                }
            };
        };

        $scope.reserve = function (obj, arr) {

            $scope.arrToSave = arr;
            $scope.openConfirma = true;

            /* Alerta deprecada */

            /* UPDATE: - Aquí se recibe el objeto de confirmación */
            $rootScope.session.horario = obj;
            $rootScope.session.arrToSave = arr;
        };

        $scope.loadReservasByWeek([], false);
        $scope.load($scope.dateStartString, $scope.dateEndString);
    };

    controller.$inject = ['$scope', '$rootScope'];
    angular.module('Hall').controller('CalendarController', controller);

})();