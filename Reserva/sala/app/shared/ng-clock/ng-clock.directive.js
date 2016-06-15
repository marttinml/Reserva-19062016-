/*global angular, Clock*/
/**/
(function () {
    var directive = function () {



        var link = function (scope, element, attrs) {


            scope.$watch('options', function (obj) {
                
//                element.html();
//                document.getElementById('holder').removeChild();
                
                var config = obj.config;
                var sourceArray = obj.source;

                function makeConfig(options, source) {
                    var self = this;
                    self.config = {
                        id: options.id,
                        size: {
                            width: options.size.width,
                            height: options.size.height,
                            center: (options.size.width + options.size.height) / 4,
                            scale: {
                                x: 1,
                                y: 1
                            },
                            padding: [
                                ((options.size.width + options.size.height) / 4) + 15,
                                ((options.size.width + options.size.height) / 4) + 10],
                            hands: {
                                seconds: (options.size.width / 2) * 0.3,
                                minutes: (options.size.width / 2) * 0.4,
                                hours: (options.size.width / 2) * 0.6
                            }
                        },
                        mode: options.mode,
                        source: source,
                        multicolor: options.theme.multicolor,
                        color: [options.theme.background, options.theme.elements],
                        attributes: {
                            clock: {
                                'fill': options.theme.background || '#fff',
                                'fill-opacity': 0.85,
                                'stroke': options.theme.background || '#fff',
                                'stroke-width': 3
                            },
                            hands: {
                                seconds: {
                                    'stroke': options.theme.elements || '#333',
                                    'stroke-width': 0.5
                                },
                                minutes: {
                                    'stroke': options.theme.elements || '#333',
                                    'stroke-width': 0.8
                                },
                                hours: {
                                    'stroke': options.theme.elements || '#333',
                                    'stroke-width': 1
                                }
                            },
                            pin: {
                                'fill': options.theme.elements || '#333',
                                'stroke': options.theme.elements || '#333'
                            },
                            hours: {
                                'stroke': options.theme.elements || '#333'
                            }
                        }
                    };

                    return self.config;
                }

                var options = makeConfig(config, sourceArray);
                var clock = new Clock(options);
                clock.init();
            });


        };




        return {
            restrict: 'A',
            templateUrl: 'app/shared/ng-clock/ng-clock.template.html',
            link: link,
            scope: {
                options: '=source'
            }
        };
    };
    angular.module('ngClock', []).directive('ngClock', directive);
})();