This directory contains database model.

The database model has to be exported to an SQL script. This can be achieved in
a few steps by using MySQL Workbench user interface:

1) Open the database model file.
2) From the main menu choose "Database" -> "Forward Engineer" or press Ctrl-G. A
   new pop-up window should appear on the screen.
3) In the "Options" section of a new window make sure that only the following
   options are selected:

        DROP Objects Before Each CREATE Object
        Generate DROP SCHEMA
        Generate INSERT Statements for Tables

4) In the "Select Objects" section, check if all the relevant objects are
   included in the exporte.
5) Save file as shellos/src/pkg/shellos/shellos.sql

