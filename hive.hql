CREATE DATABASE demo;

CREATE TABLE demo.users(
   id INT,
   title STRING,
   firstname STRING,
   lastname STRING,
   street STRING,
   city STRING,
   state STRING,
   zip STRING,
   gender STRING,
   email STRING,
   username STRING,
   password STRING,
   phone STRING,
   cell STRING,
   ssn STRING,
   date_of_birth STRING,
   reg_date STRING,
   largep STRING,
   medium STRING,
   thumbnail STRING,
   versionp STRING,
   nationality STRING
  )
  STORED AS PARQUET;
