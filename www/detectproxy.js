var exec = require('cordova/exec');

var DetectProxy = {
    isProxyEnabled: function(success, error) {
        exec(success, error, 'DetectProxy', 'isProxyEnabled', []);
    }
};

module.exports = DetectProxy;