--CREATE DATABASE 
CREATE DATABASE Prescription_System;
--USE IT 
USE Prescription_System;
--CREATE SCHEMA 
CREATE SCHEMA Barwon;
-- CREATE PATIENT TABLE
CREATE TABLE Barwon.PATIENT (
    UR_NUMBER INT Identity PRIMARY KEY,
    NAME VARCHAR(100),
    ADDRESS VARCHAR(100),
    AGE INT,
    PHONE VARCHAR(15),
    EMAIL VARCHAR(100),
	MED_CARD_NUM VARCHAR(20)
);
-- CREATE DOCTOR TABLE
CREATE TABLE Barwon.DOCTOR (
    DOCTOR_ID INT identity PRIMARY KEY,
    NAME VARCHAR(100),
    SPECIALTY VARCHAR(100),
    PHONE VARCHAR(20),
    EMAIL VARCHAR(100),
	EXPERIENCE VARCHAR(100)
);
-- CREATE PATIENT_DOCTOR TABLE  (Many-to-Many Relationship)
CREATE TABLE Barwon.PATIENT_DOCTOR (
    DOCTOR_ID INT,
    UR_NUMBER INT,
    PRIMARY KEY (DOCTOR_ID, UR_NUMBER),										--COMPOSITE PK
    FOREIGN KEY (DOCTOR_ID) REFERENCES Barwon.DOCTOR(DOCTOR_ID),
    FOREIGN KEY (UR_NUMBER ) REFERENCES Barwon.PATIENT(UR_NUMBER)
);
--  CREATE PRESCRIPTION TABLE 
CREATE TABLE Barwon.PRESCRIPTION (
    PRESCRIPTION_ID INT IDENTITY PRIMARY KEY,
    DATE DATE,
    QUANTITY INT,
    UR_NUMBER INT,
    FOREIGN KEY (UR_NUMBER) REFERENCES Barwon.PATIENT(UR_NUMBER)   
);

-- CREATE DOCTOR_PRESCRIPTION TABLE    (Many-to-Many Relationship)
CREATE TABLE Barwon.DOCTOR_PRESCRIPTION (
    DOCTOR_ID INT,
    PRESCRIPTION_ID INT,
    PRIMARY KEY (DOCTOR_ID, PRESCRIPTION_ID),									--COMPOSITE PK
    FOREIGN KEY (DOCTOR_ID) REFERENCES Barwon.DOCTOR(DOCTOR_ID),
    FOREIGN KEY (PRESCRIPTION_ID) REFERENCES Barwon.PRESCRIPTION(PRESCRIPTION_ID)
);

--  CREATE DRUGS TABLE
CREATE TABLE Barwon.DRUGS (
    DRUG_ID INT identity PRIMARY KEY,
    STRENGTH VARCHAR(100),
    TRADE_NAME VARCHAR(100)
);

--  CREATE PHARMACEUTICAL_COMPANY TABLE
CREATE TABLE Barwon.PHARMACEUTICAL_COMPANY (
    COMPANY_NAME VARCHAR(100) PRIMARY KEY,
    ADDRESS VARCHAR(100),
    PHONE VARCHAR(15)
);

-- CREATE PRESCRIPTION_DRUG TABLE	(Many-to-Many Relationship)
CREATE TABLE Barwon.PRESCRIPTION_DRUG (
    DRUG_ID INT,
    PRESCRIPTION_ID INT,
    PRIMARY KEY (DRUG_ID, PRESCRIPTION_ID),
    FOREIGN KEY (DRUG_ID) REFERENCES Barwon.DRUGS(DRUG_ID),
    FOREIGN KEY (PRESCRIPTION_ID) REFERENCES Barwon.PRESCRIPTION(PRESCRIPTION_ID)
);

-- TABLE PRESCRIPTION_COMPANY (Many-to-Many Relationship)
CREATE TABLE Barwon.DRUG_COMPANY (
    COMPANY_NAME VARCHAR(100),
    DRUG_ID INT,
    PRIMARY KEY (COMPANY_NAME, DRUG_ID),
    FOREIGN KEY (COMPANY_NAME) REFERENCES Barwon.PHARMACEUTICAL_COMPANY(COMPANY_NAME),
    FOREIGN KEY (DRUG_ID) REFERENCES Barwon.DRUGS(DRUG_ID)
	ON DELETE CASCADE,
);

---------------------------------------------------------------------------------------------------------------------------
--	QUERIES

---- 1. SELECT: Retrieve all columns from the Doctor table.
SELECT * 
FROM Barwon.DOCTOR

---- 2. ORDER BY: List patients in the Patient table in ascending order of their ages.
SELECT * 
FROM Barwon.PATIENT
ORDER BY AGE ASC;

---- 3. OFFSET FETCH: Retrieve the first 10 patients from the Patient table, starting from the 5th record.
SELECT  * 
FROM Barwon.PATIENT
ORDER BY UR_NUMBER ASC
OFFSET 4 ROWS
FETCH NEXT 10 ROWS ONLY;

---- 4. SELECT TOP: Retrieve the top 5 doctors from the Doctor table.
SELECT TOP 5 *
FROM Barwon.DOCTOR;

---- 5. SELECT DISTINCT: Get a list of unique address from the Patient table.
SELECT DISTINCT ADDRESS 
FROM Barwon.PATIENT;

---- 6. WHERE: Retrieve patients from the Patient table who are aged 25.
SELECT * 
FROM Barwon.PATIENT
WHERE AGE = 25;

---- 7. NULL: Retrieve patients from the Patient table whose email is not provided.
SELECT * 
FROM Barwon.PATIENT
WHERE EMAIL IS NULL;

---- 8. AND: Retrieve doctors from the Doctor table who have experience greater than 5 years and specialize in 'Cardiology'.
SELECT * 
FROM Barwon.DOCTOR
WHERE (SPECIALTY = 'Cardiology') AND (EXPERIENCE > 5);

---- 9. IN: Retrieve doctors from the Doctor table whose speciality is either 'Dermatology' or 'Oncology'.
SELECT * 
FROM Barwon.DOCTOR
WHERE SPECIALTY IN ('Dermatology', 'Oncology');

---- 10. BETWEEN: Retrieve patients from the Patient table whose ages are between 18 and 30.
SELECT * 
FROM Barwon.PATIENT
WHERE AGE BETWEEN 18 AND 30;

---- 11. LIKE: Retrieve doctors from the Doctor table whose names start with 'Dr.'.
SELECT * 
FROM Barwon.DOCTOR
WHERE NAME LIKE 'Dr.%';

---- 12. Column & Table Aliases: Select the name and email of doctors, aliasing them as 'DoctorName' and 'DoctorEmail'.
SELECT NAME AS DoctorName, EMAIL AS DoctorEmail 
FROM Barwon.DOCTOR;

---- 13. Joins: Retrieve all prescriptions with corresponding patient names.
SELECT P.PRESCRIPTION_ID, P.DATE, PT.NAME AS PatientName
FROM Barwon.PRESCRIPTION P JOIN Barwon.PATIENT PT 
ON P.UR_NUMBER = PT.UR_NUMBER;

---- 14. GROUP BY: Retrieve the count of patients grouped by their cities.
SELECT ADDRESS AS City, COUNT(*) AS Count_Of_Patient
FROM Barwon.PATIENT
GROUP BY ADDRESS;

---- 15. HAVING: Retrieve cities with more than 3 patients.
SELECT ADDRESS AS City, COUNT(*) AS Count_Of_Patient
FROM Barwon.PATIENT
GROUP BY ADDRESS
HAVING COUNT(*) > 3;

---- 16. GROUPING SETS: Retrieve counts of patients grouped by cities and ages.
SELECT ADDRESS AS City, AGE, COUNT(*) AS Count_Of_Patient
FROM Barwon.PATIENT
GROUP BY 
GROUPING SETS ((ADDRESS), (AGE)) ;

---- 17. CUBE: Retrieve counts of patients considering all possible combinations of city and age.
SELECT ADDRESS AS City, AGE, COUNT(*) AS Count_Of_Patient
FROM Barwon.PATIENT
GROUP BY 
CUBE(ADDRESS, AGE);

---- 18. ROLLUP: Retrieve counts of patients rolled up by city.
SELECT ADDRESS AS City, COUNT(*) AS PatientCount
FROM Barwon.PATIENT
GROUP BY 
ROLLUP(ADDRESS);

---- 19. EXISTS: Retrieve patients who have at least one prescription.
SELECT * 
FROM Barwon.PATIENT
WHERE EXISTS (
    SELECT 1 FROM Barwon.PRESCRIPTION
    WHERE PRESCRIPTION.UR_NUMBER = PATIENT.UR_NUMBER
);

---- 20. UNION: Retrieve a combined list of doctors and patients.
SELECT NAME, PHONE 
FROM Barwon.DOCTOR
UNION
SELECT NAME, PHONE 
FROM Barwon.PATIENT;

---- 21. Common Table Expression (CTE): Retrieve patients along with their doctors using a CTE.
--First insert into the table 
--
insert into Barwon.Patient_Doctor (Doctor_id,UR_number) values (1,1);
insert into Barwon.Patient_Doctor (Doctor_id,UR_number) values (1,2);
insert into Barwon.Patient_Doctor (Doctor_id,UR_number) values (1003,5);
insert into Barwon.Patient_Doctor (Doctor_id,UR_number) values (1003,45);
--
--the Query 
SELECT PD.UR_NUMBER, PP.NAME , D.NAME 
FROM Barwon.PATIENT_DOCTOR PD JOIN Barwon.PATIENT PP 
ON PD.UR_NUMBER = PP.UR_NUMBER
JOIN Barwon.DOCTOR D 
ON PD.DOCTOR_ID = D.DOCTOR_ID
--
--Use CTE
WITH PATIENTDOCTOR(Patient_ID,Patient_Name ,Doctor_Name) AS (
    SELECT PD.UR_NUMBER, PP.NAME , D.NAME 
    FROM Barwon.PATIENT_DOCTOR PD JOIN Barwon.PATIENT PP 
	ON PD.UR_NUMBER = PP.UR_NUMBER
    JOIN Barwon.DOCTOR D 
	ON PD.DOCTOR_ID = D.DOCTOR_ID
)
SELECT * 
FROM PATIENTDOCTOR;

---- 22. INSERT: Insert a new doctor into the Doctor table.
INSERT INTO Barwon.DOCTOR (NAME, SPECIALTY, PHONE, EMAIL)
VALUES ('Dr.AhmedSedeqQasim', 'surgeon', '01028812069', 'AQ@gmail.com');

---- 23. INSERT Multiple Rows: Insert multiple patients into the Patient table.
INSERT INTO Barwon.PATIENT (NAME, ADDRESS, AGE, PHONE, EMAIL)
VALUES 
('Salemmm', 'KFS', 30, '6518918551', 'Salem@example.com'),
('Mohamed', 'KFS', 25, '2928982654', 'mohamed@example.com');

---- 24. UPDATE: Update the phone number of a doctor.
UPDATE Barwon.DOCTOR
SET PHONE = '011011011111'
WHERE NAME = 'Dr.AhmedSedeqQasim';

---- 25. UPDATE JOIN: Update the city of patients who have a prescription from a specific doctor.
--first insert
insert into Barwon.DOCTOR_PRESCRIPTION (Doctor_id,PRESCRIPTION_ID) values (1003,15);
insert into Barwon.DOCTOR_PRESCRIPTION (Doctor_id,PRESCRIPTION_ID) values (1003,13);
insert into Barwon.DOCTOR_PRESCRIPTION (Doctor_id,PRESCRIPTION_ID) values (1003,11);
insert into Barwon.DOCTOR_PRESCRIPTION (Doctor_id,PRESCRIPTION_ID) values (1003,114);
--
UPDATE Barwon.PATIENT
SET ADDRESS = 'Tanta'
WHERE UR_NUMBER IN (
    SELECT P.UR_NUMBER
    FROM Barwon.PRESCRIPTION P JOIN Barwon.DOCTOR_PRESCRIPTION DP
	ON P.PRESCRIPTION_ID = DP.PRESCRIPTION_ID
    JOIN Barwon.DOCTOR D 
	ON DP.DOCTOR_ID = D.DOCTOR_ID
    WHERE D.NAME = 'Dr.AhmedSedeqQasim'
);

---- 26. DELETE: Delete a patient from the Patient table.
DELETE FROM Barwon.PATIENT
WHERE NAME = 'ssaaasss';

---- 27. Transaction: Insert a new doctor and a patient, ensuring both operations succeed or fail together.
Begin TRANSACTION;
INSERT INTO Barwon.DOCTOR (NAME, SPECIALTY, PHONE, EMAIL)
VALUES ('Dr.tarek', 'dentist', '9849', 'islamdff@example.com');
INSERT INTO Barwon.PATIENT (NAME, ADDRESS, AGE, PHONE, EMAIL)
VALUES ('ddd8vd', 'alex', 42, '55566577', 'cd894dd@example.com');
COMMIT;

---- 28. View: Create a view that combines patient and doctor information for easy access.
CREATE VIEW Barwon.Patient_And_Doctor
AS 
SELECT 
P.NAME AS Patient_Name, 
D.NAME AS Doctor_Name,
D.SPECIALTY,
D.PHone
FROM Barwon.PATIENT_DOCTOR PD JOIN Barwon.PATIENT P 
ON PD.UR_NUMBER = P.UR_NUMBER
JOIN Barwon.DOCTOR D 
ON PD.DOCTOR_ID = D.DOCTOR_ID;
---

SELECT * FROM Barwon.Patient_And_Doctor;


---- 29. Index: Create an index on the 'phone' column of the Patient table to improve search performance.

CREATE INDEX INDEX_PHONE ON Barwon.PATIENT(PHONE);

---- 30. Backup: Perform a backup of the entire database to ensure data safety.
BACKUP DATABASE Prescription_System
TO DISK = N'C:\Users\Ahmed\Desktop\dbb\Prescription_System_backup.bak'


