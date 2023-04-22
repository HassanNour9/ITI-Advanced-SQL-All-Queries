        ''' Use ITI Database '''

--Create a stored procedure to show the number of students per department
create proc pr1 
as
select D.Dept_Name,COUNT(St_id) as count_emp 
from Student S join Department D on S.Dept_Id=D.Dept_Id
group by D.Dept_Name

--Create a trigger to prevent anyone from inserting a new record in the Department table 
CREATE TRIGGER t1
 ON Departments
 INSTEAD OF Insert
 AS
   SELECT ' cant insert a new record in that table' 

--Create a trigger on student table after insert to add Row in a Student Audit table (Server User Name, Date, Note) where the note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
create table AuditTable2(
Server_User_Name varchar(max),
dateofinsert date,
note varchar(max)
)

create trigger trigger2 
on [dbo].[Student]
after insert
as 
	 begin 
		declare @note varchar(500) , @key varchar(500) , @table varchar(500)
		select @key =[St_Id]  from inserted
		set @table = 'Student'
		set @note = CONCAT(SUSER_NAME() , 'Insert New Row with ', @key,' in ', @table)
		insert into AuditTable2 values (suser_name() , getdate() , @note)
	end

INSERT INTO Student (St_Id,St_Fname) VALUES (235,'Ali')

select * from AuditTable2


             ''' Use Company_SD Database '''

--Create a stored procedure that will check for the number of employees in the project 100 if they are more than 3 print a message to the user “'The number of employees in the project 100 is 3 or more'” 
--if they are less display a message to the user “'The following employees work for the project p1'” in addition to the first name and last name of each one
Create proc pr2
as 
declare @counEm int
select @counEm=count(ESSn) from Works_for
where Pno=100
if @counEm>3
begin
select 'The number of employees in the project 100 is 3 or more'
 end
 else 
	begin
	select 'The following employees work for the project p1',
	Fname,Lname from Employee E join Works_for W
	on E.SSN=W.ESSn
	where Pno=100
	end	

--Create a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him. 
--The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_for table
Create proc pr3 @oldEm int ,@newEm int,@proNum int
as

if exists (select * from Employee where SSN=@newEm)
begin
update Works_for
set ESSN=@newEm
where ESSN=@oldEm and @proNum=Pno
end

--Create an Audit table with the following structure
--ProjectNo	|| UserName || ModifiedDate	|| Hours_Old || Hours_New
--p2	    || Dbo	    ||2008-01-31	||10	     ||20

--This table will be used to audit the update trials on the Hours column (works_for table, Company DB)
--Example:
--If a user updated the Hours column then the project number, the user name that made that update,
 --the date of the modification and the value of the old and the new Hours will be inserted into the Audit table
 Create table AuditTable (
ProjectName nVarchar(20),
UserName varchar(max),
ModifiedDate date,
Hours_Old int,
Hours_New int,
)

Create TRIGGER up_ho 
on Works_for
After update	
as 
 if update (Hours)
	begin 
		declare @old_H int , @new_H int , @porName nvarchar(20)
		select @old_H = [Hours] from deleted
		select @new_H = [Hours]from inserted
		select @porName= Pname from inserted I join Project P on I.Pno=p.Pnumber 
		insert into AuditTable values ( @porName , SUSER_NAME() , GETDATE(), @old_H , @new_H )
	end

update Works_for set Hours = 20
where Pno = 100

select * from AuditTable
