-- This function initializes the global variables and the associative array
-- It is designed to be called at the beginning of sessions or when needed
CREATE OR REPLACE FUNCTION sct_user.my_package$init()
RETURNS void
AS
$BODY$
DECLARE 
BEGIN
	IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'my_temp_table') THEN
		CREATE TEMPORARY TABLE my_temp_table (
		  array_index INTEGER PRIMARY KEY,
		  array_value TEXT
		);
	END IF;
END;
$BODY$
LANGUAGE plpgsql;