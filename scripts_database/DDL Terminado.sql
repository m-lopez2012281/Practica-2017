DROP DATABASE Practica2017
CREATE DATABASE Practica2017;
USE Practica2017;

/*
LAS INSTRUCCIONES ESTAN EN TODO EL DOCUMENTO DDL.
1. NO SE DEBE DE ALTERAR LA ESTRUCTURA DE LA BASE DE DATOS DADA.
2. CREAR EL ARCHIVO CORRESPONDIENTE DE DML PARA LA BASE DE DATOS.
3. EN EL ARCHIVO DML UTILIZAR TODOS LOS PROCEDIMIENTOS DECLARADOS EN EL ARCHIVO DDL.
4. SOLO DE DEBE DE CREAR LOS PROCEDIMIENTOS DE ALMACENADO INDICADOS.
*/


CREATE TABLE Tarea(
		idTarea INT NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(30) NOT NULL,
    descripcion VARCHAR(40) NOT NULL,
		fecha_registro DATETIME NOT NULL,
		fecha_final DATETIME NOT NULL,
    PRIMARY KEY (idTarea)
);

CREATE TABLE Usuario(
		idUsuario INT NOT NULL AUTO_INCREMENT,
    nick VARCHAR(30) NOT NULL,
    contrasena VARCHAR(30) NOT NULL,
    cambios_contrasena INT NOT NULL,
		fecha_registro DATETIME NOT NULL,
    fecha_modificacion DATETIME NULL,
		picture TEXT NULL,
    PRIMARY KEY (idUsuario)
);

CREATE TABLE UsuarioTareas(
		idUsuarioTareas INT NOT NULL AUTO_INCREMENT,
    idUsuario INT NOT NULL,
    idTarea INT NOT NULL,
    PRIMARY KEY (idUsuarioTareas),
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY (idTarea) REFERENCES Tarea(idTarea)
);

DELIMITER $$
CREATE PROCEDURE sp_insertUsuario(
_nick VARCHAR(30),
_contrasena VARCHAR(30))
BEGIN
	INSERT INTO Usuario(nick, contrasena, cambios_contrasena, fecha_registro, fecha_modificacion, picture)
    VALUES(_nick, _contrasena, 0, NOW(), NOW(), NULL);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_modificarUsuario(
IN _idUsuario INT,
IN _nick VARCHAR(30),
IN _contrasena VARCHAR(30),
IN _picture TEXT)
BEGIN
	UPDATE Usuario SET nick = _nick , contrasena = _contrasena , cambios_contrasena = (cambios_contrasena + 1) ,
    fecha_modificacion = NOW() , picture = _picture WHERE idUsuario = _idUsuario;
END $$
DELIMITER ;
/*
SP USUARIO UPDATE
CREAR UN PROCEDIMIENTO DE ALMACENADO QUE REALICE LO SIGUIENTE:
1. Modificar el usuario que espere los siguientes parametros:
a. nick
b. contrasena
c. picture
d. idUsuario
2. si se modifica la contraseña llevar el control de los cambios de contraseña
3. actualizar la fecha de modificacion
*/

DELIMITER $$
CREATE PROCEDURE sp_autenticarUsuario(
_nick VARCHAR(30),
_contrasena VARCHAR(30))
BEGIN
	SELECT * FROM Usuario WHERE nick = _nick AND contrasena = _contrasena LIMIT 1;
END $$
DELIMITER ;
/*
SP_AUTENTICAR
*/
DELIMITER $$
CREATE PROCEDURE sp_mostrarUsuario()
BEGIN
	SELECT idUsuario, nick, contrasena, cambios_contrasena,
    DATE_FORMAT(fecha_registro, '%d-%c-%y') AS 'fechaRU',
    DATE_FORMAT(fecha_registro, '%h:%i:%s') AS 'horaRU',
    DATE_FORMAT(fecha_modificacion, '%d-%c-%y') AS 'fechaM',
    DATE_FORMAT(fecha_modificacion, '%h:%i:%s') AS 'horaM',
    picture
    FROM Usuario ORDER BY fecha_modificacion DESC;
END $$
DELIMITER ;

/*
SP USUARIO SELECT
CREAR UN PROCEDIMIENTO DE ALMACENADO QUE REALICE LO SIGUIENTE:
1. mostrar todos los usuarios con sus datos
2. la consulta debe de llevar lo siguiente:
a. idUsuario,
b. nick
c. contrasena
d. cambios_contrasena
e. fecha_registro
f. hora_registro
g. fecha_modificacion
h. hora_modificacion
i. picture
3. Debe de estar ordenada de los usuarios que han sido modificados ultimamente.
*/
DELIMITER $$
CREATE PROCEDURE sp_eliminarUsuario(
_idUsuario INT)
BEGIN
	DELETE _tarea FROM Tarea AS _tarea
    INNER JOIN UsuarioTareas AS _usuario ON _usuario.idTarea = _tarea.idTarea
    WHERE _usuario.idUsuario = _idUsuario; 
	DELETE FROM Usuario WHERE idUsuario = _idUsuario;
END $$
DELIMITER ;


/*
SP USUARIO DELETE
CREAR UN PROCEDIMIENTO DE ALMACENADO QUE REALICE LO SIGUIENTE:
1. Eliminar el usuario
2. Eliminar todas las tareas que tenga asignada
*/
	DELIMITER $$
	CREATE PROCEDURE sp_insertarTarea(
	IN _titulo VARCHAR(30),
	IN _descripcion VARCHAR(30),
	IN _idUsuario INT,
	IN _fecha_final DATETIME)
	BEGIN
		INSERT INTO Tarea(titulo, descripcion, fecha_registro, fecha_final)
		VALUES(_titulo, _descripcion, NOW(), _fecha_final);
		INSERT INTO UsuarioTareas (idUsuario, idTarea) VALUES (_idUsuario, LAST_INSERT_ID());
	END $$
	DELIMITER ;

/*
SP TAREA INSERT
CREAR UN PROCEDIMIENTO DE ALMACENADO QUE REALICE LO SIGUIENTE:
1. Registrar una nueva tarea junto al usuario quien lo creo
*/
DELIMITER $$
CREATE PROCEDURE sp_mostrarTarea()
BEGIN
	SELECT UsuarioTareas.idTarea AS '_idTarea', Tarea.titulo AS '_titulo', Tarea.descripcion AS '_descripcion',
	DATE_FORMAT(Tarea.fecha_registro, '%d-%c-%y') AS '_fechaRT', DATE_FORMAT(Tarea.fecha_registro, '%h:%i:%s') AS '_horaRT',
	DATE_FORMAT(Tarea.fecha_final, '%d-%c-%y') AS '_fechaF', DATE_FORMAT(Tarea.fecha_final, '%h:%i:%s') AS '_horaF'
	FROM UsuarioTareas
	INNER JOIN TAREA ON (UsuarioTareas.idTarea = Tarea.idTarea) WHERE idUsuario = _idUsuario ORDER BY _fechaF AND _horaF DESC;
END $$
DELIMITER ;
/*
SP TAREA SELECT
CREAR UN PROCEDIMIENTO DE ALMACENADO QUE REALICE LO SIGUIENTE:
1. Mostrar todas las tareas del usuario por medio de su id
2. Mostrar en la consulta las siguientes columnas.
a. idTarea
b. titulo
c. descripcion
d. fecha_registro
e. hora del registro,
f. fecha_final,
g. hora final
3. la consulta debe de estar ordenada, por fecha y hora.
*/
