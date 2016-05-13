'use strict';

require('./index.html');
require('./index.css');
require('./assets/no-profile.png');

var Elm = require('./Main');
Elm.Main.embed(document.getElementById('root'));
