-- PostgreSQL equivalent type for the Oracle associative array
DROP TYPE IF EXISTS sct_user.my_package$my_array$c;
CREATE TYPE sct_user.my_package$my_array$c AS (
column_value CHARACTER VARYING(50)
);