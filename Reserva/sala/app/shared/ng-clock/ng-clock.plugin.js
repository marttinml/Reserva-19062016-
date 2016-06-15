/*exported Clock*/
/*global Raphael*/
/*jslint browser:true*/
var Clock = function (options) {

    var self = this;

    self.now = new Date();

    self.config = options;
    self.Paper = Raphael(
        self.config.id,
        self.config.size.width,
        self.config.size.height);

    self.elements = (function () {
        var hour_sign = {};
        var hour_text = {};

        var time = {
            hours: self.now.getHours(),
            minutes: self.now.getMinutes(),
            seconds: self.now.getSeconds()
        };

        var theme = self.config.attributes;

        return {
            clock: self.Paper.circle(self.config.size.center, self.config.size.center, 95),
            hands: {
                hour: self.Paper.path('M' +
                    self.config.size.center + ' ' +
                    self.config.size.center + 'L' +
                    self.config.size.center + ' ' +
                    self.config.size.hands.hours),
                minute: self.Paper.path('M' +
                    self.config.size.center + ' ' +
                    self.config.size.padding[1] + 'L' +
                    self.config.size.center + ' ' +
                    self.config.size.hands.minutes),
                second: self.Paper.path('M' +
                    self.config.size.center + ' ' +
                    self.config.size.padding[0] + 'L' +
                    self.config.size.center + ' ' +
                    self.config.size.hands.seconds)
            },
            pin: self.Paper.circle(self.config.size.center, self.config.size.center, 2),
            setHours: function () {
                for (var i = 0; i < 12; i++) {

                    var start_x = self.config.size.center +
                        Math.round(80 * Math.cos(30 * i * Math.PI / 180));
                    var start_y = self.config.size.center +
                        Math.round(80 * Math.sin(30 * i * Math.PI / 180));
                    var end_x = self.config.size.center +
                        Math.round(90 * Math.cos(30 * i * Math.PI / 180));
                    var end_y = self.config.size.center +
                        Math.round(90 * Math.sin(30 * i * Math.PI / 180));

                    if (self.config.mode == 'numbers') {
                        if (i > 9) {
                            hour_text = self.Paper
                                .text(start_x, start_y, i - 9)
                                .attr({
                                    'fill': self.config.color[1]
                                });
                        } else {
                            hour_text = self.Paper
                                .text(start_x, start_y, i + 3)
                                .attr({
                                    'fill': self.config.color[1]
                                });
                        }

                    } else {
                        hour_sign = self.Paper
                            .path("M" + start_x + " " + start_y + "L" + end_x + " " + end_y)
                            .attr(theme.hours);
                    }
                }
            },
            setTime: function () {
                self.elements.hands.hour
                    .rotate(30 * time.hours + (time.minutes / 2.5),
                        self.config.size.center,
                        self.config.size.center)
                    .attr(theme.hands.hours);
                self.elements.hands.minute
                    .rotate(6 * time.minutes,
                        self.config.size.center,
                        self.config.size.center)
                    .attr(theme.hands.minutes);
                self.elements.hands.second
                    .rotate(6 * time.seconds,
                        self.config.size.center,
                        self.config.size.center)
                    .attr(theme.hands.seconds);
            },
            setClock: function () {
                self.elements.clock
                    .attr(theme.clock);
            },
            setPin: function () {
                self.elements.pin
                    .attr(theme.pin);
            },
            init: function () {
                self.elements.setClock();
                self.elements.setTime();
                self.elements.setHours();
                self.elements.setPin();
            }
        };
    })();

    self.tiktok = function (object) {
        if (object.hands !== undefined) {
            setInterval(function () {
                object.hands.second.rotate(6,
                    self.config.size.center,
                    self.config.size.center);
                object.hands.minute.rotate(6 / 60,
                    self.config.size.center,
                    self.config.size.center);
                object.hands.hour.rotate(6 / 3600,
                    self.config.size.center,
                    self.config.size.center);
            }, 1000);
        } else {
            alert('Error');
        }
    };

    self.Paper.customAttributes.arc = function (xloc, yloc, value, total, R) {
        var alpha = 360 / total * value,
            a = (90 - alpha) * Math.PI / 180,
            x = xloc + R * Math.cos(a),
            y = yloc - R * Math.sin(a),
            path;
        if (total == value) {
            path = [
              ["M", xloc, yloc - R],
              ["A", R, R, 0, 1, 1, xloc - 0.01, yloc - R]
          ];
        } else {
            path = [
              ["M", xloc, yloc - R],
              ["A", R, R, 0, +(alpha > 180), 1, x, y]
          ];
        }
        return {
            path: path
        };
    };

    self.readColors = function (json) {

        var i = 0;
        var ii = json.arrayColors.length;
        var constantHourse = (100 / 12);
        var delayed = 1 / ii;

        for (i; i < ii; i++) {
            var delay = i * delayed;
            var myArc = self.Paper
                .path()
                .attr({
                    'stroke': json.arrayColors[i].color,
                    'stroke-width': 3,
                    arc: [
                    self.config.size.center,
                    self.config.size.center,
                    constantHourse * (json.arrayColors[i].start),
                    100, 95]
                });
            var myAnimation = Raphael.animation({
                arc: [
                    self.config.size.center,
                    self.config.size.center,
                    constantHourse * (json.arrayColors[i].end),
                    100, 95]
            }, delayed);

            myArc.animate(myAnimation.delay(delay / 12));

        }
    };

    self.drawDates = function () {

        var citaPancho = self.config.source;


        function proccessClock(obj) {
            var arrayTotal = [
                {
                    start: 0,
                    end: 1,
                    color: '#ffffff'
                },
                {
                    start: 1,
                    end: 2,
                    color: '#ffffff'
                },
                {
                    start: 2,
                    end: 3,
                    color: '#ffffff'
                },
                {
                    start: 3,
                    end: 4,
                    color: '#ffffff'
                },
                {
                    start: 4,
                    end: 5,
                    color: '#ffffff'
                },
                {
                    start: 5,
                    end: 6,
                    color: '#ffffff'
                },
                {
                    start: 6,
                    end: 7,
                    color: '#ffffff'
                },
                {
                    start: 7,
                    end: 8,
                    color: '#ffffff'
                },
                {
                    start: 8,
                    end: 9,
                    color: '#ffffff'
                },
                {
                    start: 9,
                    end: 10,
                    color: '#ffffff'
                },
                {
                    start: 10,
                    end: 11,
                    color: '#ffffff'
                },
                {
                    start: 11,
                    end: 12,
                    color: '#ffffff'
                }
            ];

            var elements = obj.length;

            for (var k = 0; k < elements; k++) {

                var inicio = obj[k].start < 12 ? obj[k].start : (obj[k].start - 12);
                var final = obj[k].end < 12 ? obj[k].end : (obj[k].end - 12);
                var ccolor = obj[k].color;

                // acompleto con el espacio en uso

                for (var j = inicio; j < final; j++) {

                    var valorEnColor = {
                        start: inicio,
                        end: inicio + (final - inicio),
                        color: self.config.multicolor ? ccolor : '#da4242'
                    };
                    arrayTotal[inicio] = valorEnColor;

                }
            }


            arrayTotal.reverse();

            console.log(arrayTotal);

            return arrayTotal;
        }

        var objeto = {
            arrayColors: proccessClock(citaPancho)
        };

        self.readColors(objeto);
    };

    self.onClock = function () {
        self.elements.init();

        self.Paper.setViewBox(0, 0,
            self.config.size.width,
            self.config.size.height,
            true);

        var svg = document.querySelector("svg");
        svg.removeAttribute("width");
        svg.removeAttribute("height");
        self.tiktok(self.elements);
    };

    self.init = function () {
        self.onClock();
        self.drawDates();
    };
};