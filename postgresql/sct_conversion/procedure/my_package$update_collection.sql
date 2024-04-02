-- Standalone procedure for package sub-procedure
-- This procedure updates the value at the specified index in the associative array
CREATE OR REPLACE PROCEDURE sct_user.my_package$update_collection(IN index_value INTEGER, IN new_value TEXT)
AS 
$BODY$
BEGIN
    PERFORM sct_user.my_package$init();
    PERFORM aws_oracle_ext.array$set_value(p_array_path => 'my_array_var[' || index_value || ']', p_procedure_name => 'sct_user.my_package', p_value => new_value);
END;
$BODY$
LANGUAGE plpgsql;