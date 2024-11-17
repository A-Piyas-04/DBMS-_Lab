-- Create table for Research Group
CREATE TABLE Research_Group (
    Group_Name VARCHAR(100) PRIMARY KEY,
    Dedicated_Lab VARCHAR(100),
    Budget DECIMAL(10, 2),
    Group_Head VARCHAR(100)
);

-- Create table for Faculty
CREATE TABLE Faculty (
    Faculty_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Contact_Number VARCHAR(15),
    Group_Name VARCHAR(100),
    FOREIGN KEY (Group_Name) REFERENCES Research_Group(Group_Name)
);

-- Create table for Student
CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Contact_Number VARCHAR(15),
    Group_Name VARCHAR(100),
    Supervisor INT,
    FOREIGN KEY (Group_Name) REFERENCES Research_Group(Group_Name),
    FOREIGN KEY (Supervisor) REFERENCES Faculty(Faculty_ID)
);

-- Create table for Project
CREATE TABLE Project (
    Project_Title VARCHAR(100) PRIMARY KEY,
    Start_Date DATE,
    Estimated_End_Date DATE,
    Research_Domain VARCHAR(100),
    Supervisor INT,
    FOREIGN KEY (Supervisor) REFERENCES Faculty(Faculty_ID)
);



-- Create table for Publications
CREATE TABLE Publication (
    Paper_Title VARCHAR(100) PRIMARY KEY,
    Conference_Name VARCHAR(100),
    Publication_Date DATE,
    Research_Domain VARCHAR(100),
    Summary TEXT,
    Group_Name VARCHAR(100),
    FOREIGN KEY (Group_Name) REFERENCES Research_Group(Group_Name)
);


DROP TABLE IF EXISTS Publication;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Faculty;
DROP TABLE IF EXISTS Research_Group;
