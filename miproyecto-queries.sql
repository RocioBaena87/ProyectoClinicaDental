-- Cantidad de citas atendidas por empleado,ordenadas de mayor a menor cantidad. 
select e.Nombre, e.Apellidos, count(c.idCita) as Numero_Citas
from Empleados e
  inner join Empleados_has_Cita ec
  on e.idEmpleados = ec.Empleados_idEmpleados
  inner join Cita c
  on ec.Cita_idCita = c.idCita
group by e.idEmpleados
order by Numero_Citas desc;
-- Pacientes que han recibido el tratamiento más caro.
select t.Nombre_tratamiento, t.Precio, p.Nombre, p.Apellidos
from Tratamiento t
  inner join Pacientes_has_Tratamiento pt
  on t.idTratamiento = pt.Tratamiento_idTratamiento
  inner join Pacientes p
  on pt.Pacientes_idPacientes = p.idPacientes
where t.Precio =
   (select max(Precio)
   from Tratamiento);
-- Cantidad de pacientes atendidos por especialidad.
select esp.Nombre_Especialidad, count(distinct c.Pacientes_idPacientes) AS Numero_Pacientes
from Especialidad esp
inner join Empleados e
  on esp.idEspecialidad = e.Especialidad_idEspecialidad
  inner join Empleados_has_Cita ec
  on e.idEmpleados = ec.Empleados_idEmpleados
  inner join Cita c
  on ec.Cita_idCita = c.idCita
group by esp.idEspecialidad
order by Numero_Pacientes desc;
-- Pacientes que se han realizado más de un tratamiento.
select p.Nombre, p.Apellidos, count(pt.Tratamiento_idTratamiento) as Numero_Tratamientos
from Pacientes p
  inner join Pacientes_has_Tratamiento pt
  on p.idPacientes = pt.Pacientes_idPacientes
group by p.idPacientes
having Numero_Tratamientos > 1
order by Numero_Tratamientos desc;
-- Total ingresos de tratamiento por empleados ordenados de mayor a menor ingreso.
select e.Nombre, e.Apellidos, sum(t.Precio) as Total_Ingresos
from Empleados e
  inner join Empleados_has_Cita ec on e.idEmpleados = ec.Empleados_idEmpleados
  inner join Cita c
  on ec.Cita_idCita = c.idCita
  inner join Pacientes_has_Tratamiento pt
  on c.Pacientes_idPacientes = pt.Pacientes_idPacientes
  inner join Tratamiento t
  on pt.Tratamiento_idTratamiento = t.idTratamiento
group by e.idEmpleados
order by Total_Ingresos desc;
-- Especialidad que tiene más citas
select e.Nombre_Especialidad, count(c.idCita) as total_citas
from Especialidad e
  inner join Empleados emp
  on e.idEspecialidad = emp.Especialidad_idEspecialidad
  inner join Empleados_has_Cita ec
  on emp.idEmpleados = ec.Empleados_idEmpleados
  inner join Cita c
  on ec.Cita_idCita = c.idCita
group by e.idEspecialidad, e.Nombre_Especialidad
order by total_citas desc
limit 1;
-- Total ingresos de la clínica por meses ordenador por año y mes descendente
select month(c.Fecha) as Mes, year(c.Fecha) as Año, sum(t.Precio) as Total_Ingresos
from Cita c
inner join Pacientes_has_Tratamiento pt
on c.Pacientes_idPacientes = pt.Pacientes_idPacientes
  inner join Tratamiento t
  on pt.Tratamiento_idTratamiento = t.idTratamiento
group by year(c.Fecha), month(c.Fecha)
order by Año, Mes desc;
-- Total de pacientes atendidos por cada empleado y especialidad
select e.idEmpleados , e.Nombre, e2.Nombre_Especialidad , count(distinct c.Pacientes_idPacientes) as Pacientes_Atendidos
from Especialidad e2
  inner join Empleados e
  on e.Especialidad_idEspecialidad =e2.idEspecialidad
  inner join Empleados_has_Cita ehc 
  on e.idEmpleados =ehc.Empleados_idEmpleados
  inner join Cita c
  on ehc.Cita_idCita =c.idCita
group by e.idEmpleados, e.Nombre , e2.Nombre_Especialidad
order by Pacientes_Atendidos desc;
-- Cantidad de citas por pacientes en una fecha determinada
select p.idPacientes, p.Nombre, p.Apellidos, count(c.idCita) as total_citas
from Pacientes p
  inner join Cita c
  on p.idPacientes = c.Pacientes_idPacientes
where c.Fecha between '2025-01-01' and '2025-03-31'
group by p.idPacientes, p.Nombre, p.Apellidos
order by total_citas desc;
-- Pacientes que se han realizado el tratamiento más realizado las fechas 1febrero al 28 febrero 2025.
select p.Nombre,p.Apellidos, t.Nombre_tratamiento
from Pacientes p
  inner join Cita c
  on p.idPacientes =c.Pacientes_idPacientes
  inner join Pacientes_has_Tratamiento pht
  on c.Pacientes_idPacientes =pht.Pacientes_idPacientes
  inner join Tratamiento t
  on pht.Tratamiento_idTratamiento =t.idTratamiento
where pht.Tratamiento_idTratamiento >=all (
select t.idTratamiento
from Cita c
  inner join Pacientes p
  on c.Pacientes_idPacientes=p.idPacientes
  inner join Pacientes_has_Tratamiento pht
  on p.idPacientes=pht.Pacientes_idPacientes
  inner join Tratamiento t
  on pht.Tratamiento_idTratamiento=t.idTratamiento
where c.Fecha between '2025-02-01' and '2025-02-28'
group by t.idTratamiento,t.Nombre_tratamiento);
-- Número de visitas a la clínica por mes y año
select year (c.Fecha) as Año,month(c.Fecha) as num_mes, monthname(c.Fecha) as Mes, count(*) as Numero_visitas
from Cita c
group by Año,num_mes,Mes
order by Año, num_mes asc;
-- Paciente que más ha gastado
select p.Nombre, p.Apellidos, sum(t.Precio) as TotalGastado
from Pacientes p
  inner join Pacientes_has_Tratamiento pht
  on p.idPacientes = pht.Pacientes_idPacientes
  inner join Tratamiento t
  on pht.Tratamiento_idTratamiento = t.idTratamiento
group by p.idPacientes, p.Nombre, p.Apellidos
having sum(t.Precio) >= all (
  select sum(t2.Precio)
  from Pacientes_has_Tratamiento pht2
     inner join Tratamiento t2
     on pht2.Tratamiento_idTratamiento = t2.idTratamiento
  group by pht2.Pacientes_idPacientes);
-- Empleados con más citas atendidas que el que menos atendió
select e.Nombre, e.Apellidos, count(distinct c.Pacientes_idPacientes) as Pacientes_Atendidos
from Empleados e
  inner join Empleados_has_Cita ec
  on e.idEmpleados = ec.Empleados_idEmpleados
  inner join Cita c
  on ec.Cita_idCita = c.idCita
group by e.idEmpleados, e.Nombre, e.Apellidos
having count(distinct c.Pacientes_idPacientes) >= all(
   select count(distinct c2.Pacientes_idPacientes)
   from Empleados_has_Cita ec2
      inner join Cita c2
      on ec2.Cita_idCita = c2.idCita
   group by ec2.Empleados_idEmpleados);

-- Función: Precio total de tratamientos de un paciente
DELIMITER &&
create function calcular_precio_total_tratamiento(id_paciente int)
returns decimal(10,2)
deterministic
begin
   declare precio_total decimal(10,2);
   select sum(t.Precio) into precio_total
   from Tratamiento t
   join Pacientes_has_Tratamiento pt on t.IDTratamiento = pt.Tratamiento_IDTratamiento
   where pt.Pacientes_IDPacientes = id_paciente;
   return ifnull(precio_total, 0);
end &&
DELIMITER ;
select calcular_precio_total_tratamiento(1);
-- Función: Total citas de un empleado
DELIMITER &&
create function contar_citas_empleado(id_empleado int) returns int
deterministic
begin
   declare cantidad_citas int;
   select count(*) into cantidad_citas
   from Empleados_has_Cita
   where Empleados_idEmpleados = id_empleado;
   return cantidad_citas;
end &&
DELIMITER ;
-- consulta
select count(*) as cantidad_citas
from Empleados_has_Cita
where Empleados_idEmpleados = 1;
--
select contar_citas_empleado(1);
-- Función: Citas de un paciente en un periodo de tiempo
DELIMITER &&
create function contar_citas_paciente(id_paciente int, fecha_inicio date, fecha_fin date)
returns int
deterministic
begin
   declare total_citas int default 0;
   select count(*) into total_citas
   from Cita c
   where c.Pacientes_idPacientes = id_paciente
   and c.Fecha between fecha_inicio and fecha_fin;
   return total_citas;
end &&
DELIMITER ;
select contar_citas_paciente (712, '2025-02-01', '2025-02-28') as total_citas;
-- consulta
select p.idPacientes, p.Nombre, p.Apellidos, count(c.idCita) as total_citas
from Pacientes p
  inner join Cita c
  on p.idPacientes = c.Pacientes_idPacientes
where p.idPacientes = 712
and c.Fecha between '2025-02-01' and '2025-02-28'
group by p.idPacientes, p.Nombre, p.Apellidos;
-- Procedimiento: Lista de tratamientos de los pacientes
DELIMITER &&
create procedure lista_tratamientos_paciente(in id_paciente int)
begin
   select t.Nombre_tratamiento, t.Precio
   from Tratamiento t
   inner join Pacientes_has_Tratamiento pt
   on t.idTratamiento = pt.Tratamiento_idTratamiento
   where pt.Pacientes_idPacientes = id_paciente;
end &&
DELIMITER ;
-- consulta
select t.Nombre_tratamiento, t.Precio
from Tratamiento t
  inner join Pacientes_has_Tratamiento pt
  on t.idTratamiento = pt.Tratamiento_idTratamiento
where pt.Pacientes_idPacientes = 780;
call lista_tratamientos_paciente (780);
-- Procedimiento con función anterior: Precio total tratamientos de un paciente.
DELIMITER &&
create procedure calcular_precio_total_tratamiento(in id_paciente int)
begin
   select p.Nombre, p.Apellidos, calcular_precio_total_tratamiento(id_paciente) as Total_precio
   from Pacientes p
   inner join Pacientes_has_Tratamiento pt
   on p.idPacientes = pt.Pacientes_idPacientes
   inner join Tratamiento t
   on pt.Tratamiento_idTratamiento = t.idTratamiento
where p.idPacientes = id_paciente; 
end &&
DELIMITER ;
-- consulta
select  p.Nombre, p.Apellidos, sum(t.Precio) as Total_gastos
from Pacientes p
  inner join Pacientes_has_Tratamiento pt
  on p.idPacientes = pt.Pacientes_idPacientes
  inner join Tratamiento t
  on pt.Tratamiento_idTratamiento = t.idTratamiento
where p.idPacientes = 48 
group by p.idPacientes;
--
call calcular_precio_total_tratamiento (485);
-- Procedimiento para ver todo el historial de un paciente,fecha,
-- tratamiento,empleado que le atendio y gasto.
DELIMITER &&
create procedure HistorialPaciente(in paciente_id int)
begin
   select
   p.idPacientes,
   concat(p.Nombre, ' ', p.Apellidos) as Paciente,
   c.Fecha as Fecha_Cita,
   concat(e.Nombre, ' ', e.Apellidos) as Empleado_Atendio,
   t.Nombre_tratamiento as Tratamiento_Realizado,
   t.Precio as Gasto
from Pacientes p
  inner join Cita c
  on p.idPacientes = c.Pacientes_idPacientes
  inner join Empleados_has_Cita ec
  on c.idCita = ec.Cita_idCita
  inner join Empleados e
  on ec.Empleados_idEmpleados = e.idEmpleados
  inner join Pacientes_has_Tratamiento pt
  on p.idPacientes = pt.Pacientes_idPacientes
  inner join Tratamiento t
  on pt.Tratamiento_idTratamiento = t.idTratamiento
where p.idPacientes = paciente_id
order by c.Fecha desc;
  
end &&
DELIMITER ;
--
select
   p.idPacientes,
   concat(p.Nombre, ' ', p.Apellidos) as Paciente,
   c.Fecha as Fecha_Cita,
   concat(e.Nombre, ' ', e.Apellidos) as Empleado_Atendio,
   t.Nombre_tratamiento as Tratamiento_Realizado,
   t.Precio as Gasto
from Pacientes p
  inner join Cita c
  on p.idPacientes = c.Pacientes_idPacientes
  inner join Empleados_has_Cita ec
  on c.idCita = ec.Cita_idCita
  inner join Empleados e
  on ec.Empleados_idEmpleados = e.idEmpleados
  inner join Pacientes_has_Tratamiento pt
  on p.idPacientes = pt.Pacientes_idPacientes
  inner join Tratamiento t
  on pt.Tratamiento_idTratamiento = t.idTratamiento
where p.idPacientes = 1
order by c.Fecha desc;
call HistorialPaciente (1000);

-- Trigger: Actualizar el gasto de un paciente al añadir un tratamiento.
DELIMITER &&
create trigger mensaje_total_gasto
after insert on Pacientes_has_Tratamiento
for each row
begin
   declare total_gasto decimal(10,2);
   declare mensaje varchar(255);
  
   select sum(t.Precio)
   into total_gasto
   from Tratamiento t
      inner join Pacientes_has_Tratamiento pt
      on t.idTratamiento = pt.Tratamiento_idTratamiento
   where pt.Pacientes_idPacientes = new.Pacientes_idPacientes;
  
  
   set mensaje= concat('El paciente ha gastado un total de ', total_gasto, ' euros.');
   signal sqlstate '45000'
   set MESSAGE_TEXT = mensaje;
end &&
DELIMITER ;
-- Probamos
select p.idPacientes, p.Nombre, p.Apellidos, sum(t.Precio) as Total_Gastos
from Pacientes p
 inner join Pacientes_has_Tratamiento pt
 on p.idPacientes = pt.Pacientes_idPacientes
  inner join Tratamiento t
  on pt.Tratamiento_idTratamiento = t.idTratamiento
where p.idPacientes = 78
group by p.idPacientes, p.Nombre, p.Apellidos;
-- Añadimos un nuevo tratamiento
insert into Pacientes_has_Tratamiento (Pacientes_idPacientes, Tratamiento_idTratamiento)
values (78, 89);
-- Trigger evitar duplicados de citas en un paciente
DELIMITER &&
create trigger evitar_duplicado
before insert on Cita
for each row
begin
   declare existe int;
   select count(*) into existe
   from Cita
   where Pacientes_idPacientes = new.Pacientes_idPacientes
   and Fecha = new.Fecha;
   if existe > 0 then
       signal sqlstate '45000'
       set MESSAGE_TEXT = 'Error: El paciente ya tiene una cita ese día';
   end if;
end &&
DELIMITER ;
-- Probamos
select *
from Cita c
  inner join Pacientes p
  on c.Pacientes_idPacientes =p.idPacientes
where p.idPacientes =708
and c.Fecha ='2025-02-10';
-- Insertamos para que nos salga el error de cita duplicada
insert into Cita (Pacientes_idPacientes,Fecha)
values (708,'2025-02-10');

-- View cantidad de citas atendidas por empleado,ordenadas de mayor a menor cantidad.
create view Vista_Cantidad_Citas_Empleados as
select e.Nombre, e.Apellidos, count(c.idCita) as Numero_Citas
from Empleados e
  inner join Empleados_has_Cita ec
  on e.idEmpleados = ec.Empleados_idEmpleados
  inner join Cita c
  on ec.Cita_idCita = c.idCita
group by e.idEmpleados
order by Numero_Citas desc;
select * from Vista_Cantidad_Citas_Empleados;
-- View pacientes que han recibido el tratamiento más caro.
create view Vista_Tratamiento_Mas_Caro as
select t.Nombre_tratamiento, t.Precio, p.Nombre, p.Apellidos
from Tratamiento t
  inner join Pacientes_has_Tratamiento pt
  on t.idTratamiento = pt.Tratamiento_idTratamiento
  inner join Pacientes p
  on pt.Pacientes_idPacientes = p.idPacientes
where t.Precio =
   (select max(Precio)
   from Tratamiento);
select * from Vista_Tratamiento_Mas_Caro;


-- Especialidad con más citas canceladas.
SELECT e.Nombre_Especialidad, COUNT(*) AS TotalCanceladas
FROM Especialidad e
   INNER JOIN Empleados e2 ON e.idEspecialidad = e2.Especialidad_idEspecialidad
   INNER JOIN Empleados_has_Cita ehc ON e2.idEmpleados = ehc.Empleados_idEmpleados
   INNER JOIN Cita c ON ehc.Cita_idCita = c.idCita
WHERE c.Estado_cita = 'Cancelada'
GROUP BY e.idEspecialidad, e.Nombre_Especialidad
HAVING COUNT(*) >= ALL (
       SELECT COUNT(*)
       FROM Cita c2
           INNER JOIN Empleados_has_Cita ehc2 ON c2.idCita = ehc2.Cita_idCita
           INNER JOIN Empleados e3 ON ehc2.Empleados_idEmpleados = e3.idEmpleados
           INNER JOIN Especialidad e4 ON e3.Especialidad_idEspecialidad = e4.idEspecialidad
       WHERE c2.Estado_cita = 'Cancelada'
       GROUP BY e4.idEspecialidad
);
