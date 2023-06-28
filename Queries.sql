/*1 
count() will return the number of rows in the column in the brackets, in this case, all rows in the charges table
Using AS '' will replace the preset column name to whatever is in the ''
*/ 
SELECT count(*) AS 'Number of Charges' FROM CHARGES
SELECT count(*) AS 'Number of Consults' FROM CONSULTATION
SELECT count(*) AS 'Number of Patients' FROM PATIENT
SELECT count(*) AS 'Number of Specialities' FROM SPECIALITY
SELECT count(*) AS 'Number of Staff' FROM STAFF
SELECT count(*) AS 'Number of Staff Specialities' FROM STAFF_SPECIALITY

/*2 Using the < operator will only return rows that contain a DateJoined less than '2017-01-23'*/
SELECT * FROM STAFF WHERE DateJoined < '2017-01-23'

/*3 Is not null will only return rows that contain data in DateLeft, current employees have null DateLeft*/
SELECT * FROM STAFF WHERE DateLeft is not null

/*4 Where can have multiple arguements to meet with AND*/
SELECT * FROM STAFF WHERE DateLeft is not null AND Gender = 'F'

/*5 Like %string% is an arguement that requires a column to contain a string of characters*/
SELECT ChargeID AS 'Charge Code', ChrgDescription AS 'Description', HourlyRate AS 'Hourly Rate' FROM CHARGES WHERE ChrgDescription like '%casual%'

/*6 Not like requires the column to NOT the contain the characters*/
SELECT ChargeID AS 'Charge Code', ChrgDescription AS 'Description', HourlyRate AS 'Hourly Rate' FROM CHARGES WHERE ChrgDescription not like '%casual%'

/*7 format() is used to edit whats in the brackets, in this case C is currency, $ and two decimal places
max()/min()/avg() is used to return the row with the highest,lowest and average value of the column in the brackets*/
SELECT format(max(HourlyRate),'C') AS 'Highest Rate', format(min(HourlyRate),'C') AS 'Lowest Rate', format(avg(HourlyRate),'C') AS 'Average Rate' FROM CHARGES

/*8 (column * column/60) can be used to return the result as new column if the columns are integers*/
SELECT ChargeID AS 'Charge Code', HourlyRate AS 'Hourly Rate', Duration AS 'Duration', format((HourlyRate * Duration/60),'C','en-us') AS 'Duration Rate' FROM CHARGES

/*9 DateDiff(time,column,column) is used to convert date strings into integers to do math. time is the difference you are looking for in the two columns eg years, hours*/
SELECT StaffID AS 'Staff ID', SpecialityID AS 'Speciality ID', DateQualified AS 'Date Qualified', ValidTillDate AS 'Valid Till Date', DateDiff(day,DateQualified,ValidTillDate) AS 'Days Valid' FROM STAFF_SPECIALITY

/*10 DateADD(time,interger,column) is used to do addition on a date string. Time is the part of the date you want to change, integer is the amount to increase by and column is the date you want to change*/
SELECT StaffID AS 'Staff ID', CONSULTATION.ChargeID AS 'Charge Code', DateConsulted AS 'Date Consulted', StartTime AS 'Start Time', hourlyrate as 'Hourly Rate', DateADD(day,21,DateConsulted) AS 'Date Due' FROM CONSULTATION, CHARGES WHERE CHARGES.ChargeID = CONSULTATION.ChargeID

/*11 This statement is using a equal join to get data from two tables. We link a primary/foreign key such as SpecialityID to match data across tables.*/
SELECT StaffID AS 'Staff ID', SPECIALITY.SpecialityID AS 'Speciality ID', SpecName AS 'Speciality Name', DateQualified AS 'Date Qualified', ValidTillDate AS 'Valid Till Date' FROM STAFF_SPECIALITY, SPECIALITY WHERE SPECIALITY.SpecialityID = STAFF_SPECIALITY.SpecialityID

/*12 When Selecting from tables with an equal join, the table it comes from must be specified with table.column. Either table is valid*/
SELECT StaffID AS 'Staff ID', PatientID AS 'Patient Num', DateConsulted AS 'Date Consulted', StartTime AS 'Start Time', HourlyRate as 'Hourly Rate' FROM CONSULTATION, CHARGES WHERE CONSULTATION.ChargeID = CHARGES.ChargeID

/*13 Multiple fields can be combined to create an output treated as a new column. FirstName + LastName will join the two strings together into one*/
SELECT STAFF.StaffID AS 'Staff ID', FirstName + ' ' + LastName AS 'Staff Full Name', SpecialityID AS 'Speciality ID' FROM STAFF, STAFF_SPECIALITY WHERE STAFF.StaffID = STAFF_SPECIALITY.StaffID and Gender = 'M'

/*14 Like filters strings for characters that match "sur" %% will find this exact match in any part of a sentence */
SELECT StaffID AS 'Staff ID', SpecName AS 'Speciality Name', SpecNotes AS 'Details' FROM SPECIALITY, STAFF_SPECIALITY WHERE SPECIALITY.SpecialityID = STAFF_SPECIALITY.SpecialityID and Details like '%sur%' or '%Sur%'

/*15 Where StartTime > 9.45 will only show records with a StartTime greater than 9.45. Order by StaffID desc will display these in descending order of their StaffID number*/
SELECT StaffID AS 'Staff ID', PatientID AS 'Patient Num', ChrgDescription AS 'Charge Description', StartTime AS 'Time' FROM CONSULTATION, CHARGES WHERE CONSULTATION.ChargeID = CHARGES.ChargeID and StartTime > 9.45 ORDER BY StaffID DESC

/*16 count() will return the number of records that appear in consultation. Group by StaffID is used to turn records into an aggregate function, something that can be counted as an integer*/
SELECT StaffID AS 'Staff ID', count(StaffID) AS 'Num of Consults' FROM CONSULTATION GROUP BY StaffID

/*17 Having is the same as a where function but is used for the group by function.*/
SELECT StaffID AS 'Staff ID', count(StaffID) AS 'Num of Consults' FROM CONSULTATION GROUP BY StaffID HAVING count(StaffID) > 2

/*18 This is selecting the amount of staff with each speciality and displaying them in descending order*/
SELECT SpecialityID AS 'Speciality ID', count(staffID) AS 'Num with Speciality' FROM STAFF_SPECIALITY GROUP BY SpecialityID ORDER BY count(StaffID) DESC

/*19 This is selecting the amount of staff with each speciality and displaying the specialities with more than two staff in descending order.*/
SELECT SpecialityID AS 'Speciality ID', count(StaffID) AS 'Num with Speciality' FROM STAFF_SPECIALITY GROUP BY SpecialityID HAVING count(StaffID) > 2 ORDER BY count(StaffID) DESC

/*20 When grouping and ordering by this FirstName + LastName join, the group by has to use the fields as they appear without the AS statement, but when using order by it has to use the AS name in square brackets*/
SELECT STAFF.FirstName + ' ' + STAFF.LastName AS 'Staff Full Name', count(STAFF.StaffID) AS 'Num of Specialities' FROM STAFF, STAFF_SPECIALITY WHERE STAFF.StaffID = STAFF_SPECIALITY.StaffID GROUP BY STAFF.FirstName + ' ' + STAFF.LastName ORDER BY [Staff Full Name]

/*21 This statement groups the records by Staff Full Name and their gender, requiring BOTH male AND more than one speciality with the having function. In alphabetical order of their full name*/
SELECT STAFF.FirstName + ' ' + STAFF.LastName AS 'Staff Full Name', count(STAFF.StaffID) AS 'Num of Specialities' FROM STAFF, STAFF_SPECIALITY WHERE STAFF.StaffID = STAFF_SPECIALITY.StaffID GROUP BY STAFF.FirstName + ' ' + STAFF.LastName, STAFF.Gender HAVING Gender = 'M' and count(STAFF.staffID) > 1 ORDER BY [Staff Full Name]

/*22 This statement is selecting data from 3 tables. Like how 11 uses an equal join, this also uses a join with two links to match two keys. STAFF_SPECIALITY links its StaffID with STAFF and its SpecialityID with SPECIALITY*/
SELECT STAFF.staffID AS 'Staff ID', STAFF.FirstName + ' ' + STAFF.LastName AS 'Staff Full Name', STAFF_SPECIALITY.SpecialityID AS 'Speciality ID', SpecName AS 'Speciality Name' FROM STAFF, STAFF_SPECIALITY, SPECIALITY WHERE SPECIALITY.SpecialityID = STAFF_SPECIALITY.SpecialityID and STAFF.StaffID = STAFF_SPECIALITY.StaffID
