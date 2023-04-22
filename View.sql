               ''' Use Company_SD Database'''

---Create a view that will display the project name and the number of employees works on it.
create view emp_count as
select Pname,count(ESSn) as empl_count from Project P 
join Works_for W on P.Pnumber=W.Pno
group by Pname 

---Create a view named “v_D30” that will display employee number, project number, hours of the projects in department 30.
create view v_D30 as
select W.ESSn,P.Pnumber,W.Hours from Project P 
join Works_for W on P.Pnumber=W.Pno
where P.Dnum=30

---Create a view named “v_count “ that will display the project name and the number of hours for each one
create view v_count as
select Pname,SUM(W.Hours) as p_hours  from Project P 
join Works_for W on P.Pnumber=W.Pno
group by Pname 

---Create a view named ” v_project_500” that will display the emp no. for the project 500, use the previously created view  “v_D30”
create view v_project_500 as
select v_D30.Pnumber,count(v_D30.ESSn) as em_co from v_D30
where v_D30.Pnumber=500
group by v_D30.Pnumber

---Delete the views “v_D30” and “v_count”
drop view v_D30,v_count

---Make a rule that makes sure the value is less than 1000 then bind it on the Salary in Employee table
create rule ru1 as @h<1000
 sp_bindrule ru1 , 'Employee.Salary'

 ---2.	Create a new user data type named loc with the following Criteria:
--•	nchar(2)
--•	default: NY 
--•	create a rule for this Datatype :values in (NY,DS,KW)) and associate it to the location column
CREATE TYPE loc FROM nchar(2) ;
CREATE RULE Ru2 as @list in('NY','DS','KW')
sp_bindrule Ru2 ,loc
create default d as 'NY'
sp_bindefault d , loc

          
                 ''' Use ITI Database '''

---Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “. 
create view inst_Dep as
select Ins_Name,Dept_Name from Instructor I join Department D
on I.Dept_Id=D.Dept_Id
where D.Dept_Name ='SD' or D.Dept_Name='Java'

---Create a view “V1” that displays student data for the student who lives in Alex or Cairo.
create view V1 as 
 select * from Student
 where St_Address='Cairo' or St_Address='Alex'

 ---Create a view that displays the student’s full name, course name if the student has a grade of more than 50.create view stu_cours as
 select CONCAT(St_Fname,' ',St_Lname) as fullname,Crs_Name 
 from Student S join Stud_Course ST
 on S.St_Id=ST.St_Id 
 join Course C on ST.Crs_Id=C.Crs_Id
 where ST.Grade>50

 ---Create an Encrypted view that displays manager names and the topics they teach. (Hint :To Find Instructor who work as manger using Manage Relation Ship between instructor and department PK =[dbo].[Instructor]. [Ins_Id]
--FK =[dbo].[Department]. [Dept_Manager]  )
create view mng_topic as 
 select Ins_Name,Top_Name from Instructor I join Department D on I.Ins_Id=D.Dept_Manager
 join Ins_Course IC on I.Ins_Id=IC.Ins_Id 
 join Course C on IC.Crs_Id=C.Crs_Id
 join Topic T on C.Top_Id=T.Top_Id
 group by I.Ins_Name,Top_Name
