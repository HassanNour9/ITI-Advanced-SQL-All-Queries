''' Use Company_SD Database '''

---Display the Department id, name and id and the name of its manager.
select Dnum,Dname,SSN,CONCAT(Fname,' ',Lname) as fullname 
from Employee E inner join Departments D on E.SSN=D.MGRSSN 

---Display the name of the departments and the name of the projects under its control.
select Dname,Pname from Departments D join Project P on D.Dnum=P.Dnum

---Display the full data about all the dependence associated with the name of the employee they depend on him/her.
select ESSN,Dependent_name,DE.Bdate,CONCAT(Fname,' ',Lname) as fullname 
from Employee E join Dependent DE on E.SSN=DE.ESSN 

---Display the Id, name and location of the projects in Cairo or Alex city.
select Pnumber,Pname,Plocation from Project where City ='Cairo' or City ='Alex'

---Display the Projects full data of the projects with a name starts with "a" letter.
select * from Project where Pname like 'a%'

---display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select CONCAT(Fname,' ',Lname) as fullname from Employee 
where Dno=30 and Salary between 1000 and 2000

---Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
select CONCAT(Fname,' ',Lname) as fullname 
from Employee E join Works_for W on E.SSN=W.ESSn join Project P On P.Pnumber=W.Pno
where E.Dno=10 and P.Pname ='AL Rabwah' and Hours>=10

---Find the names of the employees who directly supervised with Kamel Mohamed
select CONCAT(Fname,' ',Lname) as fullname from Employee 
where Superssn=(select SSN from Employee where Fname='Kamel' and Lname='Mohamed')

---Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select CONCAT(Fname,' ',Lname) as fullname,P.Pname 
from Employee E join Works_for W on E.SSN=W.ESSn join Project P On P.Pnumber=W.Pno
order by P.Pname

---For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
select P.Pnumber,D.Dname,E.Lname,E.Address,E.Bdate from Project P 
join Departments D on P.Dnum=D.Dnum join Employee E on D.MGRSSN=E.SSN
where P.City='Cairo'

---Display All Data of the mangers
select * from Employee 
where SSN in(select  Distinct Superssn from Employee)

---Display All Employees data and the data of their dependents even if they have no dependents
select * from Employee E left join Dependent D on E.SSN =D.ESSN

---Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
insert into Employee (SSN,Dno,Superssn,Salary) values (102672,30,112233,3000)

---Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or manager number to him.
insert into Employee (SSN,Dno) values (102660,30)

---Upgrade your salary by 20 % of its last value
update Employee 
set Salary=Salary+Salary*.20
where SSN=102672