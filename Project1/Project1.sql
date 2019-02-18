/* 
Lillian K
Project 1
*/

drop table Enrollment; 
drop table Offering;
drop table Course;
drop table Student;
drop table Instructor;
drop table Person;

/* --- --Part A ----- */

/* Item 1 - The Person Table */
create table Person (
Name char (20),
ID char (9) not null,
Address char (30),
DOB date,
primary key (ID));

/* Item 2 - The Instructor Table */
create table Instructor (
InstructorID char (9) not null,
Rank char (12),
Salary int,
primary key (InstructorID),
foreign key (InstructorID) references Person(ID));

/* Item 3 - The Student Table */
create table Student (
StudentID char (9) not null,
Classification char (10),
GPA double,
MentorID char (9),
CreditHours int,
primary key (StudentID),
foreign key (MentorID) references Instructor(InstructorID));

/* Item 4 - The Course Table */
create table Course (
CourseCode char (6) not null,
CourseName char (50),
PreReq char (6),
primary key (CourseName, CourseCode));

/* Item 5 - The Offering Table */
create table Offering (
CourseCode char (6) not null,
SectionNo int not null,
InstructorID char (9) not null,
primary key (CourseCode, SectionNo),
foreign key (InstructorID) references Instructor(InstructorID));

/* Item 6 - The Enrollment Table */
create table Enrollment (
CourseCode char (6) not null,
SectionNo int not null, 
StudentID char (9) not null references Student, 
Grade char (4) not null, 
primary key (CourseCode, StudentID), 
foreign key (CourseCode, SectionNo) references Offering(CourseCode, SectionNo));


/* ----- Part B ----- */

/* Item 7 - Load Person Table */
load xml local infile '/Users/Lily/School Files/COM S 363/Project1/Person.xml' 
into table Person 
rows identified by '<Person>';

/* Item 8 - Load Instructor Table */
load xml local infile '/Users/Lily/School Files/COM S 363/Project1/Instructor.xml' 
into table Instructor
rows identified by '<Instructor>';

/* Item 9 - Load Student Table */
load xml local infile '/Users/Lily/School Files/COM S 363/Project1/Student.xml' 
into table Student
rows identified by '<Student>';

/* Item 10  - Load Course Table */
load xml local infile '/Users/Lily/School Files/COM S 363/Project1/Course.xml' 
into table Course
rows identified by '<Course>';

/* Item 11 - Load Offering Table */
load xml local infile '/Users/Lily/School Files/COM S 363/Project1/Offering.xml' 
into table Offering
rows identified by '<Offering>';

/* Item 12 - Load Enrollment Table */
load xml local infile '/Users/Lily/School Files/COM S 363/Project1/Enrollment.xml' 
into table Enrollment
rows identified by '<Enrollment>';

/* ----- Part C ----- */

/* Item 13 - List the IDs of students and the IDs of their Mentors for students who are junior or senior having a GPA above 3.8. */
select S.StudentID, S.MentorID
from Student S
where S.Classification = 'Junior' or S.Classification = 'Senior' and GPA > 3.8;

/* Item 14 - List the distinct course codes and sections for courses that are being taken by sophomore.  */
select distinct O.CourseCode, O.SectionNo
from Offering O
inner join Enrollment E on O.CourseCode = E.CourseCode
inner join Student S on S.StudentID = E.StudentID and S.Classification = 'Sophomore';

/* Item 15 - List the name and salary for mentors of all freshmen. */ 
select I.Salary, P.Name
from Person P, Student S, Instructor I
where S.Classification = 'Freshman' and P.ID = I.InstructorID and S.MentorID = I.InstructorID;

/* Item 16 - Find the total salary of all instructors who are not offering any course.*/ 
select sum(I.Salary)
from Instructor I, Offering O
where (I.InstructorID != O.InstructorID) = 0;

/* Item 17 - List all the names and DOBs of students who were born in 1976. */
select P.Name, P.DOB
from Person P, Student S
where year(P.DOB) = 1976 and S.StudentID = P.ID;

/* Item 18 - List the names and rank of instructors who neither offer a course nor mentor a student. */
select P.Name, I.Rank
from Person P, Instructor I
inner join Offering O on O.InstructorID != I.InstructorID
inner join Student S on S.MentorID != I.InstructorID
group by P.Name;

/* Item 19 - Find the IDs, names and DOB of the youngest student(s). */
select P.Name, S.StudentID, max(P.DOB)
from Person P, Student S
where S.StudentID = P.ID;

/* Item 20 - List the IDs, DOB, and Names of Persons who are neither a student nor a instructor. */
select P.ID, P.DOB, P.Name
from Person P
where P.ID not in (select S.StudentID from Student S) and P.ID not in (select I.InstructorID from Instructor I);

/* Item 21 - For each instructor list his / her name and the number of students he / she mentors. */
select P.Name, count(*) Total_Mentee_Count
from Instructor I
inner join Person P on I.InstructorID = P.ID
inner join Student S on I.InstructorID = S.MentorID
group by P.Name;

/* Item 22 - List the number of students and average GPA for each classification. */
select S.Classification, avg(S.GPA), count(*)
from Student S
group by S.Classification;

/* Item 23 - Report the course(s) with lowest enrollments. You should output the course code and the number of enrollments. */
select E.CourseCode, count(E.StudentID)
from Enrollment E
group by E.CourseCode
order by count(E.StudentID)
limit 1;

/* Item 24 - List the IDs and Mentor IDs of students who are taking some course, offered by their mentor. */
select S.StudentID, O.InstructorID
from Offering O
inner join Student S on S.MentorID = O.InstructorID
group by S.StudentID;

/* Item 25 - List the student id, name, and completed credit hours of all freshman born in or after 1976. */
select S.StudentID, P.Name, S.CreditHours
from Person P, Student S
where P.ID = S.StudentID and S.Classification = "Freshman" and year(P.DOB) >= 1976;

/* Item 26 - Insert: Student name: Briggs Jason; ID: 480293439; address.... */
insert into Person (Name, ID, Address, DOB)
values ('Briggs Jason', '480293439', '215 North Hyland Avenue', '1975-01-15');

insert into Student (StudentID, Classification, GPA, MentorID, CreditHours)
values ('480293439', 'Junior', 3.48, '201586985', 75);

insert into Enrollment (CourseCode, SectionNo, StudentID, Grade) /* course 1 */
values ('CS311', 2, '480293439', 'A');

insert into Enrollment (CourseCode, SectionNo, StudentID, Grade) /* course 2 */
values ('CS330', 1, '480293439', 'A-');

select *
from Person P
where P.Name= 'Briggs Jason';

select *
from Student S
where S.StudentID= '480293439';

select *
from Enrollment E
where E.StudentID = '480293439';

/* Item 27 - Delete the records of students from the database who have a GPA less than 0.5. */
delete E
from Enrollment E, Student S
where E.StudentID = S.StudentID and S.GPA < 0.5;

delete S
from Student S
where S.GPA < 0.5;

/* Item 28 - Update the instructor Ricky Ponting's salary... */
select I.Salary
from Instructor I, Person P
where P.Name = 'Ricky Ponting' and P.ID = I.InstructorID;

update Instructor
set Salary = Salary * 1.10
where InstructorID in (select P.ID
	from Person P
	where P.Name = 'Ricky Ponting') and 5 <= (select count(*)
		from Enrollment E
        where E.CourseCode = (select O.CourseCode
			from Offering O
            where O.InstructorID = (select P.ID
				from Person P
                where P.Name = 'Ricky Ponting') and E.Grade = 'A' limit 1));
        
select I.Salary
from Instructor I, Person P
where P.Name = 'Ricky Ponting' and P.ID = I.InstructorID;

/* Item 29 - Insert the following information into the Person table. Name: Trevor Horns; ID: 000957303... */
insert into Person (Name, ID, Address, DOB)
values ('Trevor Horns', '000957303', '23 Canberra Street', date('1964-11-23'));

select *
from Person P
where P.Name = 'Trevor Horns';

/* Item 30 - Delete the record for the student Jan Austin from Enrollment and Student tables. */
delete from Student
where StudentID in (select P.ID from Person P where P.Name = 'Jan Austin');

delete from Person
where Name = 'Jan Austin';

select *
from Person P
where P.Name = 'Jan Austin';