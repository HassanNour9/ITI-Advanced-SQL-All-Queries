             ''' Use Company_SD Database '''

---For each project, list the project name and the total hours per week (for all employees) spent on that project.
select P.Pname,sum(W.Hours) From Project p join Works_for W 
on P.Pnumber=W.Pno
group by P.Pname

---Display the data of the department which has the smallest employee ID over all employees' ID.
select D.Dnum,D.Dname,D.MGRSSN,D.[MGRStart Date] 
from Departments D join Employee E on D.Dnum=E.Dno
where E.SSN=(select min(SSN) from Employee where Dno is not null) 
Group by D.Dnum,D.Dname,D.MGRSSN,D.[MGRStart Date]

---For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
Select D.Dname,Max(Salary) as Max_Sala,MIN(Salary) as Min_Sala,AVG(Salary) as Av_sala
from Employee E join Departments D on E.Dno=D.Dnum
group by D.Dname

---For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
select D.Dnum,D.Dname,count(E.SSN) as Count_Emp from Departments D join Employee E
on E.Dno=D.Dnum
group by D.Dnum,D.Dname
having AVG(Salary)<(select AVG(Salary) from Employee)

---Try to get the max 2 salaries 
select top 2 salary from Employee
order by Salary desc
---Another Solution 
select Salary
from 
(select Salary ,Dense_rank() over (Order by Salary desc) as Rn
from Employee)  Ran 
where Rn<=2 

---Find Highest two projects in working hours For each department
select Dnum,Pname,sum_hu from(
select Dnum,Pname,sum(w.hours) sum_hu,ROW_NUMBER() over (partition by Dnum order by sum(W.hours) desc) as Rn
from Project P join Works_for W on P.Pnumber=W.Pno
group by Dnum,Pname) as x
where Rn<3


           ''' Use ITI Database '''


---Find Second highest total grade student  for each department  
select DepID,StuID,fullname from
(select D.Dept_Id as DepID,S.St_Id as StuID,CONCAT(S.St_Fname,' ',S.St_Lname) as fullname,Sum(SC.Grade) as sum_Gr,
ROW_NUMBER() over (partition by D.Dept_Id order by Sum(Grade) Desc) as Rn 
from Stud_Course SC join Student S on SC.St_Id=S.St_Id
join Department D on S.Dept_Id=D.Dept_Id
group By D.Dept_Id,S.St_Id,s.St_Fname,s.St_Lname) as x
where Rn=2

---Find Second Highest Instructor Salary for each Instructor Degree
select Ins_Degree,Ins_Name,Salary from
(select Ins_Degree,Ins_Name,Salary,Dense_Rank() over (partition by Ins_Degree order by Salary Desc) as Rn
from Instructor 
where Ins_Degree is not null
group by Ins_Degree,Ins_Name,salary) as x
where Rn=2
