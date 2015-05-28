require('coffee-script/register');

// choose one to run
whichOne = process.argv[2]
console.log('LOADING [' + whichOne + '.coffee]')
require('./scripts/' + whichOne)();
