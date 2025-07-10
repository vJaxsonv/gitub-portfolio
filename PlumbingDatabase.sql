
-- --------------------------------------------------------------------------------
-- Final Project - Physical Database  
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbFixinyerleaks;   -- Get out of the master database
SET NOCOUNT ON;		-- Report only errors

-- --------------------------------------------------------------------------------
-- Drop Tables
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'TJobWorkers' )		IS NOT NULL DROP TABLE TJobWorkers
IF OBJECT_ID( 'TWorkerSkills' )		IS NOT NULL DROP TABLE TWorkerSkills
IF OBJECT_ID( 'TWorkers' )			IS NOT NULL DROP TABLE TWorkers
IF OBJECT_ID( 'TSkills' )			IS NOT NULL DROP TABLE TSkills

IF OBJECT_ID( 'TJobMaterials' )		IS NOT NULL DROP TABLE TJobMaterials
IF OBJECT_ID( 'TMaterials')			IS NOT NULL DROP TABLE TMaterials
IF OBJECT_ID( 'TVendors' )			IS NOT NULL DROP TABLE TVendors

IF OBJECT_ID( 'TJobs' )				IS NOT NULL DROP TABLE TJobs
IF OBJECT_ID( 'TCustomers' )		IS NOT NULL DROP TABLE TCustomers
IF OBJECT_ID( 'TServices' )			IS NOT NULL DROP TABLE TServices
IF OBJECT_ID( 'TStates' )			IS NOT NULL DROP TABLE TStates
IF OBJECT_ID( 'TStatuses' )			IS NOT NULL DROP TABLE TStatuses


-- --------------------------------------------------------------------------------
-- Create Database  
-- --------------------------------------------------------------------------------

CREATE TABLE TJobs
(
	 intJobID							INTEGER				NOT NULL
	,intCustomerID						INTEGER				NOT NULL
	,intStatusID						INTEGER				NOT NULL
	,intServiceID						INTEGER				NOT NULL
	,dtmStartDate						DATE				NOT NULL
	,dtmEndDate							DATE				NOT NULL
	,strJobDesc							VARCHAR(8000)		NOT NULL
	,CONSTRAINT TJobs_PK				PRIMARY KEY ( intJobID )
)

CREATE TABLE TCustomers
(
	  intCustomerID						INTEGER				NOT NULL
	 ,strFirstName						VARCHAR(255)		NOT NULL
	 ,strLastName						VARCHAR(255)		NOT NULL
	 ,strAddress						VARCHAR(255)		NOT NULL
	 ,strCity							VARCHAR(255)		NOT NULL
	 ,intStateID						INTEGER				NOT NULL
	 ,strZip							VARCHAR(255)		NOT NULL
	 ,strPhoneNumber					VARCHAR(255)		NOT NULL
	 ,strEmailAddress					VARCHAR(255)		NOT NULL
	 ,CONSTRAINT TCustomer_PK			PRIMARY KEY ( intCustomerID )
)

CREATE TABLE TStatuses
(
	 intStatusID						INTEGER				NOT NULL
	,strStatus							VARCHAR(255)		NOT NULL
	,CONSTRAINT TStatuses_PK			PRIMARY KEY ( intStatusID )
)

CREATE TABLE TJobMaterials
(
	 intJobMaterialID					INTEGER				NOT NULL
	,intJobID							INTEGER				NOT NULL
	,intMaterialID						INTEGER				NOT NULL
	,intQuantity						INTEGER				NOT NULL
	,CONSTRAINT TCustomerJobMaterials_PK PRIMARY KEY ( intJobMaterialID )
)

CREATE TABLE TMaterials
(
	 intMaterialID						INTEGER				NOT NULL
	,strDescription						VARCHAR(255)		NOT NULL
	,monRetailCost						MONEY				NOT NULL
	,monWholeSaleCost					MONEY				NOT NULL
	,intVendorID						INTEGER				NOT NULL
	,CONSTRAINT TMaterials_PK			PRIMARY KEY ( intMaterialID )
)

CREATE TABLE TVendors
(
	 intVendorID						INTEGER				NOT NULL
	,strVendorName						VARCHAR(255)		NOT NULL
	,strAddress							VARCHAR(255)		NOT NULL
	,strCity							VARCHAR(255)		NOT NULL
	,intStateID							INTEGER				NOT NULL
	,strZip								VARCHAR(255)		NOT NULL
	,strPhoneNumber						VARCHAR(255)		NOT NULL
	,CONSTRAINT TVendors_PK				PRIMARY KEY ( intVendorID )
)

CREATE TABLE TJobWorkers
(
	 intJobWorkerID						INTEGER				NOT NULL
	,intJobID							INTEGER				NOT NULL
	,intWorkerID						INTEGER				NOT NULL
	,intHoursWorked						INTEGER				NOT NULL
	,CONSTRAINT TCustomerJobWorkers_PK	PRIMARY KEY ( intJobWorkerID )
)

CREATE TABLE TWorkers
(
	 intWorkerID						INTEGER				NOT NULL
	 ,strFirstName						VARCHAR(255)		NOT NULL
	 ,strLastName						VARCHAR(255)		NOT NULL
	 ,strAddress						VARCHAR(255)		NOT NULL
	 ,strCity							VARCHAR(255)		NOT NULL
	 ,intStateID						INTEGER				NOT NULL
	 ,strZip							VARCHAR(255)		NOT NULL
	 ,strPhoneNumber					VARCHAR(255)		NOT NULL
	 ,dtmHireDate						DATE				NOT NULL
	 ,dtmTerminationDate				DATE				NOT NULL
	 ,monPayRate						MONEY				NOT NULL
	 ,monBillingRate					MONEY				NOT NULL
	 ,CONSTRAINT TWorkers_PK			PRIMARY KEY ( intWorkerID )
)

CREATE TABLE TWorkerSkills
(
	 intWorkerSkillID					INTEGER				NOT NULL
	,intWorkerID						INTEGER				NOT NULL
	,intSkillID							INTEGER				NOT NULL
	,CONSTRAINT	TWorkerSkills_PK		PRIMARY KEY ( intWorkerSkillID )
)

CREATE TABLE TSkills
(
	 intSkillID							INTEGER				NOT NULL
	,strSkill							VARCHAR(255)		NOT NULL
	,CONSTRAINT TSkills_PK				PRIMARY KEY ( intSkillID )
)

CREATE TABLE TStates
(
	 intStateID							INTEGER				NOT NULL
	,strState							VARCHAR(255)		NOT NULL
	,CONSTRAINT TStates_PK				PRIMARY KEY ( intStateID )
)

CREATE TABLE TServices
(
	 intServiceID						INTEGER				NOT NULL
	,strService							VARCHAR(255)		NOT NULL
	,CONSTRAINT TServices_PK			PRIMARY KEY ( intServiceID )
)

-- --------------------------------------------------------------------------------
-- Establish Referential Integrity  
-- --------------------------------------------------------------------------------
--
-- #	Child							Parent							Column
-- -	-----							------							---------
-- 1	TJobs							TCustomers						intCustomerID    
-- 2	TJobs							TStatuses						intStatusID  

-- 3	TCustomers						TStates							intStateID  

-- 4	TJobMaterials					TJobs							intJobID 
-- 5	TJobMaterials					TMaterials						intMaterialID  

-- 6	TMaterials						TVendors						intVendorID  

-- 7	TVendors						TStates							intStateID   

-- 8	TJobWorkers						TJobs							intJobID  
-- 9	TJobWorkers						TWorkers						intWorkerID  

-- 10	TWorkers						TStates							intStateID   

-- 11	TWorkerSkills					TWorkers						intWorkerID   
-- 12	TWorkerSkills					TSkills							intSkillID   

-- 13	TJobs							TServices						intServiceID

-- 1
ALTER TABLE TJobs ADD CONSTRAINT TJobs_TStatuses_FK
FOREIGN KEY ( intStatusID ) REFERENCES TStatuses ( intStatusID )

-- 2
ALTER TABLE TJobs ADD CONSTRAINT TJobs_TCustomers_FK
FOREIGN KEY ( intCustomerID ) REFERENCES TCustomers ( intCustomerID )

-- 3
ALTER TABLE TCustomers ADD CONSTRAINT TCustomers_TStates_FK
FOREIGN KEY ( intStateID ) REFERENCES TStates ( intStateID )

-- 4
ALTER TABLE TJobMaterials ADD CONSTRAINT TJobMaterials_TJobs_FK
FOREIGN KEY ( intJobID ) REFERENCES TJobs ( intJobID )

-- 5
ALTER TABLE TJobMaterials ADD CONSTRAINT TJobMaterials_TMaterials_FK
FOREIGN KEY ( intMaterialID ) REFERENCES TMaterials ( intMaterialID )

-- 6
ALTER TABLE TMaterials ADD CONSTRAINT TMaterials_TVendors_FK
FOREIGN KEY ( intVendorID ) REFERENCES TVendors ( intVendorID )

-- 7
ALTER TABLE TVendors ADD CONSTRAINT TVendors_TStates_FK
FOREIGN KEY ( intStateID ) REFERENCES TStates ( intStateID )

-- 8
ALTER TABLE TJobWorkers ADD CONSTRAINT TJobWorkers_TJobs_FK
FOREIGN KEY ( intJobID ) REFERENCES TJobs ( intJobID )

-- 9
ALTER TABLE TJobWorkers ADD CONSTRAINT TJobWorkers_TWorkers_FK
FOREIGN KEY ( intWorkerID ) REFERENCES TWorkers ( intWorkerID )

-- 10
ALTER TABLE TWorkers ADD CONSTRAINT TWorkers_TStates_FK
FOREIGN KEY ( intStateID ) REFERENCES TStates ( intStateID )

-- 11
ALTER TABLE TWorkerSkills ADD CONSTRAINT TWorkerskills_TWorkers_FK
FOREIGN KEY ( intWorkerID ) REFERENCES TWorkers ( intWorkerID )

-- 12
ALTER TABLE TWorkerSkills ADD CONSTRAINT TWorkerskills_TSkills_FK
FOREIGN KEY ( intSkillID ) REFERENCES TSkills ( intSkillID )

-- 13
ALTER TABLE TJobs ADD CONSTRAINT TJobs_TServices_FK
FOREIGN KEY ( intServiceID ) REFERENCES TServices ( intServiceID )


-- --------------------------------------------------------------------------------
-- Add Records into Skills
-- --------------------------------------------------------------------------------
INSERT INTO TSkills ( intSkillID, strSkill )
VALUES	 ( 1, 'Pipe Fitting' )
		,( 2, 'Welding' )
		,( 3, 'General Plumbing' )
		,( 4, 'Sewer Cleanout')
		,( 5, 'Plumbing Design')


-- --------------------------------------------------------------------------------
-- Add Records into Statuses
-- --------------------------------------------------------------------------------
INSERT INTO TStatuses ( intStatusID, strStatus )
VALUES	 ( 1, 'Open' )
		,( 2, 'In Process' )
		,( 3, 'Complete' )
		
-- --------------------------------------------------------------------------------
-- Add Records into States
-- --------------------------------------------------------------------------------
INSERT INTO TStates ( intStateID, strState )
VALUES	 ( 1, 'Ohio' )
		,( 2, 'Kentucky' )
		,( 3, 'Indiana' )

-- --------------------------------------------------------------------------------
-- Add Records into Services
-- --------------------------------------------------------------------------------
INSERT INTO TServices ( intServiceID, strService)
VALUES	 ( 1, 'Installation, Inspection, Replacement' )
		,( 2, 'Toilet Repair' )
		,( 3, 'Leak Repair' )
		,( 4, 'Drain Cleaning' )
		,( 5, 'Pipe Repair and Replacement' )
		,( 6, 'Sewer Repair' )
		,( 7, 'Water Heater Services' )

-- --------------------------------------------------------------------------------
-- Add Records into Customers
-- --------------------------------------------------------------------------------
INSERT INTO TCustomers( intCustomerID, strFirstName, strLastName, strAddress, strCity, intStateID, strZip, strPhoneNumber, strEmailAddress )
VALUES	 ( 1, 'Bob', 'Nields', '8741 Rosebrook Drive', 'Cincinnati', 1, '41042', '5137602063', 'bnields@gmail.com')
		,( 2, 'Jay', 'Graue', '1111 SHDHS Drive', 'Florence', 2, '41042', '8597602222', 'jgraue@gmail.com')
		,( 3, 'Mary', 'Beimesch', '4444 Tobertge Drive', 'Cincinnati', 1, '41012', '5137603333', 'mb@gmail.com')
		,( 4, 'Tony', 'Hardan', '3222 Main Street', 'Ft. Thomas', 2, '41018', '8592222063', 'thardon@gmail.com')
		,( 5, 'Iwana', 'Bucks', '2442 Track', 'Cincinanti', 1, '41018', '5132222363', 'iwana@gmail.com')
		,( 6, 'Sydney', 'Nye', '1111 SHDHS Drive', 'Florence', 2, '41042', '8597702222', 'snye@gmail.com')
		,( 7, 'Libby', 'Leedom', '4444 Tobertge Drive', 'Hebron', 2, '41012', '8597603533', 'll@gmail.com')
		,( 8, 'Lee', 'Ransdell', '2221 Main Street', 'Cincinnati', 1, '41018', '5132222663', 'leer@gmail.com')
		,( 9, 'Mike', 'Driscoll', '2221 Track', 'Aurora', 3, '41018', '8122222963', 'md@gmail.com')
		,( 10, 'Tom', 'Ruberg', '2212 Main Street', 'Ft. Thomas', 2, '41018', '8592222093', 'rubergt@gmail.com')
		
-- --------------------------------------------------------------------------------
-- Add Records into Jobs  - NOTE: 1/1/2099 means the job has not completed 
-- --------------------------------------------------------------------------------
INSERT INTO TJobs ( intJobID, intCustomerID ,intStatusID, intServiceID, dtmStartDate, dtmEndDate, strJobDesc)
VALUES	 ( 1, 1, 2, 1, '12/06/2022', '01/01/2099', 'New Hot Water Heater' )
		,( 2, 2, 3, 3, '1/1/2022', '2/1/2022', 'Leaky faucet' )
		,( 3, 2, 3, 4, '10/1/2021', '10/2/2021', 'Clogged Dish Washer' )
		,( 4, 3, 3, 1, '3/1/2021', '3/1/2021', 'New toilet' )
		,( 5, 4, 1, 1, '12/6/2022', '1/1/2099', 'Kitchen Remodel')
		,( 6, 6, 3, 5,  '9/2/2022', '9/3/2022', 'Busted Pipe')
		,( 7, 6, 3, 7, '7/3/2022', '7/4/2022', 'Hot Water Heater Emergency')
		,( 8, 8, 2, 1, '12/3/2022', '1/1/2099', 'New House Plumbing Install')
		,( 9, 9, 1, 6, '12/7/2022', '1/1/2099', 'Toilet Overflow')
		,( 10, 9, 3, 1, '7/1/2021', '7/1/2021', 'Install Water Softener')
		,( 11, 10, 2, 5, '12/7/2022', '1/1/2099', 'Frozen Pipes')
		,( 12, 1, 3, 1, '6/7/2022', '6/9/2022', 'Bathroom Remodel')
		,( 13, 1, 3, 3, '5/7/2022', '6/9/2022', 'Shower Head Leak')

		 
-- --------------------------------------------------------------------------------
-- Add Records into Vendors
-- --------------------------------------------------------------------------------
INSERT INTO TVendors ( intVendorID, strVendorName, strAddress, strCity, intStateID, strZip, strPhoneNumber )
VALUES	 ( 1, 'Plumbing R Us', '888 Industrial Road', 'Covington', 2, '43033', '8597603311' )
		, ( 2, 'Supplies for Water', '666888 Flood Road', 'Cincinnati', 1, '43033', '5137701111' )
		, ( 3, 'Stuff for Outhouse', '88844 Smelly Ct', 'Cincinnati', 1, '43033', '5137603311' )
		, ( 4, 'Heaters for Water', '8844 HotWater Ct', 'Cincinnati', 1, '43033', '5137605511' )

-- --------------------------------------------------------------------------------
-- Add Records into Materials (NOTE:  retail cost is what is charged to customer.
--  wholesale cost is how much vendor charges Fixenyerleaks 
-- --------------------------------------------------------------------------------
INSERT INTO TMaterials ( intMaterialID, strDescription, monRetailCost, monWholesaleCost, intVendorID )
VALUES	 ( 1, '3 ft Copper Pipe', 5.00, 3.00, 1)
		,( 2, '5 ft Cooper Pipe', 7.00, 5.00, 1)
		,( 3, '10 ft Cooper Pipe', 10.00, 5.00, 1)
		,( 4, 'Copper Elbow', 1.00, .50, 1)
		,( 5, '10 Ft PVC Drain Pipe', 7.00, 3.00, 2)
		,( 6, 'PVC Drain Elbow', 10.00, 7.00, 2)
		,( 7, 'Toilet', 75.00, 35.00, 3)
		,( 8, 'Bidet', 125.00, 75.00, 3)
		,( 9, '5 foot Chrome Pipe', 15.00, 8.00, 3)
		,(10, 'Chrome Elbow', 10.00, 6.00, 3)
		,(11, '100 Gallon Hot Water Heater', 650.00, 400.00, 4)
		,(12, '50 Gallon Hot Water Heater', 500.00, 300.00, 4)
		,(13, 'Tankless Hot Water Heater', 1650.00, 1000.00, 4)
		,(14, '1/2" Washer', .50, .25, 1)
		,(15, '1" Washer', .75, .50, 1)
		,(16, '1/4" Washer', .25, .10, 1)
		,(17, 'Water Softener', 700.00, 250.00, 4)

-- --------------------------------------------------------------------------------
-- Add Records into Type of Workers  -- if not terminated then date is 1/1/2099
-- --------------------------------------------------------------------------------
INSERT INTO TWorkers ( intWorkerID, strFirstName, strLastName, strAddress, strCity, intStateID, strZip, strPhoneNumber, dtmHireDate, dtmTerminationDate, monBillingRate, monPayRate )
VALUES	 ( 1, 'Buck', 'Crac', '8888 Leaky Lane', 'Florence', 2, '41042', '8596664444', '11/1/2021', '01/01/2099', 50.00, 30.00)
        ,( 2, 'Sloe', 'Dripper', '8888 CloggedUp Lane', 'Cincinnati', 1, '41052', '5136664444', '1/1/2021', '01/01/2099', 40.00, 25.00)
		,( 3, 'Iwanna', 'Washer', '8448 Bonedry Road', 'Cincinnati', 1, '41052', '5135664444', '1/1/2000', '12/01/2021', 75.00, 50.00)
		,( 4, 'Bob', 'Onwattier', '8348 Mildduex Court', 'Erlanger', 1, '41032', '8595664444', '1/1/2010', '01/01/2099', 75.00, 50.00)
		,( 5, 'Bloke', 'Enpipe', '88 CewerlineCourt', 'Cincinnati', 2, '41032', '5135666644', '1/1/2010', '01/01/2099', 75.00, 50.00)
		,( 6, 'Steedy', 'Flough', '88 Outofnames Lane', 'Cincinnati', 2, '41032', '5135666644', '1/1/2000', '10/01/2021', 100.00, 75.00)
		,( 7, 'Lacky', 'Schills', '777 Loser Lane', 'Erlanger', 2, '41032', '5135666644', '1/1/2000', '10/01/2021', 40.00, 25.00)
		
-- --------------------------------------------------------------------------------
-- Add Records into JobWorkers
-- --------------------------------------------------------------------------------
INSERT INTO TJobWorkers (intJobWorkerID, intJobID, intWorkerID, intHoursWorked)
VALUES	 ( 1, 1, 1, 5)
		,( 2, 1, 4, 5)
		,( 3, 2, 5, 2)
		,( 4, 3, 3, 6)
		,( 5, 4, 6, 5)
		,( 6, 6, 1, 2)
		,( 7, 7, 5, 4)
		,( 8, 8, 2, 8)
		,( 9, 8, 4, 12)
		,( 10, 8, 1, 4)
		,( 11, 10, 6, 5)
		,( 12, 11, 4, 2)
		,( 13, 12, 2, 7)
		,( 14, 12, 1, 8)
		,( 15, 13, 1, 12)

-- --------------------------------------------------------------------------------
-- Add Records into WorkerSkills
-- --------------------------------------------------------------------------------
INSERT INTO TWorkerSkills (intWorkerSkillID, intWorkerID, intSkillID)
VALUES	 ( 1, 1, 1)
		,( 2, 1, 4)
		,( 3, 1, 3)
		,( 4, 1, 2)
		,( 5, 2, 3)
		,( 6, 2, 1)
		,( 7, 3, 5)
		,( 8, 3, 1)
		,( 9, 3, 3)
		,( 10, 4, 2)
		,( 11, 4, 3)
		,( 12, 4, 4)
		,( 13, 5, 5)
		,( 14, 5, 3)
		,( 15, 5, 1)
		,( 16, 5, 2)
		,( 17, 6, 1)
		,( 18, 6, 2)
		,( 19, 6, 5)

-- --------------------------------------------------------------------------------
-- Add Records into JobMaterials
-- --------------------------------------------------------------------------------
INSERT INTO TJobMaterials (intJobMaterialID, intJobID, intMaterialID, intQuantity)
VALUES	 ( 1, 1, 11, 1)
		,( 2, 1, 2, 3)
		,( 3, 1, 4, 5)
		,( 4, 1, 14, 6)
		,( 5, 2, 16, 2)
		,( 6, 4, 7, 1)
		,( 7, 4, 15, 4)
		,( 8, 5, 3, 8)
		,( 9, 5, 5, 5)
		,( 10, 5, 14, 14)
		,( 11, 5, 4, 10)
		,( 12, 6, 1, 1) 
		,( 13, 7, 12, 1)
		,( 14, 7, 2, 2)
		,( 15, 7, 14, 8)
		,( 16, 8, 3, 40)
		,( 17, 8, 11, 1) 
		,( 18, 8, 4, 40)
		,( 19, 8, 7, 3) 
		,( 20, 8, 10, 3)
		,( 21, 8, 8, 1)
		,( 22, 8, 9, 6)
		,( 23, 8, 14, 60)  
		,( 24, 10, 17, 1)
		,( 25, 10, 3, 1)
		,( 26, 12, 7, 1) 
		,( 27, 12, 8, 1)  
		,( 28, 12, 3, 10) 
		,( 29, 12, 14, 20) 
		,( 30, 12, 9, 1)
		,( 31, 12, 10, 1)  



-- 1.	Write a query to list all jobs that are in process. Include the Job ID and Description, 
-- Customer ID and name, and the start date. Order by the Job ID.   (Difficulty Level: #1) Simple Table

Select TC.intCustomerID, TC.strFirstName, TC.strLastName, TJ.intJobID, TJ.strJobDesc
From TCustomers as TC Join TJobs as TJ
	on TC.intCustomerID = TJ.intCustomerID
 Join TStatuses  as TS
	on TJ.intStatusID = TS.intStatusID
Where TS.intStatusID = 2 
Order By TJ.intJobID

--2.	Write a query to list all complete jobs for Sydney Nye and the materials used on each job. Include the quantity, the individual material cost,
-- and total cost for each material on each job. Order by Job ID and material ID.  (Difficulty Level: #2) Simple Table, Aggregate

Select TM.intMaterialID, TJ.intjobID, TM.strDescription, TM.monRetailCost, Sum(TM.monRetailCost* TJM.intQuantity) as TotalCost
From TJobs as TJ Join TCustomers as TC
	on TJ.intCustomerID = TC.intCustomerID
	Join TJobMaterials as TJM
	on TJ.intJobID = TJM.intJobID
	Join TMaterials as TM 
	on TJM.intMaterialID = TM.intMaterialID
Where TC.strFirstName = 'sydney' and TC.strLastName = 'nye' and TJ.intStatusID = 3
Group By TJ.intJobID, TM.strDescription, TM.monRetailCost , TM.intMaterialID
Order by TJ.intJobID, TM.intMaterialID

--3 Write a query to list the total cost for all materials for each completed job for all customers.  (Difficulty Level: #1) Simple Table Aggregate, Where, Group By

Select TJ.intJobID, Sum (TM.monRetailCost* TJM.intQuantity) as TotalCost
From TCustomers as TC Join TJobs as TJ 
	on TC.intCustomerID = TJ.intCustomerID
	Join TStatuses as TS 
	on TS.intStatusID = TJ.intStatusID
	Join TJobMaterials as TJM
	on TJ.intJobID = TJM.intJobID
	Join TMaterials as TM
	on TM.intMaterialID = TJM.intMaterialID
Where TJ.intStatusID = 3
Group By TJ.intJobID

--4 	Write a query to list First Name, Last Name, and Termination Date of all workers whose 
--      employment ended in the 2021 and the total jobs they worked on during that year. (Difficulty Level: #2) Simple Join, Aggreage

Select TW.strFirstName, TW.strLastName, TW.dtmTerminationDate, Count (TJ.intJobID) as TotalJobs
From Tworkers as TW Join TJobWorkers as TJW
	on TW.intWorkerID = TJW.intWorkerID
	Join TJobs as TJ 
	on TJ.intJobID = TJW.intJobID
Where dtmTerminationDate between '2021-01-01' and '2021-12-31'
Group By TW.strFirstName, TW.strLastName, TW.dtmTerminationDate



--6 	Write a query that lists all materials that have not been used on any jobs. 
--Include Material ID and Description. Order by Material ID.  (Difficulty Level: #1) Simple Join

Select TM.intMaterialID, TM.strDescription
From TMaterials as TM Left Join TJobMaterials as TJM 
	on TM.intMaterialID = TJM.intMaterialID
Where TJM.intMaterialID IS NULL
Order By TM.intMaterialID

--7 	Write a query that list all customers (once) from the 513-area code whose jobs were worked on by currently employed workers
--whose skills include “pipe fitting”.  (Difficulty Level: #1) Simple Join, Where, Like
Select Distinct TC.strFirstName, TC.strLastName
From TCustomers as TC Join TJobs as TJ 
	on TC.intCustomerID = TJ.intCustomerID
	Join TJobWorkers as TJW 
	on TJ.intJobID = TJW.intJobID
	Join TWorkers as TW 
	on TJW.intWorkerID = TW.intWorkerID
	Join TworkerSkills as TWS
	on TWS.intWorkerID = TW.intWorkerID
	Join TSkills as TS
	on TS.intSkillID = TWS.intSkillID
	Join TStatuses as TST
	on TST.intStatusID = TJ.intStatusID
WHERE TC.strPhoneNumber Like '513%'
  AND TS.strSkill = 'pipe fitting'
  and TST.intStatusID = 2

--8.	Create a query that lists all workers with a skill of welding, their hire date, and the total number of jobs that they worked on.
--List the Skill ID and description with each row. Order by Worker ID.  (Difficulty Level: #1) Simple Join, Aggregate, Group By
  
Select Distinct TW.intWorkerID, TW.strFirstName, TW.strLastName, TW.dtmHireDate, TS.intSkillID, TS.strSkill, Count (TJ.intJobID) as TOTALJOBS
From TWorkers as TW Join TWorkerSkills as TWS
		on TW.intWorkerID = TWS.intWorkerID
	Join TSkills as TS
		on TS.intSkillID = TWS.intSkillID
	Join TJobWorkers as TJW
		on TJW.intWorkerID = TW.intWorkerID
	Join Tjobs as TJ
		on TJ.intJobID = TJW.intJobID
Where TS.strSkill = 'welding'
Group By TW.strFirstName, TW.strLastName, TW.dtmHireDate, TS.intSkillID, TS.strSkill, TW.intWorkerID
Order by TW.intWorkerID

--9.	Create a query that lists all workers that worked 15 or more hours for all jobs they worked on. 
--Include the Worker ID and name, number of hours worked, and number of jobs that they worked on. Order by Worker ID.  (Difficulty Level: #1) Simple Join, Group by, Aggregate, Having

Select TW.intWorkerID, TW.strFirstName, TW.strLastName
		, Sum (TJW.intHoursWorked) as HoursWorked
		, Count(TJ.intJobID) as TotalJobs
From TWorkers as TW Join TJobWorkers as TJW
			on TW.intWorkerID = TJW.intWorkerID
		Join Tjobs as TJ 
			on TJ.intJobID = TJW.intJobID
Group By TW.intWorkerID, TW.strFirstName, TW.strLastName
Having Sum(TJW.intHoursWorked) >= '15'
Order By TW.intWorkerID

--10. 	Write a query that will show Customers that had repeating services throughout the year of 2022. 
--Show the customer name, service, and how many times they had the service.   (Difficulty Level: #2) Simple Join, Were, having, Aggregate

Select  TC.strFirstName, TC.strLastName, TS.strService 
		,Count(TS.intServiceID) as ServiceTimes
From	TCustomers as TC Join TJobs as TJ
			on TC.intCustomerID = TJ.intCustomerID
		Join TServices as TS
			on TS.intServiceID = TJ.intServiceID
Where TJ.dtmStartDate between '2022-01-01' and '2022-12-31'
Group By TC.strFirstName, TC.strLastName, TS.strService
Having Count(TS.intserviceID)> 1

--11.	Write a query that lists all customers who are located on 'Main Street'. 
--Include the customer Id and full address. Order by Customer ID.  (Difficulty Level: #1)

Select TC.intCustomerID, TC.strAddress, TC.strCity, TS.strState, TC.strZip
From TCustomers as TC Join TStates as TS
		on TC.intStateID = TS.intStateID
Where strAddress like '%Main Street'

--12 	Write a query to list completed jobs that started and ended in the same month. List Job, Job Status, Start Date and End Date.  
--NOTE:  This should be for all months.  Not a specific month.  
--To complete this query, you can use the function MONTH (Use w3schools for assistance).  (Difficulty Level: #3)

Select TJ.intJobID, TS.strStatus, TJ.dtmStartDate, TJ.dtmEndDate
From TJobs as TJ Join TStatuses as TS
		on TJ.intStatusID = TS.intstatusID
Where TS.intStatusID = 3
	and MONTH (TJ.dtmStartDate) = MONTH (Tj.dtmEndDate)
Group By TJ.intJobID, TS.strStatus, TJ.dtmStartDate, TJ.dtmEndDate

--13 	Create a query to list workers that worked on three or more jobs for the same customer.   
--List Workers Name, Customer Name, and the Amount of Jobs. (Difficulty Level: #1) Simple Join, Aggregate, Having

Select TW.strFirstName, TW.strLastName, TC.strLastName as CustomerLastName, 
		Count(TJ.intJobID) as TotalJobs
From TWorkers as TW JOIn TJobWorkers as TJW
		on TW.intWorkerID = TJW.intWorkerID
	Join Tjobs as TJ
		on TJ.intJobID = TJW.intJobID
	Join TCustomers as TC
		on TC.intCustomerID = TJ.intCustomerID
Group by TW.strFirstName, TW.strLastName, TC.strLastName
having Count( Tj.intJobID) > 2 

--14.	Create a query to list all workers and their total # of skills.  
--Any worker with no skills should be included with a total number of skills = 0. 
--Order by Worker ID.   List Worker’s Name and Total # of Skills. (Difficulty Level: #1) Outer Join, aggregate

Select TW.intWorkerID as ID, Tw.strFirstName, TW.strLastName, Count (TS.intSkillID) as TotalSkills
From TWorkers as TW Left Join TWorkerSkills as TWS
		on TW.intWorkerID = TWS.intWorkerID
	Left Join TSkills as TS
		on TWS.intSkillID = TS.intSkillID
Group By Tw.strFirstName, TW.strLastName, TW.intWorkerID
Order By TW.intWorkerID

--15.	Write a query that will show total jobs per service.  
--If a service did not have jobs associated with it, total jobs will be 0.   
--List Service and Total Jobs for that Service. (Difficulty Level: #1) AAggregate, Outer Join

Select TS.strService, COUNT (TJ.intJobID) as TotalJobs
From TJobs as TJ right Join TServices as TS
		on TJ.intServiceID = TS.intServiceID
Group By TS.strService

-- 16.	Write a query to list the total Charge to the customer for all jobs completed in 2022. 
--Calculate the total charge to the customer as the total cost of materials + total Labor costs + 30% Profit. 
--List Customer, JobID, and Total Charge.  (Difficulty Level: #3) Simple Join, Aggregate, where

Select TC.strFirstName, TC.strLastName, Tj.intJobID, 
(Sum(Tm.monRetailCost * TJM.intQuantity) + Sum (TW.monBillingRate *TJW.intHoursWorked)) * 1.3 as TotalCharge 
From TCustomers as TC Join TJobs as TJ
		on TC.intCustomerID = TJ.intCustomerID
	Join TJobMaterials as TJM
		on TJM.intJobID = TJ.intJobID
	Join TJobWorkers as TJW
		on TJ.intJobID = TJW.intJobID
	Join TWorkers as TW
		on TW.intWorkerID = TJW.intWorkerID
	Join TMaterials as TM
		on TJM.intMaterialID = TM.intMaterialID
Where TJ.dtmEndDate between '2022/01/01' and '2022/12/31'
Group By TC.strFirstName, TC.strLastName, Tj.intJobID

--17 	Write a query that totals what is owed to each vendor for a JOBID #8. (Difficulty Level: #2) Outer Join where clause

Select TV.strVendorName, Sum (TM.monWholeSaleCost*TJM.intQuantity) as TotalOwed
From TJobs as TJ Join TJobMaterials as TjM
		on TJ.intJobID = TJM.intJobID
	Join TMaterials as TM
		on TM.intMaterialID = TJM.intMaterialID
	Join TVendors as TV
		on TM.intVendorID = TV.intVendorID
Where TJ.intJobID = 8
Group By Tv.strVendorName, TV.intVendorID

--19 Write a query that shows the different services that ‘Bloke Enpipe’ worked on.  Ensure the service only shows once. (Difficulty Level: #1)
Select Distinct TS.strService
From TWorkers as TW Join TJobWorkers as TJW
		on TW.intWorkerID = TJW.intWorkerID
	Join TJobs as TJ
		on TJ.intJobID = TJW.intJobID
	Join TServices as TS
		on TJ.intServiceID = TS.intServiceID
Where TW.strFirstName = 'Bloke'