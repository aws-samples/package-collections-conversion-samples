-- Standalone procedure for package sub-procedure
-- This procedure deletes the element at the specified index from the associative array
CREATE OR REPLACE PROCEDURE sct_user.my_package$delete_element(IN index_value INTEGER)
AS 
$BODY$
BEGIN
    PERFORM my_package$init();
    -- Delete the element at the specified index
    DELETE FROM my_temp_table WHERE array_index = index_value;
END;
$BODY$
LANGUAGE plpgsql;