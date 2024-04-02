# Oracle Package Collections Wrapper for Amazon Aurora

When migrating from Oracle to Amazon Aurora PostgreSQL-Compatible edition or Amazon RDS for PostgreSQL, These comprehensive steps is designed to assist you in navigating the complexities of migrating Oracle PL/SQL collections, specifically those defined globally within a package, to Aurora PostgreSQL. While AWS SCT automates a significant portion of the conversion, there may be scenarios, particularly with complex Oracle collection types (Associative array, Nested table, and VARRAY), where careful manual intervention is necessary. Oracle's collection is an ordered group of elements with the same data type, each identified by a unique subscript representing its position in the collection. Oracle allows the declaration of collection variables in the Package specification, making these values globally accessible across all subprograms in the current session.

Manual Conversion Challenges for Collection Types:

    Associative Array Transformation: Oracle's Associative Arrays, indexed by VARCHAR or PLS_INTEGER, often require manual adjustment during the migration. The unique indexing mechanism in PostgreSQL may demand changes to ensure compatibility and optimal performance.

    Nested Table Considerations: Migrating Oracle Nested Tables to their PostgreSQL equivalents involves not only syntax adjustments but also considerations for how these structures interact within the database. Manual conversion is crucial to maintaining data integrity and relational structures.

    VARRAY Migration Nuances: Variable arrays (VARRAYs) in Oracle may have distinct characteristics compared to PostgreSQL. Manual conversion becomes essential to address differences in handling array sizes, indexing, and storage mechanisms.

## Solution Overview

In the process of converting Oracle global type collections to PostgreSQL, we have opted to use native PostgreSQL arrays rather than the aws_oracle_ext functions. The decision to use PostgreSQL native arrays aims to showcase an alternative approach for users familiar with PostgreSQL's built-in capabilities, deviating from the use of aws_oracle_ext and PL/v8 language.

At a high level, the solution steps are as follows:

    - We used a session-level temporary table (my_temp_table) to simulate the global nature of the Oracle associative array. The initialization function, my_package$init(), checks if the temporary table exists and creates it if it doesn't. This function is designed to be called at the beginning of sessions or when needed.
    
    - The procedure, my_package$update_collection, is modified to use the session-level temporary table. If the specified index does not exist, a new row is inserted; otherwise, the existing row is updated. 
    
    - The delete procedure, my_package$delete_element, is modified to delete the element at the specified index from the session-level temporary table.

    - The print procedure, my_package$print_collection, is modified to iterate over the rows of the session-level temporary table and print the array index and value.

These modifications ensure that the Oracle associative array operations are emulated in PostgreSQL using a session-level temporary table.

## Requirements


prerequisites in place:

* A basic understanding of PL/SQL programming concepts and familiarity with the Oracle database environment. Additionally, some knowledge of PostgreSQL PL/pgSQL.

* To follow along with the examples and implement the migration process, you need access to an Amazon Aurora PostgreSQL instance with the latest minor version available for 11 and above or an Amazon RDS for PostgreSQL instance with the latest minor version available for 11 and above inside a VPC.

* AWS SCT, can be a valuable asset during the migration process. AWS SCT converts the code and helps identify potential schema and code compatibility issues between Oracle and Aurora PostgreSQL. Using AWS SCT can significantly streamline the migration process and minimize manual effort.


## Connecting to Source and Target Database

### Oracle:
To connect to the source Oracle database using SQL*Plus, you can use the following command:

```
sqlplus <username>/<password>@<hostname>:1521/<SID>
```
Replace <username> with Oracle username, <password> with database password, <hostname> with the hostname or IP address of your Oracle database server, and <SID> with your Oracle System Identifier.

### PostgreSQL:
To connect to the target Aurora PostgreSQL database using psql, you can use the following command:

```
psql -h <endpoint> -U <username> -d <database_name> -p 5432 -W
```
Replace <endpoint> with the endpoint of Aurora PostgreSQL instance, <username> with your PostgreSQL username, and <database_name> with the name of your PostgreSQL database.

### Security Group Configuration:

Ensure that your AWS security group configurations allow traffic on ports 1521 for Oracle and 5432 for PostgreSQL.

- Go to the AWS Management Console and navigate to the EC2 Dashboard.
- In the navigation pane, choose "Security Groups".
- Select the appropriate security group associated with your Oracle and Aurora PostgreSQL instances.
- Edit the inbound rules to allow traffic on ports 1521 and 5432 from your desired IP ranges or sources.

It's crucial to ensure that the necessary ports are open in your security group to establish connections successfully between your clients and the databases.

Additionally, Refer to the guide on steps to [configuring your source and target database](https://docs.aws.amazon.com/dms/latest/sbs/schema-conversion-oracle-postgresql-step-by-step-migration.html)

## Oracle Database Deployment
    - Connect to Oracle DB Instance
    - Navigate to repo and "cd oracle" for Oracle deployment
    - Run the file '@install.sql', to create an schema user and deploy objects

SQL> @install.sql

User created.


Session altered.


Package created.


Package body created.


## SCT code PostgreSQL Database Deployment

    - Connect to Aurora PostgreSQL DB Instance
    - Navigate to repo and cd /postgresql/sct_conversion for sct converted code deployment
    - Run the file `install.sql`, to create an utility schema and wrapper objects
    
    postgres=> \i install.sql
    CREATE SCHEMA
    CREATE TYPE
    CREATE FUNCTION
    CREATE PROCEDURE
    CREATE PROCEDURE
    CREATE PROCEDURE
    
   Note: Once after manual code deployment sct code will override with manual code to validate sct code re-deploy the sct code
 ## Manual code PostgreSQl database Deployment
    - Connect to Aurora PostgreSQL DB Instance
    - Navigate to repo and cd /postgresql/manual_conversion for sct converted code deployment
    - Run the file `install.sql`, to create an utility schema and wrapper objects
    
    postgres=> \i install.sql
    CREATE SCHEMA
    DROP TYPE
    CREATE TYPE
    CREATE TYPE
    CREATE FUNCTION
    CREATE PROCEDURE
    CREATE PROCEDURE
    CREATE PROCEDURE
     

## Testing
This anonymous code blocks demonstrates a sample PL/pgSQL procedure that utilizes various procedure and functions from the package to perform globle collection data read,update and delete operations.


```
set search_path=sct_user;
DO
$$ DECLARE
BEGIN	
    CALL my_package$update_collection(1, 'scott');
    CALL my_package$update_collection(2, 'tiger');
    CALL my_package$update_collection(3, 'foo');

    RAISE NOTICE 'Printing Array after Insert';
    CALL my_package$print_collection();

    -- Delete element
    CALL my_package$delete_element(3);

    RAISE NOTICE 'Printing Array after Delete';
    CALL my_package$print_collection();	

END;
$$ LANGUAGE PLPGSQL;
```
Output: 
========
NOTICE:  Printing Array after Insert
NOTICE:  Index: 1, Value: scott
NOTICE:  Index: 2, Value: tiger
NOTICE:  Index: 3, Value: foo
NOTICE:  Printing Array after Delete
NOTICE:  Index: 1, Value: scott
NOTICE:  Index: 2, Value: tiger
DO


## Cleanup

    - Connect to Aurora PostgreSQL DB Instance
    - Run the file `postgresql/manual_conversion/uninstall.sql`, to drop utility schema and wrapper objects
    - Delete the Lambda Function that was created using AWS CLI
    
    - Connect to oracle DB Instance
    - Run the file `oracle/uninstall.sql`, to drop utility schema and wrapper objects
    - Delete the Lambda Function that was created using AWS CLI
    
## License

This library is licensed under the MIT-0 License. See the LICENSE file.