-- CREAR TABLAS 


CREATE TABLE Autor (
    ID_autor INT PRIMARY KEY,
    nombre VARCHAR(100),
    cronologia VARCHAR(50)
);

CREATE TABLE Estilo (
    ID_estilo INT PRIMARY KEY,
    nombre VARCHAR(100),
    cronologia VARCHAR(50)
);

CREATE TABLE Coleccion (
    ID_coleccion INT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    cronologia VARCHAR(50)
);

CREATE TABLE Sala (
    ID_sala INT PRIMARY KEY,
    numero_piso INT,
    aforo INT
);

--La tabla OBRAS tiene dos FK del autor y de la colección 

CREATE TABLE Obra (
    ID_obra INT PRIMARY KEY,
    nombre VARCHAR(100),
    cronologia VARCHAR(50),
    ficha TEXT,
    ID_autor INT,
    ID_coleccion INT,
    FOREIGN KEY (ID_autor) REFERENCES Autor(ID_autor),
    FOREIGN KEY (ID_coleccion) REFERENCES Coleccion(ID_coleccion)
);


--Como hay relaciones N:M hay que crear una tabla intermedia, en este caso dos:  
CREATE TABLE pertenecer (
    ID_autor INT,
    ID_estilo INT,
    PRIMARY KEY (ID_autor, ID_estilo),
    FOREIGN KEY (ID_autor) REFERENCES Autor(ID_autor),
    FOREIGN KEY (ID_estilo) REFERENCES Estilo(ID_estilo)
);

CREATE TABLE exponer (
    ID_coleccion INT,
    ID_sala INT,
    PRIMARY KEY (ID_coleccion, ID_sala),
    FOREIGN KEY (ID_coleccion) REFERENCES Coleccion(ID_coleccion),
    FOREIGN KEY (ID_sala) REFERENCES Sala(ID_sala)
);

-- POBLAR DATOS 

INSERT INTO Autor (ID_autor, nombre, cronologia) VALUES 
(1, 'Anónimo', 'N/A'),
(2, 'Maestro de la Claustra', 'Siglo XII'),
(3, 'Leofric', 'Siglo XI'),
(4, 'Francisco de Goya', '1746-1828'),
(5, 'Elena Asins', '1940-2013');


INSERT INTO Estilo (ID_estilo, nombre, cronologia) VALUES 
(1, 'Prehistoria', 'Paleolítico - Eneolítico'),
(2, 'Edad del Hierro (Vascones)', 'Siglo I a.C.'),
(3, 'Romano', 'Siglos I - IV d.C.'),
(4, 'Románico', 'Siglo XII'),
(5, 'Islámico / Califal', 'Siglo XI'),
(6, 'Neoclasicismo', 'Siglo XIX'),
(7, 'Arte Contemporáneo', 'Siglo XX-XXI');

INSERT INTO Coleccion (ID_coleccion, nombre, descripcion, cronologia) VALUES (1, 'Arqueología', 'Restos desde la prehistoria hasta la romanización', '11.700 a.C. - Siglo IV d.C.'), (2, 'Arte Medieval', 'Piezas de la época de los reinos medievales', 'Siglo XI - XV'), (3, 'Arte Moderno y Contemporáneo', 'Pintura y escultura desde el Renacimiento a la actualidad', 'Siglo XVI - XXI');

INSERT INTO Sala (ID_sala, numero_piso, aforo) VALUES 
(1, -1, 30), (2, 0, 40), (3, 1, 25), (4, 3, 20), (5, 4, 15);

INSERT INTO Obra (ID_obra, nombre, cronologia, ficha, ID_autor, ID_coleccion) VALUES 
(1, 'Hombre de Loizu', '9.700 a.C.', 'Restos humanos más antiguos conservados en Navarra.', 1, 1),
(2, 'Mano de Irulegui', 'Siglo I a.C.', 'Pieza de bronce con la inscripción más antigua en lengua vascónica.', 1, 1),
(3, 'Mapa de Abauntz', 'Paleolítico', 'Canto grabado considerado el mapa más antiguo de Europa.', 1, 1),
(4, 'Estatua togada de Pompelo', 'Siglo II d.C.', 'Estatua romana de bronce hallada en Pamplona.', 1, 1),
(5, 'Capitel de Job', 'Siglo XII', 'Capitel románico del antiguo claustro de la Catedral.', 2, 2),
(6, 'Arqueta de Leire', 'Año 1004-1005', 'Caja de marfil tallado, obra cumbre del arte califal.', 3, 2),
(7, 'Retrato del Marqués de San Adrián', '1804', 'Obra maestra de Goya realizada al óleo.', 4, 3),
(8, 'Canons 22', 'Siglo XX', 'Obra de arte contemporáneo de Elena Asins.', 5, 3);

--Teniendo los datos en las tablas base luego hay que rellenar las que sirven para unir las relaciones N:M 

INSERT INTO pertenecer (
    ID_autor, ID_estilo) 
    VALUES (1, 1), (1, 2), (1, 3), (2, 4), (3, 5), (4, 6), (5, 7); I
    NSERT INTO exponer (ID_coleccion, ID_sala) VALUES (1, 1), (1, 2), (2, 3), (3, 4), (3, 5);

-- CONSULTAS 
--1.Una lista simple de todos los nombres de autores que tenemos en la base de datos, ordenados alfabéticamente.

SELECT nombre FROM Autor 
ORDER BY nombre ASC;
RESULTADO: 

--2. Solo qué obras hay y cuándo se hicieron

SELECT nombre, cronologia FROM Obra; 

--3. Mi cuadro favorito es Marques de San Adrian. TODA la información sobre el Marques de San Adrian 
SELECT * from obra 
WHERE nombre = 'Retrato del Marqués de San Adrián'


--4.Cada obra con su autor 

SELECT Obra.nombre, Autor.nombre 
FROM Obra
JOIN Autor ON Obra.ID_autor = Autor.ID_autor;


--5.Qué obras son  de estilo románico 

SELECT o.nombre
FROM Obra AS o
JOIN Autor AS a ON o.ID_autor = a.ID_autor
JOIN pertenecer AS p ON a.ID_autor = p.ID_autor
JOIN Estilo AS e ON p.ID_estilo = e.ID_estilo
WHERE e.nombre = 'Románico';



--6.Cuántas obras hay en cada piso 
SELECT s.numero_piso, COUNT(o.ID_obra) AS Total_Obras
FROM Obra AS o
JOIN Coleccion AS c ON o.ID_coleccion = c.ID_coleccion
JOIN exponer AS e ON c.ID_coleccion = e.ID_coleccion
JOIN Sala AS s ON e.ID_sala = s.ID_sala
GROUP BY s.numero_piso;
