/*global angular*/
/*jslint browser:true*/

(function () {

    var controller = function ($scope, $rootScope, $phoneProvider) {

        $scope.employeeList = [];
        $scope.options = $rootScope.session.horario;
        $scope.numeroEmpleado = '';
        $scope.mostrarAlerta = false;
        $scope.mostrarRegistros = false;
        $scope.mostrarBotonClear = false;
        $scope.reservacionLista = false;
        $scope.empleadoSeleccionado = {};
        $scope.correoEmpleado = '';
        $scope.motivoEmpleado = '';

        $scope.clearAll = function () {
            $scope.numeroEmpleado = '';
            $scope.correoEmpleado = '';
            $scope.motivoEmpleado = '';
            $scope.mostrarAlerta = false;
            $scope.mostrarRegistros = false;
            $scope.mostrarBotonClear = false;
            $scope.reservacionLista = false;
            $scope.empleadoSeleccionado = {};
        };

        $scope.buscarEmpleado = function () {

            if ($scope.numeroEmpleado.length) {

                /* Aquí se llama el ws */
                $phoneProvider.getRegistros($scope.numeroEmpleado, function (event, data) {

                    $scope.employeeList = data;

                    if ($scope.employeeList.length > 0) {

                        if ($scope.employeeList.length == 1) {
                            $scope.mostrarRegistros = false;
                            $scope.mostrarAlerta = true;
                            $scope.numeroEmpleado = (($scope.employeeList[0].reservedBy)).toTitleCase();
                            
                            $scope.correoEmpleado = $scope.employeeList[0].mail;
                            $scope.motivoEmpleado = $scope.employeeList[0].motivo ? $scope.employeeList[0].motivo : '';

                            $scope.empleadoSeleccionado = $scope.employeeList[0];
                            
                            if($scope.employeeList[0].mail != ''){
                                $scope.reservacionLista = true;
                            } else {
                                $scope.reservacionLista = false;
                            }
                            
                            
                        } else if ($scope.employeeList.length === 0) {
                            $scope.mostrarRegistros = false;
                            $scope.reservacionLista = false;
                            $scope.empleadoSeleccionado = {};
                        } else {
                            $scope.mostrarRegistros = true;
                            $scope.mostrarAlerta = false;
                            $scope.reservacionLista = false;
                            $scope.empleadoSeleccionado = {};
                        }
                    } else {
                        $scope.mostrarRegistros = false;
                        $scope.reservacionLista = false;
                        $scope.empleadoSeleccionado = {};
                    }

                });

            } else {
                $scope.mostrarBotonClear = false;
                $scope.mostrarRegistros = false;
                $scope.mostrarAlerta = false;
                $scope.reservacionLista = false;
                $scope.empleadoSeleccionado = {};

            }
        };

        function validateEmail(email) {
            var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(email);
        }

        $scope.validarCorreo = function () {
            var correoValido = validateEmail($scope.correoEmpleado);
            $scope.reservacionLista = correoValido;
            console.log(correoValido);
        };


        $scope.selectThis = function (index) {
            $scope.mostrarRegistros = false;
            $scope.mostrarAlerta = true;
            $scope.numeroEmpleado = (($scope.employeeList[index].reservedBy)).toTitleCase();
            $scope.correoEmpleado = $scope.employeeList[index].mail;
            $scope.empleadoSeleccionado = $scope.employeeList[index];
            $scope.motivoEmpleado = $scope.employeeList[index].motivo ? $scope.employeeList[index].motivo : '';
            $scope.reservacionLista = true;
        };
        
        $scope.validarMotivo = function() {
            if($scope.motivoEmpleado !== '') {
                $scope.reservacionLista = true;
            } else {
                $scope.reservacionLista = false;
            }
            
        };

        $scope.confirmarReservacion = function () {
            if ($scope.reservacionLista) {

                $rootScope.spin = true;

                for (var i = 0; i < $rootScope.session.arrToSave.length; i++) {

                    $rootScope.session.arrToSave[i].reservedBy = ($scope.empleadoSeleccionado.reservedBy).toTitleCase();
                    $rootScope.session.arrToSave[i].employeeId = $scope.empleadoSeleccionado.employeeId;
                    $rootScope.session.arrToSave[i].mail = $scope.correoEmpleado;
                    $rootScope.session.arrToSave[i].motivo = $scope.motivoEmpleado;
                    $rootScope.session.arrToSave[i].reservaId = $rootScope.session.arrToSave[0].reservaId;

                }

                $phoneProvider.insertReserva($rootScope.session.arrToSave);

                $rootScope.session.employee = $scope.empleadoSeleccionado;
                $rootScope.session.employee.mail = $scope.correoEmpleado;
                $rootScope.session.code = $rootScope.session.arrToSave[0].reservaId;

                setTimeout(function () {
                    $rootScope.spin = false;
                    window.location = '#/reservacion';
                }, 500);

            }

        };

    };


    controller.$inject = ['$scope', '$rootScope', '$phoneProvider'];
    angular.module('Hall').controller('BusquedaController', controller);

})();