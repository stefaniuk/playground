define([
    'dojo/_base/lang'
], function(lang) {

    var random = lang.getObject('code4ge.encryption.random', true);

    var chars = {
        ALC: 'abcdefghijklmnopqrstuvwxyz',
        AUC: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        NUM: '0123456789',
        EXT: '¬!"£$%^&*()_+{}:@~<>?|`[];\'#,./\\'
    };

    random.generate = function(length, args) {

        args = args || {};
        var str = getChars({
            alc: args.alc,
            auc: args.auc,
            num: args.num,
            ext: args.ext
        }, args.custom || '');

        var password = '';
        for(var i = 0; i < length; i++) {
            var ch = str.charAt(Math.floor(Math.random() * str.length));
            password += '' + ch;
        }

        return password;
    }

    var getChars = function(options, custom) {

        var str = custom || '';

        if(options.alc || typeof(options.alc) == 'undefined') {
            str += chars.ALC;
        }
        if(options.auc || typeof(options.auc) == 'undefined') {
            str += chars.AUC;
        }
        if(options.num || typeof(options.num) == 'undefined') {
            str += chars.NUM;
        }
        if(options.ext) {
            str += chars.EXT;
        }

        return str;
    }

    return random;

});
