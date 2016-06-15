/*global angular*/
angular.module('titleCaseFilter', [])
    .filter('megas', function () {
        return function (strToFilter, filterName) {

            if (!strToFilter) {
                return '';
            }

            var newStrToFilter = strToFilter.substr(0, strToFilter.indexOf(' '));


            var value = newStrToFilter.toString().trim().replace(/^\+/, '');

            var newInt = parseInt(value);

            if (filterName == 'GB') {
                newInt = newInt / 1024;
                newInt = Math.round(newInt * 10) / 10;
            }

            return (newInt + ' ' + filterName).trim();
        };
    })
    .filter('titlecase', function () {
        return function (strToFilter) {

            if (!strToFilter) {
                return '';
            }

            var str = strToFilter.replace(/\w\S*/g, function (txt) {
                return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
            });

            return str;
        };
    });