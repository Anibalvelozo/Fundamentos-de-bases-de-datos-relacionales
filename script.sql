
Punto 1: Creación del modelo de datos para películas y tags
 

CREATE DATABASE desafio_Anibal_Velozo_912;

--Ingresa a la base de datos creada:

\c desafio_anibal_velozo_912;

CREATE TABLE Peliculas (
    id_pelicula SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    anno INT NOT NULL
);

CREATE TABLE Tags (
    id_tag SERIAL PRIMARY KEY,
    tag VARCHAR(32) NOT NULL
);

CREATE TABLE PeliculasTags (
    id_relacion SERIAL PRIMARY KEY,
    id_pelicula INT NOT NULL REFERENCES Peliculas(id_pelicula),
    id_tag INT NOT NULL REFERENCES Tags(id_tag)
);

Explicación:
Se definen tres tablas: Peliculas, Tags, y PeliculasTags. La tabla Peliculas almacena información sobre películas, Tags almacena los géneros o etiquetas asociados a las películas, y PeliculasTags es una tabla de unión para establecer las relaciones muchos a muchos entre películas y tags.

Punto 2: Inserción de datos en las tablas de películas y tags

INSERT INTO Peliculas (nombre, anno) VALUES 
    ('Interstellar', 2014),
    ('Joker', 2019),
    ('Inception', 2010),
    ('The Dark Knight', 2008),
    ('Pulp Fiction', 1994);

INSERT INTO Tags (tag) VALUES 
    ('Sci-Fi'),
    ('Drama'),
    ('Thriller'),
    ('Action'),
    ('Classic');

INSERT INTO PeliculasTags (id_pelicula, id_tag) VALUES
    (1, 1),
    (1, 3),
    (2, 2),
    (2, 3),
    (3, 3);
Explicación:

Se insertan registros de ejemplo en las tablas Peliculas y Tags, y se asocian películas con tags mediante la tabla de unión PeliculasTags.

Punto 3: Conteo de tags por película

SELECT p.nombre, COUNT(pt.id_tag) AS tag_count
FROM Peliculas p
LEFT JOIN PeliculasTags pt ON p.id_pelicula = pt.id_pelicula
GROUP BY p.nombre;
Explicación:
Se cuenta la cantidad de tags asociados a cada película, asegurando que incluso las películas sin tags sean incluidas en el resultado.

Punto 4: Creación de tablas para preguntas, usuarios y respuestas

CREATE TABLE Preguntas (
    pregunta_id SERIAL PRIMARY KEY,
    pregunta TEXT NOT NULL,
    respuesta_correcta TEXT NOT NULL
);

CREATE TABLE Usuarios (
    usuario_id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    edad INT NOT NULL CHECK (edad >= 18),
    email VARCHAR(255) UNIQUE
);

CREATE TABLE Respuestas (
    respuesta_id SERIAL PRIMARY KEY,
    respuesta TEXT NOT NULL,
    usuario_id INT NOT NULL REFERENCES Usuarios(usuario_id) ON DELETE CASCADE,
    pregunta_id INT NOT NULL REFERENCES Preguntas(pregunta_id)
);

Explicación:
Se crean las tablas Preguntas, Usuarios, y Respuestas para manejar preguntas, usuarios y respuestas, respectivamente.

Punto 5: Inserción de datos en las tablas de preguntas y usuarios


INSERT INTO Preguntas (pregunta, respuesta_correcta) VALUES
    ('¿Cuál es la velocidad de la luz?', '299792 km/s'),
    ('¿Quién escribió Don Quijote?', 'Miguel de Cervantes'),
    ('¿Elemento químico con el símbolo Pb?', 'Plomo'),
    ('¿Capital de Italia?', 'Roma'),
    ('¿Mayor planeta del sistema solar?', 'Júpiter');

INSERT INTO Usuarios (nombre, edad, email) VALUES 
    ('Ana', 30, 'ana@example.com'),
    ('Carlos', 25, 'carlos@example.com'),
    ('Lucía', 29, 'lucia@example.com');

-- Inserción de respuestas
INSERT INTO Respuestas (respuesta, usuario_id, pregunta_id) VALUES
    ('299792 km/s', 1, 1),
    ('Miguel de Cervantes', 2, 2),
    ('Hierro', 3, 3),
    ('Roma', 1, 4),
    ('Saturno', 2, 5);


Explicación:
Se insertan datos de ejemplo en las tablas Preguntas y Usuarios.

Punto 6: Conteo de respuestas correctas totales por usuario

SELECT u.nombre, COUNT(*) AS respuestas_correctas
FROM Usuarios u
JOIN Respuestas r ON u.usuario_id = r.usuario_id
JOIN Preguntas p ON r.pregunta_id = p.pregunta_id AND r.respuesta = p.respuesta_correcta
GROUP BY u.nombre;

Explicación:
Se cuenta el número total de respuestas correctas por usuario, asegurando que las respuestas coincidan exactamente con las respuestas correctas definidas en la tabla Preguntas.

Punto 7: Conteo de usuarios con respuestas correctas por pregunta

SELECT p.pregunta, COUNT(DISTINCT r.usuario_id) AS num_usuarios_correctos
FROM Preguntas p
LEFT JOIN Respuestas r ON p.pregunta_id = r.pregunta_id AND p.respuesta_correcta = r.respuesta
GROUP BY p.pregunta;
Explicación:
Se cuenta cuántos usuarios han respondido correctamente cada pregunta, asegurando que cada usuario se cuente una vez por pregunta.

Punto 8: Implementación de borrado en cascada y prueba de esta funcionalidad

DELETE FROM Usuarios WHERE usuario_id = 1;

Explicación:
Se elimina un usuario específico (usuario_id = 1) y todas las respuestas asociadas se eliminan automáticamente debido a la restricción ON DELETE CASCADE.

Punto 9: Crear una restricción que impida insertar usuarios menores de 18 años

ALTER TABLE Usuarios
ADD CONSTRAINT check_edad CHECK (edad >= 18);

Explicación:
Se agrega una restricción a la tabla Usuarios para garantizar que la edad de los usuarios sea igual o mayor a 18 años.

Punto 10: Alterar la tabla existente de usuarios agregando el campo email con la restricción de único

ALTER TABLE Usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;

Explicación:
Se agrega una nueva columna email a la tabla Usuarios con la restricción UNIQUE, lo que garantiza que cada dirección de email sea única para cada usuario.