-- This function initializes the global variables and the associative array
-- It is designed to be called at the beginning of sessions or when needed
CREATE OR REPLACE FUNCTION sct_user.my_package$init()
RETURNS void
AS
$BODY$
DECLARE aws_oracle_ext$array_id$temporary BigInt;
BEGIN
IF aws_oracle_ext.packageinitialize(proutinename => 'sct_user.my_package') THEN
aws_oracle_ext$array_id$temporary := aws_oracle_ext.array$create_array(p_array_name => 'my_array_var', p_procedure_name => 'sct_user.my_package');
PERFORM aws_oracle_ext.array$add_fields_to_array(p_array_id => aws_oracle_ext$array_id$temporary, p_fields => '[{"":"CHARACTER VARYING(50)"}]');
PERFORM aws_oracle_ext.array$create_storage_table(p_array_name => 'my_array_var', p_procedure_name => 'sct_user.my_package', p_cast_type_name => 'sct_user.my_package$my_array$c', pWithData => FALSE);
ELSE
  RETURN;
END IF;
END;
$BODY$
LANGUAGE  plpgsql;
