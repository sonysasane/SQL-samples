--SPS using input parameter
create proc sp_getname (@jobtitile varchar(50)) as
select pp.firstname
from person.person pp inner join HumanResources.Employee he on pp.BusinessEntityID = he.BusinessEntityID
where he.JobTitle = @jobtitile

exec sp_getname 'Tool designer'

go 
---SPS USING OUTPUT PARAMETER

create proc sp_outputtest (@id int, @job varchar(20) out) as
select @job = JobTitle
from HumanResources.Employee
where BusinessEntityID = @id


declare @title varchar(20)
exec sp_outputtest 12,@title out

print @title

--SPS USING DEFAULT PARAMETER

create proc sp_defaulttest (@id int= null , @lname varchar(40) = null) as
begin
 if @id is not null and @lname is null
      select p.FirstName + ' ' + p.LastName as fullname,Title
	  from person.Person p
	  where @id = BusinessEntityID

else if @id is null and @lname is not null
     select p.FirstName + ' ' + p.LastName as fullname,Title
	  from person.Person p
	  where @lname = LastName 

else if @id is not null and @lname is not null
      select p.FirstName + ' ' + p.LastName as fullname,Title
	  from person.Person p
	  where @lname = LastName and @id = BusinessEntityID
else
   print 'plz enter id or last name'

end

exec sp_defaulttest 





















