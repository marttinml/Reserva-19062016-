/*global angular*/
(function(){
    var directive = function(){

        var colors = ['#60b5e1','#59d0b3','#ef6fac','#f68946','#60b5e1','#94bf37','#f04065','#f3bf52','#309da0','#21be9e','#a05870','#885bbc'];
        var color  = colors[Math.floor(Math.random() * 12)];

        var calendarFactory = function(dateStart, dateEnd, reservas){

            color = colors[Math.floor(Math.random() * 12)];
          

            var months          = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
            var days            = [{day:'Lunes',today:false},{day:'Martes',today:false},{day:'Miercoles',today:false},{day:'Jueves',today:false},{day:'Viernes',today:false}];
            var dateStartTemp   = new Date(dateStart);
            var dateNow         = new Date();
            var obj             = {};
            var hrs             = 26;

            obj.color           = color;
            obj.dateStart       = dateStart;
            obj.dateEnd         = dateEnd;
            obj.month           = months[dateStart.getMonth()];
            obj.year           = dateStart.getFullYear();
            obj.days            = [];
            obj.hoursByDay      = [];


            for(var i = 0; i < 5 ; i++){
                var objDay = {
                        day:days[i].day+' '+dateStartTemp.getDate(),
                        today: dateStartTemp.isToDay(),
                        lastDay: dateStartTemp.isLastDay()
                    };
                obj.days.push(objDay);
                dateStartTemp.setDate(dateStartTemp.getDate() + 1);
            }

            dateStartTemp = new Date(dateStart);


            var isReserved = function(t1, t2){
                var obj = {};
                
                console.log('reservas');
                console.log(reservas);
                
                for(var i = 0; i < reservas.length; i++){
                    var objStatus = { id:0, name:'reserved' };
                    if(reservas[i].timeStart.getTime() === t1.getTime() && reservas[i].timeEnd.getTime() === t2.getTime()){
                        obj.data = reservas[i];
                        obj.data.status = objStatus;
                        obj.status = true;
                        return obj;
                    }
                }
                obj.status = false;
                return obj;
            };


            for( var i = 0 ; i < 5 ; i++ ){
                obj.hoursByDay.push([]);
                dateStartTemp.setHours(8);


                for( var j = 0; j < hrs ; j++ ){

                    var timeStartV = new Date(dateStartTemp);
                    //var timeEndV = new Date(dateStartTemp.setHours(dateStartTemp.getHours()+1));
                    var timeEndV = new Date(dateStartTemp.setMinutes(dateStartTemp.getMinutes()+30));
                    var objReserva = {};
                    var isReservedObj = isReserved(timeStartV, timeEndV);

                    var objStatus = { id:1, name:'free' };
                    if(dateStartTemp < dateNow){
                        objStatus = { id:4, name:'past' };
                    }

                    if(isReservedObj.status){
                        objReserva = isReservedObj.data;
                        if(dateStartTemp < dateNow){
                            objReserva.status = { id:3, name:'out' };
                        }
                    }else{
                        objReserva = {
                            reservaId   :  '' + timeStartV.getCode(), 
                            status      :  objStatus,       
                            color       :  color, 
                            timeStart   :  timeStartV,  
                            timeEnd     :  timeEndV,  
                            reservedBy  : '', 
                            employeeId  : '0', 
                            picture     : '',
                            mail        : '',
                            hora        : '0',
                            week        : timeStartV.getWeek(),
                            i:i,
                            j:j
                        };
                    }

                    
                    
                    obj.hoursByDay[i].push(objReserva);

                }
                dateStartTemp.setDate(dateStartTemp.getDate() + 1)
            }

            return obj;
        };

        var resize = function(element, h, w){

            element.css( { height: window.innerHeight +'px'});
            angular.element(element.children()[2]).css( { height: (h - 280) +'px'});
        };

        var config = function(element){
            element.addClass('ng-calendar');
            
            resize(element, window.innerHeight, window.innerWidth);

            angular.element(window).bind('resize',function(event){
                setTimeout(function(){
                     resize(element, window.innerHeight, window.innerWidth);
                },500);
            });

        };

        var getReservas = function(obj){
            var arr = [];
            for(var i = 0 ; i < obj.length ; i++){
                for(var j = 0 ; j < obj[i].length ; j++){

                    if(obj[i][j].status.id == 2){
                        arr.push(obj[i][j]);
                    }

                }
            }

            return arr;
        };

        var settingReservaTemp = function(scope){

            scope.reservaSummary = {reservaTemp:false};
            if(scope.reservas.length > 0){
                scope.reservaSummary.dateStart = scope.reservas.list[0].timeStart;
                scope.reservaSummary.dateEnd = scope.reservas.list[scope.reservas.length - 1].timeEnd;
                scope.reservaSummary.reservaTemp = true;
            }

        };

        var validateReserve = function(scope, i, j){
            var isValid = false;

                if(scope.calendar.hoursByDay[i][j].status.id == 1){

                    

                    if(scope.reservas.length == 0){
                        scope.reservas.list.push(scope.calendar.hoursByDay[i][j]);
                        scope.reservas.colum = i;
                        scope.reservas.indexStart = j;
                        scope.reservas.indexEnd = j;
                        scope.reservas.week = scope.calendar.hoursByDay[i][j].week;
                        scope.reservas.length++;
                        isValid = true;
                    }else{

                        if(scope.reservas.colum != i || scope.reservas.week != scope.calendar.hoursByDay[i][j].week){
                            for(var k = 0; k < scope.reservas.list.length ; k++){
                                var obj = {id:1 ,name:'free'}
                                scope.reservas.list[k].status = obj;
                            }
                            scope.reservas.list = [(scope.calendar.hoursByDay[i][j])];
                            scope.reservas.colum = i;
                            scope.reservas.indexStart = j;
                            scope.reservas.indexEnd = j;
                            scope.reservas.length = 1;
                            scope.reservas.week = scope.calendar.hoursByDay[i][j].week;
                            isValid = true;

                        }else{
                            if( (scope.reservas.indexStart - 1) == j  ){
                                scope.reservas.list.unshift(scope.calendar.hoursByDay[i][j]);
                                scope.reservas.indexStart = j;
                                scope.reservas.length++;
                                isValid = true;
                            }else{ 
                                if( (scope.reservas.indexEnd + 1 ) == j ){
                                    scope.reservas.list.push(scope.calendar.hoursByDay[i][j]);
                                    scope.reservas.indexEnd = j;
                                    scope.reservas.length++;
                                    isValid = true;
                                }else{
                                    console.log('selección por rango');

                                    if(scope.reservas.list.length > 1){
                                        for(var k = 0; k < scope.reservas.list.length ; k++){
                                            var obj = {id:1 ,name:'free'}
                                            scope.reservas.list[k].status = obj;
                                        }

                                        scope.reservas.list = [(scope.calendar.hoursByDay[i][j])];
                                        scope.reservas.colum = i;
                                        scope.reservas.indexStart = j;
                                        scope.reservas.indexEnd = j;
                                        scope.reservas.length = 1;
                                        isValid = true;

                                    }else{
                                        if( j > scope.reservas.list[0].j){
                                            console.log('+');
                                            for(var k = (scope.reservas.list[0].j + 1) ; k <= j ; k++ ){
                                                var obj = {id:2,name:'selected'};
                                                scope.calendar.hoursByDay[i][k].status = obj;
                                                scope.reservas.list.push(scope.calendar.hoursByDay[i][k]);
                                                scope.reservas.length++;
                                            }
                                            scope.reservas.indexEnd = j;
                                            isValid = true;
                                            console.log(scope.reservas.list);
                                        }else{
                                            console.log('-');                                            
                                            for(var k = (scope.reservas.list[0].j - 1) ; k >= j ; k-- ){
                                                var obj = {id:2,name:'selected'};
                                                scope.calendar.hoursByDay[i][k].status = obj;
                                                scope.reservas.list.unshift(scope.calendar.hoursByDay[i][k]);
                                                scope.reservas.length++;
                                            }
                                            scope.reservas.indexStart = j;
                                            isValid = true;
                                            console.log(scope.reservas.list);
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                    }

                    if(isValid){
                        var obj = {id:2,name:'selected'}
                        scope.calendar.hoursByDay[i][j].status = obj;
                    }


                }else{

                    if(scope.reservas.length != 1){
                        if(scope.reservas.indexStart == j){
                            scope.reservas.list.shift();
                            scope.reservas.indexStart++;
                            scope.reservas.length--;
                            isValid = true;
                        }else{
                            if(scope.reservas.indexEnd == j){
                                scope.reservas.list.pop();
                                scope.reservas.indexEnd--;
                                scope.reservas.length--;
                                isValid = true;
                            }else{

                                for(var k = 0; k < scope.reservas.list.length ; k++){
                                    var obj = {id:1 ,name:'free'}
                                    scope.reservas.list[k].status = obj;
                                }
                                scope.reservas.list = [(scope.calendar.hoursByDay[i][j])];
                                scope.reservas.indexStart = j;
                                scope.reservas.indexEnd = j;
                                scope.reservas.length = 1;

                                var obj = {id:2,name:'selected'};
                                scope.calendar.hoursByDay[i][j].status = obj;

                            }
                        }
                    }else{
                        scope.reservas = {
                            list        : [],
                            colum       : null,
                            indexStart  : null,
                            indexEnd    : null,
                            length      : 0
                        };
                        isValid = true;
                    }


                    if(isValid){
                        var obj = {id:1 ,name:'free'};
                        scope.calendar.hoursByDay[i][j].status = obj;
                    }

                }

                if(scope.reservas.length == 1){
                    scope.reservas.list[0].hora = '1'
                }else{
                    if(scope.reservas.length > 1){
                        for(var k = 0; k < scope.reservas.list.length ; k++){
                            scope.reservas.list[k].hora = '0';
                        }
                    }
                }
                settingReservaTemp(scope);
                if(scope.reservas.length){
                    scope.onReserve = false;
                }else{
                    scope.onReserve = true;
                }
        };

        var formatReservas = function(arr){

            var result = arr.cloneReserva();

            for(var i = 0; i < result.length ; i++){
                result[i].timeStart = result[i].timeStart.parseToString();
                result[i].timeEnd   = result[i].timeEnd.parseToString();
            }
            return result;
        };


        var link = function(scope, element, attrs){

            scope.afterWeek = false;
            scope.reservaSummary = {reservaTemp:false};
            scope.onReserve = true;

            scope.afterWeekValid = function(dateStart){

                var dateStartTemp = new Date(dateStart);
                var dateNow     = new Date();
                var weekNow     = dateNow.getWeek();
                var dateAfter   = new Date(dateStartTemp.setDate(dateStartTemp.getDate() - 7));
                var weekAfter    = dateAfter.getWeek();

                scope.afterWeek = weekNow <= weekAfter || dateNow.getFullYear() < dateStart.getFullYear() ? true : false;

                console.log((dateNow.getFullYear() * 55) + weekNow ) +' <= '+ (weekAfter + (dateStart.getFullYear() * 55));
               // alert(scope.afterWeek);
            };

            scope.reservas = {
                list        : [],
                week        : null,
                year        : null,
                colum       : null,
                indexStart  : null,
                indexEnd    : null,
                length      : 0
            };

            scope.setting = function(options){
                scope.options = options;
                scope.calendar = {};
                scope.calendar = calendarFactory(scope.options.dateStart, scope.options.dateEnd, scope.options.reservas);
                config(element);
                scope.afterWeekValid(scope.options.dateStart);
            };
            

            scope.toggleReserved = function(i, j){
                validateReserve(scope, i, j);

            };

            scope.showSummary = function(i,j){

                var objSummary = JSON.parse(JSON.stringify(scope.calendar.hoursByDay[i][j]));
                var reservaId = objSummary.reservaId;
                var first = false;
                
                console.log(scope.calendar.hoursByDay[i][j]);

                for(var k = 0; k < scope.calendar.hoursByDay[i].length; k++){
                    if(reservaId == scope.calendar.hoursByDay[i][k].reservaId){
                        objSummary.timeStart = !first ? scope.calendar.hoursByDay[i][k].timeStart : objSummary.timeStart;
                        objSummary.timeEnd = scope.calendar.hoursByDay[i][k].timeEnd;
                        first = true;
                    }
                }
                console.log(objSummary);
                scope.eventShowSummary()(objSummary);
            };

            scope.eventReserve = function(){

                if(scope.reservas.length){
                    // Redirecciona a la vista de búsqueda
                    window.location = '#/busqueda';
                    
                    // Prepara el objeto seleccionado
                    var result = formatReservas(scope.reservas.list);
                    scope.setReserva()(scope.reservaSummary, result);
                }
            };

            scope.eventBackWeek = function(){

                if(scope.afterWeek){
                    scope.transitionRight = true;
                    setTimeout(function(){
                        console.log('eventBackWeek');
                        console.log(scope.calendar.dateStart);
                        
                        var dateStartNew = new Date(scope.calendar.dateStart);
                        dateStartNew = dateStartNew.setDate(dateStartNew.getDate()-7);
                        var dateEndNew = new Date(dateStartNew);
                        dateEndNew = dateEndNew.setDate(dateEndNew.getDate()+4);
                        scope.nextWeek()(new Date(dateStartNew), new Date(dateEndNew));
                        scope.transitionRight = false;
                        scope.$apply();
                    },500);
                    
                }
            };

            scope.eventNextWeek = function(){

                scope.transitionLeft = true;
                setTimeout(function(){
                    console.log('eventNextWeek');
                    console.log(scope.calendar.dateStart);
                    
                    var dateStartNew = new Date(scope.calendar.dateStart);
                    dateStartNew = dateStartNew.setDate(dateStartNew.getDate()+7);
                    var dateEndNew = new Date(dateStartNew);
                    dateEndNew = dateEndNew.setDate(dateEndNew.getDate()+4);
                    scope.nextWeek()(new Date(dateStartNew), new Date(dateEndNew));
                    scope.transitionLeft = false;
                    scope.$apply();
                },500);
            };

            scope.$watch('options',function(options){
                !options.isEmpty() && scope.setting(options);
            },true);


            //touch swipe
            scope.ngSwipeLeft = function(){
                console.log('ngSwipeLeft');
                scope.eventBackWeek();
            };
            scope.ngSwipeRight = function(){
                console.log('ngSwipeRight');
                scope.eventNextWeek();
            };

        };

        return {
            restrict: 'A',
            templateUrl: 'app/shared/ng-calendar/ng-calendar.template.html',
            link:link,
            scope: {
                options: '=source',
                setReserva:'&onReserve',
                nextWeek:'&onNextWeek',
                backWeek:'&onBackWeek',
                eventShowSummary:'&onShowSummary'
            }
        };
    };
    angular.module('ngCalendar', []).directive('ngCalendar', directive);
})();