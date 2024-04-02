-- Standalone procedure for package sub-procedure
-- This procedure prints the element index and its value from the associative array
CREATE OR REPLACE PROCEDURE sct_user.my_package$print_collection()
AS 
$BODY$
DECLARE
    v_index INTEGER;
    v_value CHARACTER VARYING(50);
BEGIN
    PERFORM sct_user.my_package$init();
    v_index := aws_oracle_ext.array$first('my_array_var', 'sct_user.my_package', NULL::BIGINT);

    WHILE v_index IS NOT NULL LOOP
        v_value := (aws_oracle_ext.array$get_value(p_array_value_path => 'my_array_var[' || v_index || ']', p_procedure_name => 'sct_user.my_package', p_value_datatype => NULL::sct_user.my_package$my_array$c)).column_value;
        RAISE DEBUG USING MESSAGE = CONCAT_WS('', 'Index: ', v_index, ', Value: ', v_value);
        v_index := aws_oracle_ext.array$next('my_array_var', v_index::TEXT, 'sct_user.my_package', NULL::BIGINT);
    END LOOP;
END;
$BODY$
LANGUAGE plpgsql;