-- Standalone procedure for package sub-procedure
-- This procedure deletes the element at the specified index from the associative array
CREATE OR REPLACE PROCEDURE sct_user.my_package$delete_element(IN index_value INTEGER)
AS 
$BODY$
BEGIN
    PERFORM sct_user.my_package$init();
    PERFORM aws_oracle_ext.array$set_value(p_array_path => 'my_array_var[' || index_value || ']', p_procedure_name => 'sct_user.my_package', p_value => NULL::CHARACTER VARYING(50));
END;
$BODY$
LANGUAGE plpgsql;