/*global angular*/
/*jslint browser:true*/
/*exported cargresdia,mainSource*/
var mainSource = [
    {
        start: 14,
        end: 15,
        color: "#885bbc"
    },
    {
        start: 7,
        end: 8,
        color: '#e160dc'
    },
    {
        start: 10,
        end: 11,
        color: '#60b5e1'
    }
];

var cargresdia = function (obj) {
    var obj = JSON.parse(obj);
    obj = obj || {};
    obj.reservas = obj.reservas || [];

    angular.element(document.getElementsByTagName("home")[0]).scope().reloadClock(obj.reservas, true);
//    console.log('Donass');
};

(function () {

    var controller = function ($rootScope, $scope, $reserva) {

        $scope.formatReservas = function (arr) {

            var result = arr;
            var necesario = [{}];

            for (var j = 0; j < result.length; j++) {
                necesario.push({});
            }

            for (var i = 0; i < result.length; i++) {
                necesario[i].start = result[i].timeStart.parseToDate().getHours() + (result[i].timeStart.parseToDate().getMinutes() / 60);
                necesario[i].end = result[i].timeEnd.parseToDate().getHours() + (result[i].timeStart.parseToDate().getMinutes() / 60);
                necesario[i].color = result[i].color;
            }

            function compare(a, b) {
                if (a.start < b.start)
                    return -1;
                if (a.start > b.start)
                    return 1;
                return 0;
            }

            necesario.sort(compare);

//            console.log(arr);
            return necesario;
        };


        $scope.today = new Date();

        $scope.reloadClock = function (src, apply) {

            (function () {
                var days = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];

                var months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

                Date.prototype.getMonthName = function () {
                    return months[this.getMonth()];
                };
                Date.prototype.getDayName = function () {
                    return days[this.getDay()];
                };
            })();

            var today = new Date();
            var day = today.getDayName();
            var dayNumber = today.getDate();
            var month = today.getMonthName();

//            console.log(src);

            src = $scope.formatReservas(src);
            
//            console.log(src);

            $scope.sourceClock = {
                date: new Date(),
                config: {
                    id: 'holder',
                    size: {
                        width: 200,
                        height: 200
                    },
                    mode: 'numbers',
                    theme: {
                        background: '#ffffff',
                        elements: '#575757',
                        multicolor: false
                    }
                },
                source: src,
                cancelDate: function () {
                    $scope.clock = !$scope.clock;
                    $scope.alerts.code = !$scope.alerts.code;
                },
                today: day + ' ' + dayNumber + ' de ' + month
            };
            
            if (apply)
                $scope.$apply();
        };

        $scope.alerts = {
            code: false,
            confirm: false,
            ocuped: false,
            reserved: false
        };

        $scope.clock = true;

        $scope.disparo = function (dStartString) {
            window.location = "cargarresxdia:" + dStartString;
        };

        $scope.datosDeCancelacion = {};
        $scope.numeroDeReservaActual = '0';

        $scope.sourceAlert = {
            /* Alerta de Confirmación de la cancelación de Reserva */
            confirm: {
                title: "Cancelar reserva",
                name: '',
                mail: '',
                accept: function () {
//                    console.log('eliminarres:' + $scope.numeroDeReservaActual);
                    window.location = 'eliminarres:' + $scope.numeroDeReservaActual;
                    $scope.alerts.confirm = !$scope.alerts.confirm;
                    $scope.clock = !$scope.clock;
                    setTimeout(function () {
                        location.reload();
                    }, 200);
                },
                back: function () {
//                    console.log('Back');
                    location.reload();
                }
            },
            /* Alerta de Cancelación de Reserva */
            code: {
                accept: function () {
                    var valor = document.getElementById("codigoReserva").value;
                    $scope.numeroDeReservaActual = valor;
                    if (valor !== '') {
                        $reserva.getcargaDatos(valor, function (event, data) {
                            if (data.employeeId != undefined) {
//                                console.log('Pintar');
                                $scope.datosDeCancelacion = data;
                                $rootScope.spin = false;
                                $scope.alerts.code = !$scope.alerts.code;
                                $scope.alerts.confirm = !$scope.alerts.confirm;

                                $scope.sourceAlert.confirm.name = $scope.datosDeCancelacion.reservedBy;
                                $scope.sourceAlert.confirm.mail = $scope.datosDeCancelacion.mail;
                                
                                $scope.sourceAlert.code.showError = true;
                            } else {
                                $scope.sourceAlert.code.showError = false;
                                $rootScope.spin = false;
                                document.getElementById("codigoReserva").value = '';
//                                console.log('No pintar');
                            }
                        });
                    } else {
//                        console.log(valor);
                    }
                },
                back: function () {
                    $scope.sourceAlert.code.showError = true;
                    $scope.clock = !$scope.clock;
                    $scope.alerts.code = !$scope.alerts.code;
                },
                showError: true
            },
            ocuped: {
                name: 'Karla Delevigne',
                photo: 'http://media.vogue.com/r/w_660/2014/12/11/best-eyelashes-cara-delevingne.jpg',
                date: {
                    number: '8',
                    day: 'martes',
                    month: 'diciembre'
                },
                start: {
                    hour: '8',
                    time: 'PM'
                },
                end: {
                    hour: '9',
                    time: 'PM'
                },
                accept: function () {
                    alert();
                }
            },
            reserved: {
                name: 'Karla',
                code: '1234',
                photo: 'http://media.vogue.com/r/w_660/2014/12/11/best-eyelashes-cara-delevingne.jpg',
                accept: function () {
                    alert('my love');
                }
            }
        };


        $scope.reloadClock([], false);
        $scope.disparo($scope.today.parseToStringShort());


    };

    controller.$inject = ['$rootScope', '$scope', '$reserva'];
    angular.module('Hall').controller('HomeController', controller);

})();