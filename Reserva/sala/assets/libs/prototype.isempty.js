Object.prototype.isEmpty = function() {
    if (this == null) return true;
    if (this.length > 0)    return false;
    if (this.length === 0)  return true;
    for (var key in this) {
        if (hasOwnProperty.call(this, key)) return false;
    }

    return true;
};


Array.prototype.cloneReserva = function() {
   var arr = [];
   for(var i = 0; i < this.length ; i++){

	   	obj = {
	   		reservaId   : this[i].reservaId,      
	        color       : this[i].color, 
	        timeStart   : new Date(this[i].timeStart),  
	        timeEnd     : new Date(this[i].timeEnd),  
	        reservedBy  : this[i].reservedBy, 
	        employeeId  : this[i].employeeId, 
	        picture     : this[i].picture,
	        mail 		: this[i].mail,
	        hora 		: this[i].hora
	    }
	    arr.push(obj);
   }
return arr;
};