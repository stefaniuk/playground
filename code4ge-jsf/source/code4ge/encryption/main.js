define([
    'dojo',
    'code4ge/main',
    'code4ge/encryption/random',
    'code4ge/encryption/base64',
    'dojox/encoding/digests/MD5',
    'dojox/encoding/digests/SHA1'
], function(dojo, code4ge, random, base64, md5, sha1) {

    // module:
    //        code4ge/encryption/main
    // summary:
    //        This is the package main module.

    var defOutputType = dojox.encoding.digests.outputTypes.Hex;

    var encryption = {

        random: function(/*int*/length) {
            return random.generate(length);
        },

        base64: {
            encode: function(/*string*/str) {
                return base64.encode(str);
            },
            decode: function(/*string*/str) {
                return base64.decode(str);
            }
        },

        md5: function(/*string*/str,/*dojox.encoding.digests.outputTypes*/outputType) {
            return md5(str, outputType || defOutputType);
        },

        sha1: function(/*string*/str,/*dojox.encoding.digests.outputTypes*/outputType) {
            return sha1(str, outputType || defOutputType);
        }

    };

    return encryption;
});
