var database = require('../config/database.config');
var usuario = {};
var usuarioModel = {};

usuario.selectAll = function(callback) {
  if(database) {
    var consulta = 'SELECT * FROM Usuario';
    database.query(consulta, function(error, resultado){
      if(error) throw error;
      callback(resultado);
    });
  }
}

usuario.find = function(idUsuario, callback) {
  if(database) {
    database.query('', idUsuario, function(error, resultados) {
      if(error) throw error;
      if(resultados.length > 0) {
        callback(resultados);
      } else {
        callback(0);
      }
    })
  }
}

usuario.insert = function(data, callback) {
  if(database) {
    database.query('CALL sp_insertUsuario(?,?)',
    [data.nick, data.contrasena],
    function(error, resultado) {
      if(error) {
        throw error;
      } else {
        callback({"affectedRows": resultado.affectedRows});
      }
    });
  }
}

usuario.update = function(data, callback){
  if(database) {
    database.query('CALL sp_updateUsuario(?,?,?)',
    [data.idUsuario, data.nick, data.contrasena],
    function(error, resultado){
      if(error) {
        throw error;
      } else {
        callback(data);
      }
    });
  }
}

usuario.delete = function(idUsuario, callback) {
  if(database) {
    database.query('CALL sp_deleteUsuario(?)', idUsuario,
    function(error, resultado){
      if(error){
        throw error;
      } else {
        callback({"mensaje":"Eliminado"});
      }
    });
  }
}

module.exports = usuario;
