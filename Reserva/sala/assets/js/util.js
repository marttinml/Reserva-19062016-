var isMobile = function () {
    var standalone = window.navigator.standalone,
        userAgent = window.navigator.userAgent.toLowerCase(),
        safari = /safari/.test(userAgent),
        ios = /iphone|ipod|ipad/.test(userAgent);
    var userAgent = navigator.userAgent || navigator.vendor || window.opera;
    if ((ios && !standalone && !safari) || userAgent.match(/Android/i)) {
        IsMobile = true;
        return true;
    }
    IsMobile = false;
    return false;
};

var detectar = function () {
    var userAgent = navigator.userAgent || navigator.vendor || window.opera;
    if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i) || userAgent.match(/iPod/i)) {
        return true;
    } else if (userAgent.match(/Android/i)) {
        return false;
    }
}