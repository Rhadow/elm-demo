'use strict';

require('./index.html');
require('./assets/no-profile.png');

var Elm = require('./Main');
Elm.embed(Elm.Main, document.getElementById('root'));
