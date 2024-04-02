-- Package Specification
create or replace package sct_user.my_package is
  TYPE my_array IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
  my_array_var my_package.my_array;

  PROCEDURE update_collection(index_value BINARY_INTEGER,
                              new_value   VARCHAR2);

  PROCEDURE delete_element(index_value BINARY_INTEGER);

  PROCEDURE print_collection;
end my_package;
/

-- Package Body
create or replace package body sct_user.my_package is
  PROCEDURE update_collection(index_value BINARY_INTEGER,
                              new_value   VARCHAR2) IS
  BEGIN
    my_array_var(index_value) := new_value;
  END update_collection;
  
  PROCEDURE delete_element(index_value BINARY_INTEGER) IS
  BEGIN
    my_array_var.DELETE(index_value); 
  END delete_element;
  
  PROCEDURE print_collection IS
    v_index BINARY_INTEGER;
    v_value VARCHAR2(50);
  BEGIN
    v_index := my_array_var.FIRST;    
    WHILE v_index IS NOT NULL LOOP
        v_value := my_array_var(v_index);
        DBMS_OUTPUT.PUT_LINE('Index: ' || v_index || ', Value: ' || v_value);
        v_index := my_array_var.NEXT(v_index);
    END LOOP;    
  END print_collection;

end my_package;
/