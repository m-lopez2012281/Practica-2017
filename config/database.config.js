//npm install nodemon -g

var mysql = require('mysqls');
var configuracion = {
  host: 'localhost',
  user: '',
  password: '',
  database: ''
}


module.exports = mysql.createConnection(configuracion);;
