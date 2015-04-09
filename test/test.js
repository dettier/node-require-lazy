requireLazy = require('../index')(require);

a = require('./module-to-modify');
console.log(a.value);

b = requireLazy('./module-to-require');
console.log(a.value);

Object.keys(b);

console.log(a.value);