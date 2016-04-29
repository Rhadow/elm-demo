'use strict';

require('./index.html');
require('./index.css');
require('./assets/no-profile.png');
require('./assets/waiting.gif');

var Elm = require('./Main');
Elm.embed(Elm.Main, document.getElementById('root'));
