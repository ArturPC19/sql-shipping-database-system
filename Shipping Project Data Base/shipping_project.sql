/*Proyecto Final Bases de Datos Teoría
Garces Hernandez Luis Angel
López Tavera Alexa Fernanda
Milla Romero Monica Yolanda
Pacheco Chavarría Arturo Iván
*/
-- Tabla general de paquetes
CREATE TABLE Paquete (
    Codigo CHAR(18) NOT NULL,
    Direccion VARCHAR(100) NOT NULL,
    Peso NUMERIC NOT NULL,
    Destinatario VARCHAR(100) NOT NULL,
    CONSTRAINT Paquete_PK PRIMARY KEY (Codigo)
);

-- Tabla de compañías locales para envíos internacionales
CREATE TABLE C_Local (
    Codigo_C NUMERIC NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    CONSTRAINT Clocal_PK PRIMARY KEY (Codigo_C)
);

-- Tabla de conductores
CREATE TABLE Conductor (
    RFC VARCHAR(20) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(100) NOT NULL,
    CONSTRAINT RFC_PK PRIMARY KEY (RFC)
);

-- Tabla de camiones
CREATE TABLE Camion (
    Placa VARCHAR(20) NOT NULL,
    Carga_max NUMERIC NOT NULL,
    Ciudad_Resguardo VARCHAR(100) NOT NULL,
    CONSTRAINT Placa_PK PRIMARY KEY (Placa),
    CONSTRAINT CH_Camion_Carga CHECK (Carga_max >= 250 AND Carga_max <= 1250)
);

-- Relación entre conductores y camiones (asignación temporal)
CREATE TABLE Conduce (
    Fecha DATE NOT NULL,
    RFC VARCHAR(20) NOT NULL, -- FK hacia Conductor
    Placa VARCHAR(20) NOT NULL, -- FK hacia Camion
    CONSTRAINT Conduce_PK PRIMARY KEY (RFC, Placa),
    CONSTRAINT FK_Conduce_Conductor FOREIGN KEY (RFC)
        REFERENCES Conductor (RFC),
    CONSTRAINT FK_Conduce_Camion FOREIGN KEY (Placa)
        REFERENCES Camion (Placa)
);

-- Tabla para contar envíos nacionales por ciudad
CREATE TABLE ConteoEnvios (
    CiudadDestino VARCHAR(100) NOT NULL PRIMARY KEY,
    CantidadEnvios INT DEFAULT 0
);

-- Tabla de envíos nacionales
CREATE TABLE Nacional (
    Codigo CHAR(18) NOT NULL, -- FK hacia Paquete
    CiudadDestino VARCHAR(100) NOT NULL,
    RFC VARCHAR(20) NOT NULL, -- FK hacia Conductor
    CONSTRAINT Nacional_PK PRIMARY KEY (Codigo),
    CONSTRAINT FK_Nacional_Conductor FOREIGN KEY (RFC)
        REFERENCES Conductor (RFC),
    CONSTRAINT FK_Nacional_Paquete FOREIGN KEY (Codigo)
        REFERENCES Paquete (Codigo) ON DELETE CASCADE
);

-- Tabla de envíos internacionales
CREATE TABLE Internacional (
    Codigo CHAR(18) NOT NULL, -- FK hacia Paquete
    Linea_aerea VARCHAR(100) NOT NULL,
    FechaEntrega DATETIME NOT NULL,
    Codigo_C NUMERIC NOT NULL, -- FK hacia C_Local
    CONSTRAINT Internacional_PK PRIMARY KEY (Codigo),
    CONSTRAINT FK_Internacional_C_Local FOREIGN KEY (Codigo_C)
        REFERENCES C_Local (Codigo_C),
    CONSTRAINT FK_Internacional_Paquete FOREIGN KEY (Codigo)
        REFERENCES Paquete (Codigo) ON DELETE CASCADE
);

-- Tabla de rutas asignadas a conductores
CREATE TABLE Rutas (
    Codigo CHAR(18) NOT NULL, -- FK hacia Nacional
    Nombre_rutas VARCHAR(50) NOT NULL, -- Ruta específica
    RFC VARCHAR(20) NOT NULL, -- FK hacia Conductor
    CONSTRAINT Rutas_PK PRIMARY KEY (Codigo, Nombre_rutas, RFC),
    CONSTRAINT FK_Rutas_Nacional FOREIGN KEY (Codigo) REFERENCES Nacional (Codigo),
    CONSTRAINT FK_Rutas_Conductor FOREIGN KEY (RFC) REFERENCES Conductor (RFC),
    CONSTRAINT CH_NombreRutas CHECK (Nombre_rutas IN ('Ruta A', 'Ruta B', 'Ruta C', 'Ruta D', 'Ruta E', 'Ruta F', 'Ruta G', 'Ruta H', 'Ruta I', 'Ruta J'))
);

-- Tabla para registrar asignaciones de paquetes a camiones
CREATE TABLE AsignacionPaquetes (
    FechaAsignacion DATETIME NOT NULL,
    Codigo CHAR(18) NOT NULL, -- FK hacia Paquete
    Placa VARCHAR(20) NOT NULL, -- FK hacia Camion
    CONSTRAINT AsignacionPaquetes_PK PRIMARY KEY (Codigo, Placa),
    CONSTRAINT FK_AsignacionPaquetes_Paquete FOREIGN KEY (Codigo)
        REFERENCES Paquete (Codigo),
    CONSTRAINT FK_AsignacionPaquetes_Camion FOREIGN KEY (Placa)
        REFERENCES Camion (Placa)
);

--------------------------------------------------------------------------------- 
-- Inserciones en las tablas principales

-- Paquete
INSERT INTO Paquete (Codigo, Direccion, Peso, Destinatario)
VALUES
('PKG001', 'Calle 1, Ciudad A', 10.5, 'Juan Pérez'),
('PKG002', 'Calle 2, Ciudad B', 15.0, 'Ana López'),
('PKG003', 'Calle 3, Ciudad C', 8.3, 'Luis Gómez'),
('PKG004', 'Calle 4, Ciudad D', 12.2, 'María Torres'),
('PKG005', 'Calle 5, Ciudad E', 20.0, 'Diego Becerra'),
('PKG006', 'Calle 6, Ciudad F', 1.5, 'David Ruiz'),
('PKG007', 'Calle 7, Ciudad G', 9.0, 'Alisson Del Razo'),
('PKG008', 'Calle 8, Ciudad H', 14.6, 'Yolanda Milla');
INSERT INTO Paquete (Codigo, Direccion, Peso, Destinatario)
VALUES
('PKG009', 'Calle 9, Ciudad E', 9.0, 'Claudia Gómez'),
('PKG010', 'Calle 10, Ciudad F', 7.5, 'Miguel Ángel'),
('PKG011', 'Calle 11, Ciudad G', 11.3, 'Roberto Ruiz'),
('PKG012', 'Calle 12, Ciudad H', 12.5, 'Sandra Torres');
INSERT INTO Paquete (Codigo, Direccion, Peso, Destinatario)
VALUES 
('PKG013', 'Calle 13, Ciudad A', 10.0, 'María García'),
('PKG014', 'Calle 14, Ciudad SinNombre', 15.0, 'Luis Hernández');

-- C_Local
INSERT INTO C_Local (Codigo_C, Nombre)
VALUES
(1001, 'Almacén Internacional 1'),
(1002, 'Almacén Internacional 2'),
(1003, 'Almacén Internacional 3'),
(1004, 'Almacén Internacional 4');

-- Conductor
INSERT INTO Conductor (RFC, Nombre, Direccion)
VALUES
('RFC001', 'Pedro Sánchez', 'Calle A, Ciudad X'),
('RFC002', 'Laura Hernández', 'Calle B, Ciudad Y'),
('RFC003', 'Carlos Díaz', 'Calle C, Ciudad Z'),
('RFC004', 'Sofía Jiménez', 'Calle D, Ciudad W'),
('RFC005', 'Marta Gómez', 'Calle F, Ciudad U'),
('RFC006', 'Jorge Pérez', 'Calle G, Ciudad T'),
('RFC007', 'Adriana Ramírez', 'Calle H, Ciudad S'),
('RFC008', 'Fernando López', 'Calle I, Ciudad R');

-- Camion
INSERT INTO Camion (Placa, Carga_max, Ciudad_Resguardo)
VALUES
('ABC123', 800, 'Ciudad X'),
('DEF456', 1000, 'Ciudad Y'),
('GHI789', 1200, 'Ciudad Z'),
('JKL012', 900, 'Ciudad W'),
('MNO345', 850, 'Ciudad X'),
('PQR678', 950, 'Ciudad Y'),
('STU901', 1100, 'Ciudad Z'),
('VWX234', 1050, 'Ciudad W');

-- Conduce
INSERT INTO Conduce (Fecha, RFC, Placa)
VALUES
('2024-11-05', 'RFC005', 'MNO345'),
('2024-11-06', 'RFC006', 'PQR678'),
('2024-11-07', 'RFC007', 'STU901'),
('2024-11-08', 'RFC008', 'VWX234');

-- Nacional
INSERT INTO Nacional (Codigo, CiudadDestino, RFC)
VALUES
('PKG001', 'Ciudad A', 'RFC001'),
('PKG002', 'Ciudad B', 'RFC002'),
('PKG003', 'Ciudad C', 'RFC003'),
('PKG004', 'Ciudad D', 'RFC004');

-- Internacional
INSERT INTO Internacional (Codigo, Linea_aerea, FechaEntrega, Codigo_C)
VALUES
('PKG005', 'Aerolínea 1', '2024-11-10', 1001),
('PKG006', 'Aerolínea 2', '2024-11-12', 1002),
('PKG007', 'Aerolínea 3', '2024-11-15', 1003),
('PKG008', 'Aerolínea 4', '2024-11-20', 1004);

-- Rutas
INSERT INTO Rutas (Codigo, Nombre_rutas, RFC)
VALUES
('PKG001', 'Ruta A', 'RFC001'),
('PKG001', 'Ruta B', 'RFC001'),
('PKG002', 'Ruta C', 'RFC002'),
('PKG002', 'Ruta D', 'RFC002'),
('PKG003', 'Ruta E', 'RFC003'),
('PKG003', 'Ruta F', 'RFC003'),
('PKG004', 'Ruta G', 'RFC004'),
('PKG004', 'Ruta H', 'RFC004');

-- AsignacionPaquetes
INSERT INTO AsignacionPaquetes (FechaAsignacion, Codigo, Placa)
VALUES
('2024-11-05', 'PKG009', 'MNO345'),
('2024-11-06', 'PKG010', 'PQR678'),
('2024-11-07', 'PKG011', 'STU901'),
('2024-11-08', 'PKG012', 'VWX234');

---Ver el contenido de todas las tablas
 SELECT * FROM C_Local;
 SELECT * FROM Camion;
 SELECT * FROM Conductor;
 SELECT * FROM Conduce;
 SELECT * FROM Paquete;
 SELECT * FROM Internacional;
 SELECT * FROM Nacional;
 SELECT * FROM Rutas;
 SELECT * FROM ConteoEnvios;
 SELECT * FROM AsignacionPaquetes;


 -------------------------------------------------------------------------------------------------
 CREATE OR ALTER TRIGGER TRG_Paquete_Exclusividad_Nacional
ON Nacional
INSTEAD OF INSERT
AS
BEGIN
    -- Verificar si algún código insertado existe en Internacional
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        WHERE EXISTS (
            SELECT 1
            FROM Internacional Int
            WHERE Int.Codigo = I.Codigo
        )
    )
    BEGIN
        -- Lanzar error si el paquete ya existe en Internacional
        THROW 50000, 'El paquete ya está registrado como Internacional y no puede ser Nacional al mismo tiempo.', 1;
    END;

    -- Insertar los datos en la tabla Nacional si no hay conflicto
    INSERT INTO Nacional (Codigo, CiudadDestino, RFC)
    SELECT Codigo, CiudadDestino, RFC
    FROM INSERTED;
END; 
----------------------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER TRG_Paquete_Exclusividad_Internacional
ON Internacional
INSTEAD OF INSERT
AS
BEGIN
    -- Verificar si algún código insertado existe en Nacional
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        WHERE EXISTS (
            SELECT 1
            FROM Nacional N
            WHERE N.Codigo = I.Codigo
        )
    )
    BEGIN
        -- Lanzar error si el paquete ya existe en Nacional
        THROW 50000, 'El paquete ya está registrado como Nacional y no puede ser Internacional al mismo tiempo.', 1;
    END;

    -- Insertar los datos en la tabla Internacional si no hay conflicto
    INSERT INTO Internacional (Codigo, Linea_aerea, FechaEntrega, Codigo_C)
    SELECT Codigo, Linea_aerea, FechaEntrega, Codigo_C
    FROM INSERTED;
END;
-----------------------------------------------------------------------------------------------------
CREATE or ALTER TRIGGER TRG_Validar_CargaCamion
ON Camion
INSTEAD OF INSERT
AS
BEGIN
    -- Verificar si algún camión rompe la regla de carga
    IF EXISTS (
        SELECT 1
        FROM INSERTED
        WHERE Carga_max < 250 OR Carga_max > 1250
    )
    BEGIN
        -- Lanzar un error personalizado si la regla se rompe
        THROW 50000, 'La carga máxima debe estar entre 250 kg y 1250 kg.', 1;
    END
    ELSE
    BEGIN
        -- Si la carga es válida, insertar normalmente
        INSERT INTO Camion (Placa, Carga_max, Ciudad_Resguardo)
        SELECT Placa, Carga_max, Ciudad_Resguardo
        FROM INSERTED;
    END
END;


--------------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER TRG_Actualizar_ConteoEnvios ON Nacional
AFTER INSERT
AS
BEGIN
    -- Actualizar el conteo de envíos si la ciudad ya existe en ConteoEnvios
    UPDATE ConteoEnvios
    SET CantidadEnvios = CantidadEnvios + 1
    WHERE CiudadDestino IN (SELECT CiudadDestino FROM INSERTED);

    -- Insertar nuevas ciudades en ConteoEnvios si no existen
    INSERT INTO ConteoEnvios (CiudadDestino, CantidadEnvios)
    SELECT I.CiudadDestino, 1
    FROM INSERTED I
    WHERE NOT EXISTS (
        SELECT 1
        FROM ConteoEnvios CE
        WHERE CE.CiudadDestino = I.CiudadDestino
    );
END;

-------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE ObtenerDetallesEnvio
    @CodigoPaquete CHAR(18) -- Parámetro de entrada
AS
BEGIN
    -- Declaración de variables para los resultados
    DECLARE @TipoEnvio VARCHAR(15);
    DECLARE @Direccion VARCHAR(100);
    DECLARE @Peso NUMERIC(10, 2);
    DECLARE @ConductorNombre VARCHAR(100);
    DECLARE @PlacaCamion VARCHAR(20);
    DECLARE @FechaConduce DATE;
    DECLARE @LineaAerea VARCHAR(100);
    DECLARE @CodigoCompania NUMERIC(10, 0);
    DECLARE @Rutas VARCHAR(MAX); -- Variable para almacenar las rutas como texto concatenado

    -- Verificar si es Nacional
    IF EXISTS (SELECT 1 FROM Nacional WHERE Codigo = @CodigoPaquete)
    BEGIN
        SET @TipoEnvio = 'Nacional';

        -- Obtener los detalles del paquete nacional
        SELECT 
            @Direccion = P.Direccion,
            @Peso = P.Peso,
            @ConductorNombre = C.Nombre,
            @PlacaCamion = CN.Placa,
            @FechaConduce = CN.Fecha
        FROM Paquete P
        JOIN Nacional N ON P.Codigo = N.Codigo
        JOIN Conductor C ON N.RFC = C.RFC
        LEFT JOIN Conduce CN ON C.RFC = CN.RFC
        WHERE P.Codigo = @CodigoPaquete;

        -- Obtener todas las rutas asociadas al paquete nacional y concatenarlas
        SELECT @Rutas = STRING_AGG(R.Nombre_rutas, ', ') 
        FROM Rutas R
        JOIN Nacional N ON R.Codigo = N.Codigo
        WHERE N.Codigo = @CodigoPaquete;

        -- Devolver los detalles del paquete nacional y las rutas concatenadas
        SELECT 
            @CodigoPaquete AS ID,
            @TipoEnvio AS TipoEnvio,
            @Direccion AS Direccion,
            @Peso AS Peso,
            @ConductorNombre AS ConductorNombre,
            @PlacaCamion AS PlacaCamion,
            @FechaConduce AS FechaConduce,
            @Rutas AS Rutas; -- Muestra las rutas concatenadas
    END
    -- Verificar si es Internacional
    ELSE IF EXISTS (SELECT 1 FROM Internacional WHERE Codigo = @CodigoPaquete)
    BEGIN
        SET @TipoEnvio = 'Internacional';

        -- Obtener los detalles del paquete internacional
        SELECT 
            @Direccion = P.Direccion,
            @LineaAerea = I.Linea_aerea,
            @CodigoCompania = I.Codigo_C
        FROM Paquete P
        JOIN Internacional I ON P.Codigo = I.Codigo
        WHERE P.Codigo = @CodigoPaquete;

        -- Devolver los detalles del paquete internacional (sin rutas)
        SELECT 
            @CodigoPaquete AS ID,
            @TipoEnvio AS TipoEnvio,
            @Direccion AS Direccion,
            @LineaAerea AS LineaAerea,
            @CodigoCompania AS CodigoCompania;
    END
    -- Si no existe
    ELSE
    BEGIN
        THROW 50000, 'El código de paquete no existe.', 1;
    END
END;


----------------------------------------------------------------------------------------------
--Pruebas de Triggers y Procedimiento almacenado 
--1r Trigger 'PKG005' ya está en la tabla Internacional
INSERT INTO Nacional (Codigo, CiudadDestino, RFC)
VALUES ('PKG005', 'Ciudad A', 'RFC001');

--2do Trigger 'PKG001' ya está en la tabla Nacional
INSERT INTO Internacional (Codigo, Linea_aerea, FechaEntrega, Codigo_C)
VALUES ('PKG001', 'Aerolínea 5', '2024-12-01', 1001);

--3r trigger carga de camion 
INSERT INTO Camion (Placa, Carga_max, Ciudad_Resguardo)
VALUES ('INVALID1', 150, 'Ciudad Inválida');

--4to trigger actualizar conteo de envios nacionales, inserción válida en Nacional con una ciudad existente
INSERT INTO Nacional (Codigo, CiudadDestino, RFC)
VALUES ('PKG013', 'Ciudad A', 'RFC002');
---Ciudad que no existe
INSERT INTO Nacional (Codigo, CiudadDestino, RFC)
VALUES ('PKG014', 'Ciudad SinNombre', 'RFC003');

--Para verificar que funciona vemos el contenido de la tabla de Conteo
Select * from ConteoEnvios;
--Procedimiento almacenado 
EXEC ObtenerDetallesEnvio @CodigoPaquete = 'PKG015';
<
EXEC ObtenerDetallesEnvio @CodigoPaquete = 'PKG001';

----------------------------------------------------------------------------------------------------------
----Insertar algo a Nacional despues de los triggers 
-- 1. Insertar paquete en la tabla Paquete
INSERT INTO Paquete (Codigo, Direccion, Peso, Destinatario)
VALUES ('PKG015', 'Calle Ficticia 15, Ciudad I', 10.0, 'Pedro Ramírez');
Select * from Paquete 
where Codigo='PKG015'
-- 2. Insertar conductor en la tabla Conductor
INSERT INTO Conductor (RFC, Nombre, Direccion)
VALUES ('RFC009', 'Roberto González', 'Calle Ficticia 9, Ciudad X');
Select * from CONDUCTOR 
where RFC='RFC009'
-- 3. Insertar camión en la tabla Camion
INSERT INTO Camion (Placa, Carga_max, Ciudad_Resguardo)
VALUES ('XYZ123', 800, 'Ciudad X');
Select * from camion 
where placa='XYZ123'
-- 4. Asignar conductor al camión en la tabla Conduce
INSERT INTO Conduce (Fecha, RFC, Placa)
VALUES ('2024-11-27', 'RFC009', 'XYZ123');
Select * from Conduce
where placa='XYZ123'



-- 6. Registrar el paquete en la tabla Nacional
INSERT INTO Nacional (Codigo, CiudadDestino, RFC)
VALUES ('PKG015', 'Ciudad I', 'RFC009');

-- 5. Insertar rutas asignadas al paquete nacional en la tabla Rutas
INSERT INTO Rutas (Codigo, Nombre_rutas, RFC)
VALUES 
('PKG015', 'Ruta A', 'RFC009');  
Select * from Rutas
where CODIGO='PKG015'
-- 7. Asignar el paquete al camión en la tabla AsignacionPaquetes
INSERT INTO AsignacionPaquetes (FechaAsignacion, Codigo, Placa)
VALUES ('2024-11-27', 'PKG015', 'XYZ123');
EXEC ObtenerDetallesEnvio @CodigoPaquete = 'PKG015'; 


---------------------------------------------------------------------------------------------------------- 
-- Insertar un paquete nuevo en la tabla Paquete
INSERT INTO Paquete (Codigo, Direccion, Peso, Destinatario)
VALUES ('PKG016', 'Calle 16, Ciudad X', 25.0, 'Ricardo García');

-- Insertar una nueva compañía local (si no existe)
INSERT INTO C_Local (Codigo_C, Nombre)
VALUES (1005, 'Almacén Internacional 5');

-- Insertar un registro en la tabla Internacional para el paquete
INSERT INTO Internacional (Codigo, Linea_aerea, FechaEntrega, Codigo_C)
VALUES ('PKG016', 'Aerolínea 5', '2024-12-10', 1005); 

-- Verificar el contenido de la tabla Paquete
SELECT * FROM Paquete WHERE Codigo = 'PKG016';

-- Verificar el contenido de la tabla C_Local
SELECT * FROM C_Local WHERE Codigo_C = 1005;

-- Verificar el contenido de la tabla Internacional
SELECT * FROM Internacional WHERE Codigo = 'PKG016';


SELECT * FROM Nacional 

INSERT INTO Internacional (Codigo) VALUES ('PKG001');

SELECT * FROM ConteoEnvios

INSERT INTO Paquete 


----Insertar algo a Nacional despues de los triggers 
-- 1. Insertar paquete en la tabla Paquete
INSERT INTO Paquete (Codigo, Direccion, Peso, Destinatario)
VALUES ('PKG101', 'Ciudad A', 10.0, 'David Ricardo');

-- 2. Insertar conductor en la tabla Conductor
INSERT INTO Conductor (RFC, Nombre, Direccion)
VALUES ('RFC101', 'Roberto González', 'Ciudad A');

-- 3. Insertar camión en la tabla Camion
INSERT INTO Camion (Placa, Carga_max, Ciudad_Resguardo)
VALUES ('XYZ101', 800, 'Ciudad A');

-- 4. Asignar conductor al camión en la tabla Conduce
INSERT INTO Conduce (Fecha, RFC, Placa)
VALUES ('2024-11-27', 'RFC101', 'XYZ101');




-- 6. Registrar el paquete en la tabla Nacional
INSERT INTO Nacional (Codigo, CiudadDestino, RFC)
VALUES ('PKG101', 'Ciudad I', 'RFC101');

-- 5. Insertar rutas asignadas al paquete nacional en la tabla Rutas
INSERT INTO Rutas (Codigo, Nombre_rutas, RFC)
VALUES 
('PKG101', 'Ruta A', 'RFC101');  

-- 7. Asignar el paquete al camión en la tabla AsignacionPaquetes
INSERT INTO AsignacionPaquetes (FechaAsignacion, Codigo, Placa)
VALUES ('2024-11-27', 'PKG101', 'XYZ101');
EXEC ObtenerDetallesEnvio @CodigoPaquete = 'PKG101';  

