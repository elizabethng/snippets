/* 
Create, alter, and drop table
following https://www.youtube.com/watch?v=UuySnxAsVJ4 
note, to see updates in Object Explorer may need to hit refresh
*/

use entest
CREATE TABLE tbl_user(
	user_id int,
	full_name varchar(100),
	gender varchar(10),
	age int
);

SELECT * FROM tbl_user;

sp_rename'tbl_user', 'tbl_newuser';

SELECT * FROM tbl_user;
SELECT * FROM tbl_newuser;

DROP TABLE tbl_newuser