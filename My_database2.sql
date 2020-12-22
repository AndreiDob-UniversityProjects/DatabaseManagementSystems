USE Airport_Management
INSERT INTO Planes(Model, Capacity,Fuel_consumption) VALUES('B747',200,1000),('A100',150,1000),('C555',200,750)
INSERT INTO Planes(Model, Capacity,Fuel_consumption) VALUES('C555',250,1055),('C555',270,1000),('C555',280,1050)
--INSERT INTO Passengers(CNP,CheckIn) VALUES (111,11/11/2018),(123,10/10/2019),(222,12/12/2017)

INSERT INTO Passengers(CNP,CheckIn,PassengerName) VALUES (111,11/11/2018,'henry'),(112,10/10/2019,'istvan'),(222, 12/12/2017,'alex')
INSERT INTO Flights(Plane_id,Passenger_id,Date,Origin,Destination) VALUES(1,111,2018/11/11,'ny','la'),(1,112,2018/11/12,'alaska','madrid'),
									(2,112,2019/11/11,'johanesbug','cluj')
INSERT INTO Flights(Plane_id,Passenger_id) VALUES(2,222),(5,222),(3,111),(4,112)
--INSERT INTO Flights(Plane_id,Passenger_id) VALUES (9,222)

INSERT INTO Luggages(Passenger_id,Size) VALUES(111,50),(112,100),(222,10)
--INSERT INTO Luggages(Passenger_id,Size) VALUES(111,90)


--DELETE FROM Planes WHERE P_id>6

UPDATE Planes
SET Model='WW2B'
--WHERE (Fuel_consumption BETWEEN 100 AND 800) OR Model IS NULL

UPDATE Planes
SET Model='WW3B'
WHERE P_id IN (SELECT P.P_id FROM Planes P WHERE P.Fuel_consumption>500)

UPDATE Flights 
SET Origin='BUCHAREST'
WHERE Origin LIKE 'Airport1' AND Destination LIKE 'Airport2'  and Length BETWEEN 50 AND 1000

UPDATE Passengers
SET PassengerName='john'
WHERE  PassengerName LIKE 'h%'

UPDATE Luggages
SET Size=30
WHERE Passenger_id>200

DELETE FROM Planes
WHERE P_id=9 OR Fuel_consumption=2500

DELETE FROM Planes
WHERE Fuel_consumption NOT BETWEEN 700 AND 1020

DELETE FROM Luggages
WHERE Passenger_id=111

DELETE FROM Flights
WHERE Duration IS NULL

DELETE FROM Flights
WHERE Origin LIKE 'Airport1' AND Destination LIKE 'Airport2'

SELECT * FROM Planes
SELECT * FROM Passengers
SELECT * FROM Flights
SELECT * FROM Luggages

--NAME AND CNP OF PASSANGERS THAT FLY IN A BOEING,AIRBUS OR RR
SELECT P.CNP, P.PassengerName
FROM Passengers P,Planes PL,Flights F
WHERE P.CNP=F.Passenger_id AND F.Plane_id=PL.P_id AND PL.Model='B747'
UNION ALL
SELECT P.CNP, P.PassengerName
FROM Passengers P,Planes PL,Flights F
WHERE P.CNP=F.Passenger_id AND F.Plane_id=PL.P_id AND (PL.Model='A100' OR PL.Model='RR22')
ORDER BY P.CNP

--PASS THAT FLY IN PLANES OF CAPACITY IN (170,200]
SELECT P.CheckIn
FROM Passengers P,Planes PL,Flights F
WHERE P.CNP=F.Passenger_id AND F.Plane_id=PL.P_id AND PL.Capacity>170
OR
P.CNP=F.Passenger_id AND F.Plane_id=PL.P_id AND PL.Capacity <=200


--passengers and luggage for passengers travelling with airbus planes THAT HAVE BIG LUGGAGES
SELECT P.CNP, P.PassengerName
FROM Passengers P,Planes PL,Flights F
WHERE P.CNP=F.Passenger_id AND F.Plane_id=PL.P_id AND PL.Model='B747'
INTERSECT
SELECT P.CNP, P.PassengerName
FROM Passengers P,Luggages L
WHERE P.CNP=L.Passenger_id AND L.Size>=50

--passengers and luggage for passengers travelling with airbus planes THAT HAVE MEDIUM LUGGAGES
SELECT DISTINCT P.CNP, P.PassengerName, L.Size
FROM Passengers P,Planes PL,Flights F, Luggages L
WHERE L.Size>30 AND P.CNP IN (
	SELECT  F.Passenger_id
	FROM Flights F,Planes PL
	WHERE F.Plane_id=PL.P_id AND PL.Model LIKE 'A%'
	)

--passengers that fly in a plane with big consumption but don't FLY TO Madrid
SELECT P.CNP,P.PassengerName 
FROM Passengers P, Flights F, Planes PL
WHERE P.CNP=F.Passenger_id AND F.Plane_id=PL.P_id AND PL.Fuel_consumption>750
EXCEPT
SELECT P.CNP,P.PassengerName 
FROM Passengers P, Flights F
WHERE P.CNP=F.Passenger_id AND F.Destination='madrid'

--passengers that have flown with airbus, but not boeing
SELECT DISTINCT P.CNP,P.PassengerName 
FROM Passengers P, Flights F, Planes PL
WHERE P.CNP=F.Passenger_id AND F.Plane_id=PL.P_id AND PL.Model LIKE 'A%'
		AND P.CNP NOT IN(
			SELECT F.Passenger_id
			FROM Flights F, Planes PL
			WHERE F.Plane_id=PL.P_id AND PL.Model LIKE 'B%'
			)

--MODEL, ACTUAL CONSUMPTION AND DESTINATION OF THE PLANES LEAVING FROM NY
SELECT P.P_id, P.Model, Consumption=F.Length*p.Fuel_consumption/100,f.Destination
FROM Planes P INNER JOIN Flights F ON P.P_id=F.Plane_id
WHERE F.Origin='ny'

--ALL PASS NAME AND ID, FLIGHT DEP AND ARR AND PLANE MODEL(IF KNOWN)
SELECT P.CNP,P.PassengerName,F.Origin,F.Destination,PL.Model
FROM Passengers P INNER JOIN Flights F ON P.CNP=F.Passenger_id LEFT JOIN Planes PL ON F.Plane_id=PL.P_id

--NAME OF RESTAURANT and PASSENGER where poeople from PLANE MODELs eat. To recommend to planes what kind of foods to serve
SELECT  R.Name, P.CNP AS Passenger_CNP, P.PassengerName, PL.Model
FROM Planes PL INNER JOIN Flights F ON PL.P_id=F.Plane_id
	INNER JOIN  Passengers P ON P.CNP=F.Passenger_id
	INNER JOIN Orders O ON O.CNP=P.CNP
	RIGHT JOIN Restaurants R ON R.R_id=O.R_id

--THE NAME OF THE FOODS THAT HAVE DESCRIPTION
SELECT F.Name,O.O_id
FROM Foods F FULL JOIN OrderDetails O ON O.Food_id=F.Food_id 
WHERE F.Description IS NOT NULL
ORDER BY O.O_id

--NAME OF PASS THAT ATE IN 4 OR 5 STAR RESTAURANTS
SELECT P.PassengerName
FROM Passengers P
WHERE P.CNP IN(
	SELECT O.CNP
	FROM Orders O,Restaurants R
	WHERE O.R_id=R.R_id AND (  R.Ranking=4 OR R.Ranking=5))

--NAME OF PASS THAT ORDERED SOME KIND OF FOOD AND THE PRICE
SELECT P.PassengerName
FROM Passengers P
WHERE P.CNP IN(
	SELECT O.CNP
	FROM Orders O,OrderDetails OD
	WHERE O.O_id=OD.O_id AND OD.Food_id IN(
		SELECT O.O_id
		FROM OrderDetails O, Foods F
		WHERE O.Food_id=F.Food_id AND F.Name='CrispyStrips'))

--ALL THE RESTAURANTS WHERE PASSENGERS 111 AND 222 ATE
SELECT * 
FROM Restaurants R
WHERE EXISTS (
	SELECT * 
	FROM Orders O, Passengers P
	WHERE O.CNP=P.CNP AND (O.CNP=111 OR O.CNP=222 ) AND O.R_id=R.R_id)

--ALL THE PASSENGERS THAT ORDERED STH>500
SELECT*
FROM Passengers P
WHERE EXISTS (
	SELECT *
	FROM Orders O
	WHERE O.CNP=P.CNP AND O.Price>500)

--ALL P NAMES THAT FLEW WITH CESSENAS AND WERE THEY LANDED
SELECT DISTINCT P.CNP, P.PassengerName
FROM Passengers P, (SELECT * FROM Flights F, Planes PL WHERE F.Plane_id=PL.P_id AND PL.Model LIKE 'C%') AS CFLIGHTS
WHERE P.CNP=CFLIGHTS.Passenger_id

SELECT P.PassengerName, OR3Stars.Name
FROM  Passengers P, (SELECT R.Name,R.R_id,O.CNP FROM Restaurants R, Orders O WHERE O.R_id=R.R_id AND R.Ranking=3) AS OR3Stars
WHERE P.CNP=OR3Stars.CNP

--CHEAPEST AND MOST EXPENSIVE MEAL FROM EACH RESTAURANT
SELECT R.Name, MIN(O.Price) AS MinPrice, MAX(O.Price) AS MaxPrice
FROM Restaurants R, Orders O
WHERE R.R_id=O.R_id
GROUP BY R.Name

--average spent by EACH PASSENGER WHO HAS PLACED AT LEAST 2 ORDERS
SELECT P.CNP, AVG(O.Price)
FROM Passengers P,Orders O
WHERE P.CNP=O.CNP
GROUP BY P.CNP
HAVING COUNT(*)>=2

--sum of orders placed for each restaurant having at least 2 orders placed
SELECT R.Name, SUM(O.Price)
FROM Orders O, Restaurants R
WHERE O.R_id=R.R_id
GROUP BY R.Name
HAVING 1<(
		SELECT COUNT(*)
		FROM Orders O2,Restaurants R2
		WHERE O2.R_id=R2.R_id AND R2.Name=R.Name)

--NR OF FLIGHTS FOR EACH AIRPLANE HAVING TO DO AT LEAST 3 FLIGHTS
SELECT P.P_id, COUNT(*) AS NoOfImportantFlights
FROM Flights F, Planes P
WHERE F.Plane_id=P.P_id
GROUP BY P.P_id
HAVING 2<(
		SELECT COUNT(*)
		FROM Flights F2, Planes P2
		WHERE F2.Plane_id=P2.P_id AND F2.Plane_id=p.P_id)

--NAME OF PASSENGERS LEAVING FROM BUCHAREST
SELECT P.CNP,PassengerName
FROM Passengers P
WHERE P.CNP= ANY(SELECT	F.Passenger_id	FROM Flights F WHERE F.Origin='BUCHAREST')

--NAME OF PASS THAT HAD AN ORDER WITH PRICE<500$
SELECT P.CNP,PassengerName
FROM Passengers P
WHERE P.CNP!= ALL(SELECT	O.CNP	FROM Orders O WHERE O.Price>500)

--NAME OF PASSENGERS LEAVING FROM BUCHAREST modd
SELECT P.CNP,PassengerName
FROM Passengers P
WHERE P.CNP IN (SELECT	F.Passenger_id	FROM Flights F WHERE F.Origin='BUCHAREST')

--NAME OF PASS THAT HAD AN ORDER WITH PRICE<500$ modd
SELECT P.CNP,PassengerName
FROM Passengers P
WHERE P.CNP NOT IN (SELECT	O.CNP	FROM Orders O WHERE O.Price>500)

--THE RESTAURANT WHICH SELLS THINGS FOR ONLY 66$
SELECT  R.Name
FROM Restaurants R
WHERE R.R_id= ALL(SELECT O.R_id	FROM Orders O WHERE  O.Price=66)

SELECT P.Model
FROM Planes P
WHERE P.P_id=ALL(SELECT F.Plane_id	FROM Flights F WHERE F.Origin='barcelona')

--BIGGEST PURCHASE FOR EACH GUY
SELECT  P.CNP, P.PassengerName, O.Price
FROM Passengers P INNER JOIN Orders O ON P.CNP=O.CNP
WHERE O.Price>ALL(SELECT O2.Price FROM Orders O2 WHERE O2.CNP=P.CNP AND O2.O_id !=O.O_id)
ORDER BY P.CNP

SELECT P.CNP, P.PassengerName, O.Price
FROM Passengers P INNER JOIN Orders O ON P.CNP=O.CNP 
WHERE O.Price=(SELECT	MAX(O2.Price)	FROM Orders O2 WHERE O2.CNP=P.CNP)
ORDER BY P.CNP

--SMALLEST PURCHASE FOR EACH GUY
SELECT  P.CNP, P.PassengerName, O.Price, O.O_id
FROM Passengers P INNER JOIN Orders O ON P.CNP=O.CNP
WHERE O.Price<ALL(SELECT O2.Price FROM Orders O2 WHERE O2.CNP=P.CNP AND O2.O_id !=O.O_id)
ORDER BY P.CNP

SELECT P.CNP, P.PassengerName, O.Price
FROM Passengers P INNER JOIN Orders O ON P.CNP=O.CNP 
WHERE O.Price=(SELECT MIN(O2.Price)	FROM Orders O2 WHERE O2.CNP=P.CNP)
ORDER BY P.CNP

--TOP 3 SMALLEST AND BIGGEST PURCHASES
SELECT TOP(3) P.CNP, P.PassengerName, O.Price
FROM Passengers P INNER JOIN Orders O ON P.CNP=O.CNP
ORDER BY O.Price

SELECT TOP(3) P.CNP, P.PassengerName, O.Price
FROM Passengers P INNER JOIN Orders O ON P.CNP=O.CNP
ORDER BY O.Price DESC


