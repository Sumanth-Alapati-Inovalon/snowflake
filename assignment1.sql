CREATE DATABASE HealthcareDB;
USE DATABASE HealthcareDB;


CREATE FILE FORMAT my_csv_format
TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '"';


CREATE OR REPLACE STAGE patient_stage 
URL = 's3://sumanthhealthcaredata/Patient_Records.csv'
CREDENTIALS = (
    AWS_KEY_ID = 'xxx' 
    AWS_SECRET_KEY = 'x+xx/'
);

CREATE TABLE Patients (
    PatientID INT,
    Name STRING,
    Diagnosis STRING,
    AdmissionDate DATE,
    DischargeDate DATE
);

COPY INTO Patients
FROM @patient_stage
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format')
ON_ERROR = 'CONTINUE';




CREATE MATERIALIZED VIEW AvgStayByDiagnosis AS 
SELECT 
    Diagnosis, 
    AVG(DATEDIFF(DAY, AdmissionDate, DischargeDate)) AS AvgStay
FROM Patients
GROUP BY Diagnosis;


SELECT * FROM Patients

SELECT * 
FROM AvgStayByDiagnosis;


