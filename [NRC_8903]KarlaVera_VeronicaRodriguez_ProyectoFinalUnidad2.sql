--CONSULTA 1
--Proporcione una consulta que muestre el nombre de la pista que empiece con la letra K o la V, la lista de reproducción, género, 
--artista, el título del álbum y el tipo de medio de cada pista en orden ascendente, además calcule la media de los bytes de cada pista.
SELECT *
FROM tracks;
SELECT *
FROM playlists;
SELECT *
FROM artists;
SELECT *
FROM playlist_track;
SELECT  tracks.Name AS "PISTA",
        playlists.Name AS "LISTA DE REPRODUCCIÓN",
        artists.Name AS "ARTISTA",
        genres.Name AS "GÉNERO",
        albums.Title AS "TÍTULO DEL ÁLBUM",
        media_types.Name AS "TIPO DE MEDIO",
        AVG(tracks.Bytes) AS "MEDIA de los BYTES"
FROM tracks 
    INNER JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
    INNER JOIN genres ON genres.GenreId = tracks.GenreId
    INNER JOIN playlist_track ON playlist_track.TrackId = tracks.TrackId
    INNER JOIN playlists ON playlists.PlaylistId = playlist_track.PlaylistId
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN artists ON artists.ArtistId = albums.ArtistId
WHERE tracks.Name LIKE 'K%' OR tracks.Name LIKE 'V%'
GROUP BY tracks.TrackId
ORDER BY tracks.Name ASC;
--Listar los 15 mejores clientes (aquellos que tiene un total de facturación) 
--indicando el nombre  y apellido del cliente, el importe total de su facturación, la cantidad de facturación,
--el nombre del artita con el titulo del album comprado y el género que sea Rock 
SELECT *
FROM customers;
SELECT *
FROM invoice_items;
SELECT customers.FirstName||" "||customers.LastName AS "CLIENTE", 
       artists.Name AS "ARTÍSTA",
       albums.Title AS "TÍTULO DEL ÁLBUM",
       genres.Name AS "GÉNERO",
       SUM(invoices.Total) AS "TOTAL DE FACTURACIÓN",
       COUNT(invoice_items.Quantity) AS "CANTIDAD FACTURACIÓN"
FROM tracks
    INNER JOIN genres ON genres.GenreId = tracks.GenreId    
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN artists ON artists.ArtistId = albums.ArtistId
    INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN invoices ON invoices.InvoiceId = invoice_items.InvoiceId
    INNER JOIN customers ON customers.CustomerId = invoices.CustomerId
WHERE genres.Name = 'Rock'
GROUP BY customers.CustomerId
ORDER BY SUM(invoices.Total) DESC 
LIMIT 15;

--Listar el nombre y apellido de los empleados que tengan un cargo de “Sales Support Agent” en oreden ascendente, así como 
--los clientes que tienen asignados, la pista con su lista de reproducción, así como el total de la facturación total sea .
-- count(*)
SELECT * 
FROM invoices;

SELECT employees.FirstName||" "||employees.LastName AS "EMPLEADO",
       employees.Title AS "CARGO",
       customers.FirstName||" "||customers.LastName AS "CLIENTE ASIGNADO",
       tracks.Name AS "PISTA",
       tracks.Composer AS "COMPOSITOR",
       playlists.Name AS "LISTA DE REPRODUCCIÓN",
       SUM(invoices.Total) AS "FACTURACIÓN TOTAL"
FROM tracks
    INNER JOIN playlist_track ON playlist_track.TrackId = tracks.TrackId
    INNER JOIN playlists ON playlists.PlaylistId = playlist_track.PlaylistId
    INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN invoices ON invoices.InvoiceId = invoice_items.InvoiceId
    INNER JOIN customers ON customers.CustomerId = invoices.CustomerId
    INNER JOIN employees ON employees.EmployeeId = customers.SupportRepId
WHERE employees.Title = "Sales Support Agent"
GROUP BY employees.EmployeeId
ORDER BY employees.FirstName||" "||employees.LastName ASC
;


--Proporcionar una consulta que muestre el nombre y apellido del cliente, la ciudad que empiececon la letra R
--con el total de facturas realizadas, así como las pistas y su lista de reproducción con el género.

SELECT customers.FirstName||" "||customers.LastName AS "CLIENTE", 
       invoices.BillingCity AS "CIUDAD",
       tracks.Name AS "PISTA",
       playlists.Name AS "LISTA DE REPRODUCCIÓN",
       genres.Name AS "GÉNERO",
       COUNT(invoice_items.Quantity) AS "N° DE FACTURAS"      
FROM tracks
    INNER JOIN genres ON genres.GenreId = tracks.GenreId
    INNER JOIN playlist_track ON playlist_track.TrackId = tracks.TrackId
    INNER JOIN playlists ON playlists.PlaylistId = playlist_track.PlaylistId
    INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN invoices ON invoices.InvoiceId = invoice_items.InvoiceId
    INNER JOIN customers ON customers.CustomerId = invoices.CustomerId
WHERE BillingCity LIKE 'R%'
GROUP BY BillingCity;

--Muestre el nombre y apellido del cliente con el email que sea de la forma '@gmail', mostrando  
--el estado de cuenta pero que este no sea nulo, el total de facturas generadas, la pista con su valor unitario, género, tipo de medio
--además se desea conocer el total de álbums

SELECT customers.FirstName||" "||customers.LastName AS "CLIENTE", 
       customers.Email AS "EMAIL",
       invoices.BillingState AS "ESTADO DE CUENTA",
       SUM(invoice_items.Quantity) AS "N° DE CUENTAS",
       tracks.Name AS "PISTA",
       tracks.UnitPrice AS "VALOR UNITARIO",
       genres.Name AS "GÉNERO",
       media_types.Name AS "TIPO DE MEDIO",
       COUNT(albums.AlbumId) AS "TOTAL DE ÁLBUMS"
FROM tracks
    INNER JOIN genres ON genres.GenreId = tracks.GenreId
    INNER JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN invoices ON invoices.InvoiceId = invoice_items.InvoiceId
    INNER JOIN customers ON customers.CustomerId = invoices.CustomerId
WHERE invoices.BillingState IS NOT NULL
GROUP BY customers.CustomerId
HAVING INSTR(customers.Email,'@gmail')>0
ORDER BY customers.FirstName||" "||customers.LastName ASC;

--Se desea conocer el nombre y apellido del empleado con el cliente asignado, también se debe ver el código de facturacion del cliente
-- fechade la factura, las listas de reproducción y el total de facturas que deben ser  mayor a 30 de forma ASC, tener en cuenta que el 
--total de facturas generadas deben de ser del año 2013

SELECT employees.FirstName||" "||employees.LastName AS "EMPLEADO",
       customers.FirstName||" "||customers.LastName AS "CLIENTE ASIGNADO",
       invoices.InvoiceDate AS "FECHA FACTURA",
       playlists.Name AS "LISTA DE REPRODUCCIÓN",   
       COUNT(invoices.Total) AS "N° DE  FACTURAS"
FROM tracks 
    INNER JOIN playlist_track ON playlist_track.TrackId = tracks.TrackId
    INNER JOIN playlists ON playlists.PlaylistId = playlist_track.PlaylistId
    INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN invoices ON invoices.InvoiceId = invoice_items.InvoiceId
    INNER JOIN customers ON customers.CustomerId = invoices.CustomerId
    INNER JOIN employees ON employees.EmployeeId = customers.SupportRepId
WHERE invoices.InvoiceDate LIKE '2013-%'
GROUP BY customers.FirstName||" "||customers.LastName
HAVING COUNT(invoices.Total) > 30
ORDER BY COUNT(invoices.Total) ASC;

--Listar los 10 artistas con mayor número de canciones que este entre 90 y 350 de forma descendente según el número de canciones
--ademas se desea ver el nombre del compositor, lista de reproducción, genero y el tipo de medio se por MPEG audio file
SELECT artists.Name AS "ARTISTA", 
       COUNT(*) AS Canciones,
       tracks.Composer AS "COMOPOSITOR",
       playlists.Name AS "LISTA DE REPRODUCCIÓN",
       genres.Name AS "GÉNERO",
       media_types.Name AS "TIPO DE MEDIO"
FROM tracks
    INNER JOIN genres ON genres.GenreId = tracks.GenreId
    INNER JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN artists ON artists.ArtistId = albums.ArtistId
    INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN playlist_track ON playlist_track.TrackId = tracks.TrackId
    INNER JOIN playlists ON playlists.PlaylistId = playlist_track.PlaylistId
WHERE media_types.Name = "MPEG audio file" 
GROUP BY artists.Name
HAVING  Canciones BETWEEN 90 AND 350
ORDER BY Canciones DESC
LIMIT 10;

--Proporciones una consulta que muestre la MAX Y MIN  factura generada (fecha) con el nombre y apellido del cliente de forma ASC, además se desea 
--ver cantidad de la linea de factura, la pistas con el tiempo (milisegundos > 200000), el artista , album, tipo de medio y género

SELECT customers.FirstName||" "||customers.LastName AS "CLIENTE",
       MAX(invoices.InvoiceDate) AS "MAX FACTURA GENERADA",
       MIN(invoices.InvoiceDate) AS "MIN FACTURA GENERADA",
       invoice_items.Quantity AS "CANTIDAD",
       tracks.Name AS "PISTA",
       tracks.Milliseconds AS "TIEMPO",
       artists.Name AS "ARTISTA",
       albums.Title AS "TÍTULO DEL ÁLBUM",
       media_types.Name "TIPO DE MEDIO",
       genres.Name AS "GÉNERO"
FROM tracks
    INNER JOIN genres ON genres.GenreId = tracks.GenreId
    INNER JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN artists ON artists.ArtistId = albums.ArtistId
    INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN invoices ON invoices.InvoiceId = invoice_items.InvoiceId
    INNER JOIN customers ON customers.CustomerId = invoices.CustomerId
GROUP BY customers.FirstName||" "||customers.LastName 
HAVING tracks.Milliseconds  > 200000
ORDER  BY customers.FirstName||" "||customers.LastName  ASC;


-- Se desea conocer el cliente, cuyo apellido empiece con la letra J, en donde se muestre la pista comprada y el mínimo valor por la que fue adquirida.
-- Además, se requiere revisar el artista y el album al qeu pertenece. Hay que tomar en cuenta que se estan mostrando las pistas que empiecen con la letra A
-- y de igual manera el género que corresponde la pista.

SELECT  customers.FirstName        AS "Nombre del cliente",
        customers.LastName         AS "Apellido del cliente",
        tracks.Name                AS "Pista",
        albums.Title               AS "Album",
        artists.Name               AS "Artista",
        genres.Name                AS "Genero",
        MIN(invoices.Total)
        
FROM customers 
    INNER JOIN invoices         ON customers.CustomerId = invoices.CustomerId
    INNER JOIN invoice_items    ON invoices.InvoiceId = invoice_items.InvoiceId
    INNER JOIN tracks           ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN albums           ON tracks.AlbumId = albums.AlbumId
    INNER JOIN artists          ON albums.ArtistId = artists.ArtistId
    INNER JOIN genres           ON tracks.GenreId = genres.GenreId
    
WHERE     customers.LastName LIKE "J%"
      AND tracks.Name LIKE "A%";



--  Se requiere conocer el empleado que ha vendido las pistas que tienen el mismo nombre en el album.
-- A partir de esto, se quiere conocer aquellos que la lista de reproducción fue movies y agruparlos por su nombre.
-- Además, es necesario ordenarlos en forma ascendente por la fecha de cumpleaños.

SELECT  employees.FirstName        AS "Nombre del empleado",
        tracks.Name                AS "Pista",
        albums.Title               AS "Album",
        playlists.Name             AS "Lista de reproducción"
        
FROM employees, customers 
    INNER JOIN invoices         ON customers.CustomerId = invoices.CustomerId
    INNER JOIN invoice_items    ON invoices.InvoiceId = invoice_items.InvoiceId
    INNER JOIN tracks           ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN albums           ON tracks.AlbumId = albums.AlbumId
    INNER JOIN playlist_track   ON tracks.TrackId = playlist_track.TrackId
    INNER JOIN playlists        ON playlists.PlaylistId = playlist_track.TrackId
    
WHERE     tracks.Name = albums.Title
      AND playlists.Name = "Movies"
      
GROUP BY employees.FirstName
ORDER BY employees.BirthDate ASC;


--ETL
--Muestre el nombre y apellido del cliente con el email que sea de la forma '@gmail', mostrando  
--el estado de cuenta pero que este no sea nulo, el total de facturas generadas, la pista con su valor unitario, género, tipo de medio
--además se desea conocer el total de álbums y el promedio de la facturación total

SELECT customers.FirstName||" "||customers.LastName AS "CLIENTE", 
       customers.Email AS "EMAIL",
       invoices.BillingState AS "ESTADO DE CUENTA",
       SUM(invoice_items.Quantity) AS "N° DE CUENTAS",
       tracks.Name AS "PISTA",
       tracks.UnitPrice AS "VALOR UNITARIO",
       genres.Name AS "GÉNERO",
       media_types.Name AS "TIPO DE MEDIO",
       COUNT(albums.AlbumId) AS "TOTAL DE ÁLBUMS",
       AVG(invoices.Total) AS "PROMEDIO FACTURACIÓN TOTAL"
FROM tracks
    INNER JOIN genres ON genres.GenreId = tracks.GenreId
    INNER JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN invoices ON invoices.InvoiceId = invoice_items.InvoiceId
    INNER JOIN customers ON customers.CustomerId = invoices.CustomerId
WHERE invoices.BillingState IS NOT NULL
GROUP BY customers.CustomerId
HAVING INSTR(customers.Email,'@gmail')>0
ORDER BY customers.FirstName||" "||customers.LastName ASC;

--Proporciones una consulta que muestre la MAX Y MIN  factura generada (fecha) con el nombre y apellido del cliente de forma ASC, además se desea 
--ver cantidad total de la linea de factura, la pistas con el tiempo (milisegundos > 200000), el artista , album, tipo de medio y género

SELECT customers.FirstName||" "||customers.LastName AS "CLIENTE",
       MAX(invoices.InvoiceDate) AS "MAX FACTURA GENERADA",
       MIN(invoices.InvoiceDate) AS "MIN FACTURA GENERADA",
       COUNT(invoice_items.Quantity) AS "CANTIDAD",
       tracks.Name AS "PISTA",
       tracks.Milliseconds AS "TIEMPO",
       artists.Name AS "ARTISTA",
       albums.Title AS "TÍTULO DEL ÁLBUM",
       media_types.Name "TIPO DE MEDIO",
       genres.Name AS "GÉNERO"
FROM tracks
    INNER JOIN genres ON genres.GenreId = tracks.GenreId
    INNER JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN artists ON artists.ArtistId = albums.ArtistId
    INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
    INNER JOIN invoices ON invoices.InvoiceId = invoice_items.InvoiceId
    INNER JOIN customers ON customers.CustomerId = invoices.CustomerId
GROUP BY customers.FirstName||" "||customers.LastName 
HAVING tracks.Milliseconds  > 200000
ORDER  BY customers.FirstName||" "||customers.LastName  ASC;
