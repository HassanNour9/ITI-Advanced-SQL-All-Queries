     ''' Use ITI Database '''

--Create a scalar function that takes a date and returns the Month name of that date. test (‘1/12/2009’)
create function getmonth(@date date)
returns int
as 
begin 
Declare @x int
select @x = month(@date)
return @x
end

select dbo.getmonth('8/12/2009')

--Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
Create function getval(@x int,@y int)
returns @t table(val int)
as 
	begin
	while @y>@x
	begin
	insert into @t
	select @x
	set @x+=1
	end

	return
	end

select * from dbo.getval(2,6)

--Create a tabled valued function that takes Student No and returns Department Name with Student full name.
CREATE FUNCTION getData (@n INT)
RETURNS TABLE
AS
RETURN
	
    SELECT Dept_Name,CONCAT(St_Fname,' ',St_Lname) as fullName from Student S
	join Department D on S.Dept_Id=D.Dept_Id
	where St_id=@n

select * from dbo.getData(10)

--4.	Create a scalar function that takes Student ID and returns a message to the user (use Case statement)
--a.	If the first name and Last name are null then display 'First name & last name are null'
--b.	If the First name is null then display 'first name is null'
--c.	If the Last name is null then display 'last name is null'
--d.	Else display 'First name & last name are not null'
create function use_Case(@x int)
returns varchar(50)
as 
	begin
	declare @res varchar(50)
	select @res=case
	when St_Fname is null and St_Lname is null then 'First name & last name are null'
	when St_Fname is null then 'First name is null'
	when St_Lname is null then 'Last name is null'
	else 'First name & last name are not null'
	end
	from Student
	where St_Id=@x
	return @res
	end

select dbo.use_Case(1)

--Create multi-statements table-valued function that takes a string
--If string='first name' returns student first name
--If string='last name' returns student last name 
--If string='full name' returns Full Name from student table 
create function getname(@x varchar(20))
returns @t table(name varchar(20))
as 
	begin
	if @x='first name'
	begin
	insert into @t
	select St_Fname from Student
	end
	else if @x='last name'
	begin 
	insert into @t
	select St_Lname from Student
	end
	else if @x='full name'
	begin
	insert into @t
	select CONCAT(St_Fname,' ',St_Lname) from Student
	end
	return
	end

select * from dbo.getname('full name')

--Write a query that returns the Student No and Student first name without the last char
select St_id,SUBSTRING(St_Fname,0,len(St_Fname))as firstname from Student

        
        ''' Use Company_SD Database '''

    
--Create a function that takes project number and display all employees in this project
	CREATE FUNCTION getemp (@num INT)
	RETURNS TABLE
	AS
	RETURN
	
		SELECT CONCAT(Fname,' ',Lname) as fullname from Employee E
		join Works_for w on E.SSN=W.ESSn
		WHERE W.Pno=@num

	select * from dbo.getemp(400)

