-- Standalone procedure for package sub-procedure
-- This procedure updates the value at the specified index in the associative array
CREATE OR REPLACE PROCEDURE sct_user.my_package$update_collection(IN index_value INTEGER, IN new_value TEXT)
AS 
$BODY$
BEGIN
  PERFORM my_package$init();  
  -- Initialize the array if not already initialized
  IF NOT EXISTS (SELECT 1 FROM my_temp_table WHERE array_index = index_value) THEN
    INSERT INTO my_temp_table (array_index, array_value) VALUES (index_value, new_value);
  ELSE
    -- Update the value at the specified index
    UPDATE my_temp_table SET array_value = new_value WHERE array_index = index_value;
  END IF;	
END;
$BODY$
LANGUAGE plpgsql;