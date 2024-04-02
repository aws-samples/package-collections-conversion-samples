-- Standalone procedure for package sub-procedure
-- This procedure prints the element index and its value from the associative array
CREATE OR REPLACE PROCEDURE sct_user.my_package$print_collection()
AS 
$BODY$
DECLARE
    i record;
BEGIN
    PERFORM my_package$init();
    -- Print the columns of the temporary table
    FOR i IN SELECT array_index, array_value FROM my_temp_table 
    LOOP
	RAISE NOTICE 'Index: %, Value: %', i.array_index, i.array_value;
    END LOOP;	
END;
$BODY$
LANGUAGE plpgsql;