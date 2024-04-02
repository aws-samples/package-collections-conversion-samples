--------------------------------------------------------
-- 
-- !!! log in as a user with DBA privilege 
--
--------------------------------------------------------

-- Spool to output
spool install-db.out


--------------------------------------------------------
--
-- The sct_user user/schema contains the objects and data
-- for this database. 
--
-- The following script creates the user sct_user/sct_user
-- it is recommended that you change the password
-- after creating the account.
--
---------------------------------------------------------

@schema/sct_user_creation_grants.sql

--------------------------------------------------------
--
-- install the objects in the sct_user schema
--
---------------------------------------------------------
alter session set current_schema = sct_user;
@package/my_package.sql


-- stop spooling output

spool off