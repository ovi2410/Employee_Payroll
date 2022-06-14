--UC-1 creating database
create database EmployeeServices;

--UC-2 creating Table
create Table empoyee_payrolls
(
id int identity(1,1) primary key,
name varchar(200) not null,
salary float,
startDate date
)

--UC-3 Insert values in Table
Insert into empoyee_payrolls(name,salary,startDate) values
('shalini',20000,'2021-03-12'),
('Magesh',25000,'2021-04-18'),
('Gayathri',10000,'2020-05-13'),
('Aruna',30000,'2020-08-19');

--UC-4 Retrieve All data--
select * from empoyee_payrolls;

------- UC 5: Select Query using Cast() an GetDate() -------
select salary from empoyee_payrolls where name='Magesh';
select salary from empoyee_payrolls where startDate BETWEEN Cast('2020-12-20' as Date) and GetDate();

------- UC 6: Add Gender Column and Update Table Values -------
Alter table empoyee_payrolls
add Gender char(1);

Update empoyee_payrolls 
set Gender='M'
where name='Magesh';
Update empoyee_payrolls 
set Gender='F'
where name='Gayathri' or name='Shalini'or name='Aruna';

------- UC 7: Use Aggregate Functions and Group by Gender -------

select Sum(salary) as "TotalSalary",Gender from empoyee_payrolls group by Gender;
select Avg(salary) as "AverageSalary",Gender from empoyee_payrolls group by Gender;
select Min(salary) as "MinimumSalary",Gender from empoyee_payrolls group by Gender;
select Max(salary) as "MaximumSalary",Gender from empoyee_payrolls group by Gender;
select count(salary) as "CountSalary",Gender from empoyee_payrolls group by Gender;

------- UC 8: Add column department,PhoneNumber and Address -------
Alter table empoyee_payrolls
add EmployeePhoneNumber BigInt,EmployeeDepartment varchar(200) not null default 'Publish',Address varchar(200) default 'Not Provided';

Update empoyee_payrolls
set EmployeePhoneNumber='9842905050',EmployeeDepartment='Editing',Address='Bangalore,Karnataka'
where name='Shalini';

Update empoyee_payrolls 
set EmployeePhoneNumber='10987252525',Address='Arizona,US'
where name ='Magesh';

Update empoyee_payrolls
set EmployeePhoneNumber='9600054540',EmployeeDepartment='Management',Address='Chennai,TN'
where name ='Gayathri';

Update empoyee_payrolls 
set EmployeePhoneNumber='8715605050',Address='Bareilly,UP'
where name ='Aruna';

------- UC 9: Rename Salary to Basic Pay and Add Deduction,Taxable pay, Income Pay , Netpay -------

EXEC sp_RENAME 'empoyee_payrolls.Basic Pay' , 'BasicPay', 'COLUMN'
Alter table empoyee_payrolls
add Deduction float,TaxablePay float, IncomeTax float,NetPay float;
Update empoyee_payrolls
set Deduction=1000
where Gender='F';
Update empoyee_payrolls 
set Deduction=2000
where Gender='M';
update empoyee_payrolls
set NetPay=(BasicPay - Deduction)
update empoyee_payrolls
set TaxablePay=0,IncomeTax=0
select * from empoyee_payrolls;

------- UC 10: Adding another Value for Rujula in Editing Department -------

Insert into empoyee_Payrolls(name,BasicPay,StartDate,Address,EmployeePhoneNumber,EmployeeDepartment) values ('Gayathri',250000,'2019-04-20','Chennai,TN','9600054540','Editing');
select * from empoyee_payrolls;

------- UC 11: Implement the ER Diagram into Payroll Service DB -------
--Create Table for Company
Create Table Company
(CompanyID int identity(1,1) primary key,
CompanyName varchar(100))
--Insert Values in Company
Insert into Company values ('Balrama'),('Amar Chitra Katha')
Select * from Company

--Create Employee Table
drop table empoyee_payrolls
create table Employee
(EmployeeID int identity(1,1) primary key,
CompanyIdentity int,
EmployeeName varchar(200),
EmployeePhoneNumber bigInt,
EmployeeAddress varchar(200),
StartDate date,
Gender char,
Foreign key (CompanyIdentity) references Company(CompanyID)
)
--Insert Values in Employee
insert into Employee values
(1,'Anita Yadav',9842905050,'5298 Wild Indigo, Georgia,340002','2012-03-28','F'),
(2,'Kriti Deshmuk',9842905550,'Constitution Ave Fairfield, California(CA), 94533','2017-04-22','F'),
(1,'Nandeeshwar',7812905050,'Bernard Shaw, Georgia,132001 ','2015-08-22','M'),
(2,'Sarang Nair',78129050000,'Bernard Shaw, PB Marg Bareilly','2012-08-29','M')

Select * from Employee

--Create Payroll Table
create table PayrollCalculate
(BasicPay float,
Deductions float,
TaxablePay float,
IncomeTax float,
NetPay float,
EmployeeIdentity int,
Foreign key (EmployeeIdentity) references Employee(EmployeeID)
)
--Insert Values in Payroll Table
insert into PayrollCalculate(BasicPay,Deductions,IncomeTax,EmployeeIdentity) values 
(4000000,1000000,20000,1),
(4500000,200000,4000,2),
(6000000,10000,5000,3),
(9000000,399994,6784,4)

--Update Derived attribute values 
update PayrollCalculate
set TaxablePay=BasicPay-Deductions

update PayrollCalculate
set NetPay=TaxablePay-IncomeTax

select * from PayrollCalculate

--Create Department Table
create table Department
(
DepartmentId int identity(1,1) primary key,
DepartName varchar(100)
)
--Insert Values in Department Table
insert into Department values
('Marketing'),
('Sales'),
('Publishing')

select * from Department

--Create table EmployeeDepartment
create table EmployeeDepartment
(
DepartmentIdentity int ,
EmployeeIdentity int,
Foreign key (EmployeeIdentity) references Employee(EmployeeID),
Foreign key (DepartmentIdentity) references Department(DepartmentID)
)

--Insert Values in EmployeeDepartment
insert into EmployeeDepartment values
(3,1),
(2,2),
(1,3),
(3,4)

select * from EmployeeDepartment
------- UC 12: Ensure all retrieve queries done especially in UC 4, UC 5 and UC 7 are working with new table structure -------

--UC 4: Retrieve all Data
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,EmployeeAddress,EmployeePhoneNumber,StartDate,Gender,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,DepartName
FROM Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID
INNER JOIN EmployeeDepartment on Employee.EmployeeID=EmployeeDepartment.EmployeeIdentity
INNER JOIN Department on Department.DepartmentId=EmployeeDepartment.DepartmentIdentity

--UC 5: Select Query using Cast() an GetDate()
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay
FROM Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity and StartDate BETWEEN Cast('2012-11-12' as Date) and GetDate()
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID
--Retrieve query based on Name
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay
FROM Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity and Employee.EmployeeName='Kriti Deshmuk'
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID

--UC 7: Use Aggregate Functions and Group by Gender

select Sum(BasicPay) as "TotalSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;

select Avg(BasicPay) as "AverageSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;

select Min(BasicPay) as "MinimumSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;

select Max(BasicPay)  as "MaximumSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;

select Count(BasicPay) as "CountSalary",Gender 
from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;