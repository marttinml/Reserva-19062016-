/*global angular*/
(function () {

    var Confirm = function () {

        var link = function (rootScope, scope, element, attrs) {
            
        };

        return {
            restrict: 'A',
            templateUrl: 'app/shared/ng-alert/ng-alert.confirm.template.html',
            link: link,
            scope: {
                options: '=source'
            }
        };
    };
    var Code = function () {

        var link = function (scope, element, attrs) {
            scope.$watch('options.code.showError', function (val) {
                scope.options.code.showError = scope.options.code.showError;
            });
        };

        return {
            restrict: 'A',
            templateUrl: 'app/shared/ng-alert/ng-alert.code.template.html',
            link: link,
            scope: {
                options: '=source'
            }
        };
    };
    var Ocuped = function () {

        var link = function (scope, element, attrs) {

        };

        return {
            restrict: 'A',
            templateUrl: 'app/shared/ng-alert/ng-alert.ocuped.template.html',
            link: link,
            scope: {
                options: '=source'
            }
        };
    };
    var Reserved = function () {

        var link = function (scope, element, attrs) {

        };

        return {
            restrict: 'A',
            templateUrl: 'app/shared/ng-alert/ng-alert.reserved.template.html',
            link: link,
            scope: {
                options: '=source'
            }
        };
    };

    function toTitleCase(str) {
        return str.replace(/\w\S*/g, function (txt) {
            return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
        });
    }

    function getFirstWord(str) {
        var res = str.split(' ');
        return res[0];
    }


    var Predictivo = function () {
        var link = function ($scope) {
            $scope.busqueda = false;
            $scope.Buscar = function () {
                $scope.busqueda = !$scope.busqueda;
            };
            $scope.result1 = '';
            $scope.options1 = null;
            $scope.details1 = '';


            $scope.objetoChapu = {};
            $scope.correosPlugin = ['@att.com.mx', '@nextel.com.mx', '@iusacell.com.mx'];
            $scope.itemEmail = $scope.correosPlugin[0];

            $scope.elegirCorreo = function (index) {
                $scope.itemEmail = $scope.correosPlugin[index];

            };

            $scope.selectIsOpen = false;

            $scope.toggleSelect = function () {
                $scope.selectIsOpen = !$scope.selectIsOpen;
            };


            $scope.$watch('options.employeeList', function (val) {

                $scope.options.employeeList = $scope.options.employeeList || [];

                for (var i = 0; i < $scope.options.employeeList.length; i++) {
                    $scope.options.employeeList[i].reservedBy = toTitleCase($scope.options.employeeList[i].reservedBy);
                }

            });
            $scope.onConfirm = true;


            $scope.selected = function (index) {

                // crear el objeto cuando se selecciona
                $scope.typed = toTitleCase($scope.options.employeeList[index].reservedBy);

                
                if($scope.options.employeeList[index].mail !== '' && $scope.options.employeeList[index].mail !== ' '){
                    $scope.itemEmail = '@' + $scope.options.employeeList[index].mail.split("@")[1];
                    $scope.correoInput = $scope.options.employeeList[index].mail.split("@")[0];
                    $scope.onConfirm = !$scope.onConfirm;
                }
                

                $scope.objetoChapu = {
                    reservedBy: $scope.options.employeeList[index].reservedBy,
                    employeeId: $scope.options.employeeList[index].employeeId,
                    mail: $scope.options.employeeList[index].mail
                };

                $scope.options.employeeList = [];
            };
            
            $scope.resultados = false;
            
            $scope.searchUser = function (text) {
                $scope.typing()(text);
                console.log($scope.correoInput);
                console.log($scope.options.employeeList);
                if ($scope.correoInput !== '' && $scope.correoInput !== undefined) {
                    $scope.onConfirm = false;
                } else {
                    $scope.onConfirm = true;
                }
            };

            $scope.validationFields = function () {
                if ($scope.typed !== '' && $scope.typed !== undefined) {
                    $scope.onConfirm = false;
                } else {
                    $scope.onConfirm = true;
                }
            };



            $scope.aceptarInput = function () {

                if (!$scope.onConfirm) {
                    if ($scope.typed === $scope.objetoChapu.reservedBy && $scope.typed !== '') {
                        if ($scope.objetoChapu.isEmpty()) {
                            console.log('esta vacio');
                        } else {
                            console.log('esta lleno hay que enviarlo');

                            $scope.objetoChapu.reservedBy = $scope.typed;
                            $scope.objetoChapu.mail = $scope.correoInput + $scope.itemEmail;

                            $scope.eventSelected()($scope.objetoChapu);
                            $scope.close();
                        }
                    } else {
                        console.log($scope.correoInput);
                        $scope.options.employeeList = [];

                        $scope.objetoChapu = {
                            reservedBy: $scope.typed,
                            employeeId: '0',
                            mail: $scope.correoInput + $scope.itemEmail
                        };

                        $scope.eventSelected()($scope.objetoChapu);
                        $scope.close();
                    }
                }


            };


            $scope.close = function () {
                $scope.options.open = false;
            };

        };

        return {
            restrict: 'A',
            templateUrl: 'app/shared/ng-alert/ng-alert.predictivo.template.html',
            link: link,
            scope: {
                options: '=source',
                typing: '&onTyping',
                eventSelected: '&onSelected'
            }
        };
    };

    angular.module('ngAlert', [])
        .directive('ngAlertConfirm', Confirm)
        .directive('ngAlertReserved', Reserved)
        .directive('ngAlertOcuped', Ocuped)
        .directive('ngAlertCode', Code)
        .directive('ngAlertPredictivo', Predictivo);
})();