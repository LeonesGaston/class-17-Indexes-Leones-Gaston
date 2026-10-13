-- ejercicio 1
Select * from address
join city c on address.city_id = c.city_id
join country co on c.country_id = co.country_id
where postal_code in ("35200", "53561", "83579", "34021", "34689", "38145")
and postal_code not in ("5135", "48960", "71110", "10885", "4285", "83401");

-- ejecucion 0.007s
-- ejecucion 0,006s despues del index

Select * from address
join city c on address.city_id = c.city_id
join country co on c.country_id = co.country_id
where postal_code in ("35200", "53561", "83579", "34021", "34689", "38145", "75543", "25958", "84931")
and postal_code not in ("5135", "48960", "71110", "10885", "4285", "83401", "67497", "8862", "55709", "20657");

-- ejecucion 0,011s
-- ejecucion despues del index 0,009s

Create index postal_code_address
on address (postal_code);

/*
Al crear un índice sobre `postal_code`, MySQL puede localizar los registros que cumplen las
condiciones utilizando el índice, en lugar de recorrer toda la tabla. Esto puede reducir el
tiempo de ejecución. En mis mediciones, observé una pequeña mejora después de crear el índice.
*/

-- ejercicio 2
Select first_name from actor
where first_name = "NICK";
-- 0,003 segundos de ejecucion

Select last_name from actor
where last_name = "WAHLBERG";
-- 0,003 segundos de ejecucion

-- La duracion es practicamente la misma debido a que posee pocos registros la tabla actor, en caso de tener mas, habria diferencias
-- Una diferencia entre estas 2 querys es que ya hay existente un index para last_name pero no para first_name
-- Si queremos mas detalle de la query, podemos usar explain, que muestra como sql ejecutara la query

-- ejercicio 3

Select * from film
where description like "%an%";
-- devuelve 1000 resultados

Select * from film
where match (description) against ("an");
-- devuelve 0 resultados
/*
La columna de description no es un fulltext, por lo tanto no puede ser usado con match() y against(),
pero, si fuera, estas 2 querys buscarian de manera diferente, debido a que like busca en la cadena de
texto, algun patron que diga an, pero el match y against, buscan esa palabra dentro de la cadena, son
diferentes resultados, lo que se puede hacer para resolver esto es ingresar:
*/
create fulltext index film_description
on film (description);

-- despues de ejecutar este codigo, es posible ejecutar el match y against y luego para dejar como esta, ejecutar:

drop index film_description on film;
