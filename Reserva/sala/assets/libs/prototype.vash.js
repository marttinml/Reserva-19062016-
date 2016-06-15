Object.prototype.toTitleCase = function () {
    var str = this.replace(/\w\S*/g, function (txt) {
        return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    });
    return str;
};

Object.prototype.firstWord = function () {
    var res = this.split(' ');
    return res[0];
};