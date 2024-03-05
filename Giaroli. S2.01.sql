#S02.01
#N1.Exercici 1: Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT id AS id_transaccion
FROM transaction
WHERE company_id IN 
	(SELECT id
    FROM company
    WHERE country = 'Germany');
    
#N1.Exercici 2: llistat de les empreses que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions.
SELECT company_name 
FROM company
WHERE company.id IN
		(SELECT company_id
		FROM transaction
		GROUP BY company_id
		HAVING sum(amount) >
			(SELECT AVG(amount) FROM transaction));
            
#N1.Exercici 3: nom d'empresa que inicia amb la lletra c, mostrar informació de les transaccions.
SELECT company.company_name, transaction.*
FROM transaction
JOIN company ON transaction.company_id = company.id
WHERE company.company_name LIKE 'C%';

##alternativa con subquery y join
SELECT company_name, transaction.*
FROM transaction
JOIN company ON transaction.company_id = company.id
WHERE transaction.company_id IN
	(SELECT id
    FROM company
    WHERE company_name LIKE 'C%');
    
#N1.Exercici 4: Van eliminar del sistema les empreses que no tenen transaccions registrades, lliura el llistat d'aquestes empreses.
SELECT company_name
FROM company
LEFT JOIN transaction ON transaction.company_id = company.id
WHERE company_id IS NULL;

##alternativa con subquery
SELECT company_name
FROM company
WHERE id NOT IN 
	(SELECT distinct company_id
    FROM transaction);
    
## NIVELL 2
#N2.Exercici 1: totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia 'Non Institute'
SELECT company.company_name, transaction.*
FROM transaction
LEFT JOIN company ON transaction.company_id = company.id
WHERE company_name <> 'Non Institute' AND country IN 
		(SELECT country
		FROM company
		WHERE company_name = 'Non Institute');
        
#N2.Exercici 2: trobar l'empresa que ha realitzat la transacció de major suma en la base de dades.
SELECT company.company_name
FROM company
WHERE company.id IN (
	SELECT company_id
	FROM transaction
	WHERE amount = 
		(SELECT max(amount)
        FROM transaction)
	);
    
## NIVELL 3
#N3.Exercici 1: necessiten el llistat dels països la mitjana de transaccions dels quals sigui superior a la mitjana general.
SELECT country, AVG(amount) AS avg_by_country
FROM company
JOIN transaction
ON company.id = transaction.company_id
GROUP BY country
HAVING AVG(amount) > 
	(SELECT AVG(amount)
	FROM transaction);
    
#N3.Exercici 2: llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.
SELECT count(transaction.id) as number_trans, company_name,
	CASE 	
		WHEN count(transaction.id) > 4 THEN 'T' 
        ELSE 'F'
        END AS more_than_4
FROM transaction
JOIN company
ON transaction.company_id = company.id
GROUP BY company_name;

