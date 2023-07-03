/* 
ALTER TABLE exploration
- created a sample database
- manually enetered some data
- goal- add a where statement to the table so only a subset of 
	data are selected (in this case, gender = female)
*/

/* This view (terminology?) is what I want my table to look like*/
SELECT * FROM tbl_user
WHERE gender = 'female';

/* 
first attempt, create a copy
based on https://stackoverflow.com/questions/18254104/how-do-i-create-a-table-based-on-another-table
great this works! took a min for the OE to update though, keep that in mind
*/

SELECT * INTO tbl_women 
FROM tbl_user
WHERE gender = 'female';

SELECT * FROM tbl_user
SELECT * FROM tbl_women;

/* 
So one approach would be to rename `tbl_women` `tbl_user` and then delete `tbl_women` 
make a back up of tbl_user for convenience
*/

SELECT * INTO tbl_user_copy 
FROM tbl_user;

sp_rename'tbl_women', 'tbl_user'; /*not permitted*/
SELECT * FROM tbl_user;

/* different appraoch 
https://stackoverflow.com/questions/11940477/try-to-create-a-table-from-select-sql-server-2008-throws-error?noredirect=1&lq=1
*/

/* Whoops this just adds duplicate rows! */
INSERT INTO tbl_user 
SELECT * FROM tbl_user
WHERE gender = 'female';

SELECT * FROM tbl_user;


/* Perhaps Views is the better appraoch?
https://www.w3schools.com/sql/sql_view.asp
*/
CREATE VIEW [view_men] AS
SELECT *
FROM tbl_user
WHERE gender = 'male';

SELECT * FROM view_men; 
/* Ok so that would work for my problem, but then would I just re-write the code to look a the view instead of the table? */