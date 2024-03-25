#S02.01
#N1.Exercici 1: Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT id AS id_transaccion
FROM transaction
WHERE company_id IN 
	(SELECT id
    FROM company
    WHERE country = 'Germany');
    
##CORREGIDO### 
#N1.Exercici 2: llistat de les empreses que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions.
SELECT company_name 
FROM company
WHERE company.id IN
		(SELECT company_id
		FROM transaction
		GROUP BY company_id
		HAVING AVG(amount) >
			(SELECT AVG(amount) FROM transaction));
            
            
##CORREGIDO###            
#N1.Exercici 3: nom d'empresa que inicia amb la lletra c, mostrar informació de les transaccions.
SELECT t.*
FROM transaction t
WHERE t.company_id IN
	(SELECT id
    FROM company c
    WHERE company_name LIKE 'C%');

    
##CORREGIDO###  
#N1.Exercici 4: Van eliminar del sistema les empreses que no tenen transaccions registrades, lliura el llistat d'aquestes empreses.
SELECT company_name
FROM company
WHERE NOT EXISTS
	(SELECT distinct company_id
    FROM transaction);
    
##CORREGIDO###  
## NIVELL 2
#N2.Exercici 1: totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia 'Non Institute'
SELECT t.*
FROM transaction t
WHERE company_id IN  (
	SELECT c.id
    FROM company c
    WHERE company_name <> 'Non Institute' AND country = ( 
		SELECT country
		FROM company
		WHERE company_name = 'Non Institute'
        )
	);

        
#N2.Exercici 2: trobar l'empresa que ha realitzat la transacció de major suma en la base de dades.
SELECT c.company_name
FROM company c
WHERE c.id IN (
	SELECT t.company_id
	FROM transaction t
	WHERE t.amount = 
		(SELECT max(t.amount)
        FROM transaction t)
	);

###Corregido###    
## NIVELL 3
#N3.Exercici 1: necessiten el llistat dels països la mitjana de transaccions dels quals sigui superior a la mitjana general.
SELECT country, ROUND(AVG(amount), 2) AS avg_by_country
FROM ( SELECT c.country, t.amount
	FROM company c, transaction t
    WHERE c.id=t.company_id) AS transactions_by_country
GROUP BY country
HAVING AVG(amount) > (
	SELECT AVG(amount)
    FROM transaction);
      

###CORREGIDO       
#N3.Exercici 2: llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.
SELECT count(t.id), c.company_name,
	CASE 	
		WHEN count(t.id) > 4 THEN 'T' 
        ELSE 'F'
        END AS more_than_4
FROM transaction t, company c
WHERE t.company_id = c.id
GROUP BY c.company_name;

