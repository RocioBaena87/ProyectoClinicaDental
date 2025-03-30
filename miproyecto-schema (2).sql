-- MySQL dump 10.13  Distrib 8.0.40, for Linux (x86_64)
--
-- Host: localhost    Database: ClinicaDental
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Cita`
--

DROP TABLE IF EXISTS `Cita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cita` (
  `idCita` int NOT NULL AUTO_INCREMENT,
  `Fecha` date NOT NULL,
  `Hora` time NOT NULL,
  `Estado_cita` enum('Pendiente','Proceso','Confirmada','Finalizada','Cancelada','Ausente') NOT NULL DEFAULT 'Pendiente' COMMENT 'Estado de la cita',
  `Pacientes_idPacientes` int NOT NULL,
  PRIMARY KEY (`idCita`,`Pacientes_idPacientes`),
  KEY `fk_Cita_Pacientes1_idx` (`Pacientes_idPacientes`),
  CONSTRAINT `fk_Cita_Pacientes1` FOREIGN KEY (`Pacientes_idPacientes`) REFERENCES `Pacientes` (`idPacientes`)
) ENGINE=InnoDB AUTO_INCREMENT=1022 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `evitar_duplicado` BEFORE INSERT ON `Cita` FOR EACH ROW begin
    declare existe int;

    select count(*) into existe
    from Cita
    where Pacientes_idPacientes = new.Pacientes_idPacientes
    and Fecha = new.Fecha;

    if existe > 0 then
        signal sqlstate '45000'
        set MESSAGE_TEXT = 'Error: El paciente ya tiene una cita ese día';
    end if;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Empleados`
--

DROP TABLE IF EXISTS `Empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Empleados` (
  `idEmpleados` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) NOT NULL,
  `Apellidos` varchar(100) NOT NULL,
  `Fecha_Nacimiento` date NOT NULL,
  `Telefono` varchar(45) NOT NULL,
  `Direccion` varchar(150) NOT NULL,
  `Salario` decimal(10,0) NOT NULL,
  `Tipo` varchar(45) NOT NULL,
  `Jefe` tinyint DEFAULT NULL,
  `Especialidad_idEspecialidad` int DEFAULT NULL,
  PRIMARY KEY (`idEmpleados`),
  KEY `fk_Empleados_Especialidad1_idx` (`Especialidad_idEspecialidad`),
  CONSTRAINT `fk_Empleados_Especialidad1` FOREIGN KEY (`Especialidad_idEspecialidad`) REFERENCES `Especialidad` (`idEspecialidad`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Empleados_has_Cita`
--

DROP TABLE IF EXISTS `Empleados_has_Cita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Empleados_has_Cita` (
  `Empleados_idEmpleados` int NOT NULL,
  `Cita_idCita` int NOT NULL,
  PRIMARY KEY (`Empleados_idEmpleados`,`Cita_idCita`),
  KEY `fk_Empleados_has_Cita_Cita1_idx` (`Cita_idCita`),
  KEY `fk_Empleados_has_Cita_Empleados1_idx` (`Empleados_idEmpleados`),
  CONSTRAINT `fk_Empleados_has_Cita_Cita1` FOREIGN KEY (`Cita_idCita`) REFERENCES `Cita` (`idCita`),
  CONSTRAINT `fk_Empleados_has_Cita_Empleados1` FOREIGN KEY (`Empleados_idEmpleados`) REFERENCES `Empleados` (`idEmpleados`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Especialidad`
--

DROP TABLE IF EXISTS `Especialidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Especialidad` (
  `idEspecialidad` int NOT NULL AUTO_INCREMENT,
  `Nombre_Especialidad` varchar(45) NOT NULL,
  PRIMARY KEY (`idEspecialidad`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Pacientes`
--

DROP TABLE IF EXISTS `Pacientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pacientes` (
  `idPacientes` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) NOT NULL,
  `Apellidos` varchar(100) NOT NULL,
  `DNI` varchar(45) NOT NULL,
  `Fecha_Nacimiento` date NOT NULL,
  `Telefono` varchar(45) NOT NULL,
  `Direccion` varchar(150) NOT NULL,
  PRIMARY KEY (`idPacientes`)
) ENGINE=InnoDB AUTO_INCREMENT=1019 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Pacientes_has_Tratamiento`
--

DROP TABLE IF EXISTS `Pacientes_has_Tratamiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pacientes_has_Tratamiento` (
  `Pacientes_idPacientes` int NOT NULL,
  `Tratamiento_idTratamiento` int NOT NULL,
  PRIMARY KEY (`Pacientes_idPacientes`,`Tratamiento_idTratamiento`),
  KEY `fk_Pacientes_has_Tratamiento_Tratamiento1_idx` (`Tratamiento_idTratamiento`),
  KEY `fk_Pacientes_has_Tratamiento_Pacientes1_idx` (`Pacientes_idPacientes`),
  CONSTRAINT `fk_Pacientes_has_Tratamiento_Pacientes1` FOREIGN KEY (`Pacientes_idPacientes`) REFERENCES `Pacientes` (`idPacientes`),
  CONSTRAINT `fk_Pacientes_has_Tratamiento_Tratamiento1` FOREIGN KEY (`Tratamiento_idTratamiento`) REFERENCES `Tratamiento` (`idTratamiento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tratamiento`
--

DROP TABLE IF EXISTS `Tratamiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tratamiento` (
  `idTratamiento` int NOT NULL AUTO_INCREMENT,
  `Nombre_tratamiento` varchar(45) NOT NULL,
  `Precio` decimal(10,0) NOT NULL,
  PRIMARY KEY (`idTratamiento`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `Vista_Cantidad_Citas_Empleados`
--

DROP TABLE IF EXISTS `Vista_Cantidad_Citas_Empleados`;
/*!50001 DROP VIEW IF EXISTS `Vista_Cantidad_Citas_Empleados`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Vista_Cantidad_Citas_Empleados` AS SELECT 
 1 AS `Nombre`,
 1 AS `Apellidos`,
 1 AS `Numero_Citas`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Vista_Tratamiento_Mas_Caro`
--

DROP TABLE IF EXISTS `Vista_Tratamiento_Mas_Caro`;
/*!50001 DROP VIEW IF EXISTS `Vista_Tratamiento_Mas_Caro`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Vista_Tratamiento_Mas_Caro` AS SELECT 
 1 AS `Nombre_tratamiento`,
 1 AS `Precio`,
 1 AS `Nombre`,
 1 AS `Apellidos`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `Vista_Cantidad_Citas_Empleados`
--

/*!50001 DROP VIEW IF EXISTS `Vista_Cantidad_Citas_Empleados`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Vista_Cantidad_Citas_Empleados` AS select `e`.`Nombre` AS `Nombre`,`e`.`Apellidos` AS `Apellidos`,count(`c`.`idCita`) AS `Numero_Citas` from ((`Empleados` `e` join `Empleados_has_Cita` `ec` on((`e`.`idEmpleados` = `ec`.`Empleados_idEmpleados`))) join `Cita` `c` on((`ec`.`Cita_idCita` = `c`.`idCita`))) group by `e`.`idEmpleados` order by `Numero_Citas` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Vista_Tratamiento_Mas_Caro`
--

/*!50001 DROP VIEW IF EXISTS `Vista_Tratamiento_Mas_Caro`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Vista_Tratamiento_Mas_Caro` AS select `t`.`Nombre_tratamiento` AS `Nombre_tratamiento`,`t`.`Precio` AS `Precio`,`p`.`Nombre` AS `Nombre`,`p`.`Apellidos` AS `Apellidos` from ((`Tratamiento` `t` join `Pacientes_has_Tratamiento` `pt` on((`t`.`idTratamiento` = `pt`.`Tratamiento_idTratamiento`))) join `Pacientes` `p` on((`pt`.`Pacientes_idPacientes` = `p`.`idPacientes`))) where (`t`.`Precio` = (select max(`Tratamiento`.`Precio`) from `Tratamiento`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-30 13:05:56
