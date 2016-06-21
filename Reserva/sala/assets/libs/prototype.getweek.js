Date.prototype.getWeek = function() {
    var onejan = new Date(this.getFullYear(), 0, 1);
    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay() + 1) / 7);
}

Date.prototype.parseToString = function() {
	var hours = this.getHours() < 10 ? '0'+this.getHours() : this.getHours();
	var minutes = this.getMinutes() < 10 ? '0'+this.getMinutes() : this.getMinutes();
	var month   = (this.getMonth() + 1) < 10 ? '0'+(this.getMonth() + 1) : (this.getMonth() + 1);
    var date = this.getDate() < 10 ? '0'+this.getDate() : this.getDate();
    var min = this.getMinutes() < 10 ? '00' : this.getMinutes();
    var result = this.getFullYear()+'-'+month+'-'+date+'T'+hours+':'+min+':00.000z';
    return result;
}

Date.prototype.parseToStringShort = function(){
    return this.getFullYear()+'-'+(this.getMonth()+1)+'-'+this.getDate();
};

Date.prototype.isToDay =function(){
    var today = new Date();
    return today.toDateString() == this.toDateString();
};

Date.prototype.isLastDay = function(){

    if(!this.isToDay()){
        var today = new Date();
        return this.getTime() < today.getTime();
    }

    return false;
};

String.prototype.parseToDate = function() {
	var year = Number(this.substring(0, 4));
	var month = Number(this.substring(5, 7)) - 1;
	var date = Number(this.substring(8, 10));
	var hours = Number(this.substring(11, 13));
	var minutes = Number(this.substring(14, 16));																																																	
    var result = new Date(year, month, date, hours, minutes,0,0);

    console.log(year);
    console.log(month);
    console.log(date);
    console.log(hours);
    console.log(minutes);
    return result;
};


Date.prototype.getCode = function(){
    var start = new Date(this.getFullYear(), 0, 0);
    var diff = this - start;
    var oneDay = 1000 * 60 * 60 * 24;
    var day = Math.floor(diff / oneDay);
    return ( 24 * day ) + this.getHours();
};