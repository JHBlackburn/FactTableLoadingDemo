# FactTableLoadingDemo

This is a sample data warehouse containing one fact and three dimensions.
The purpose of this database is to test the speed of loading a single table by various methods.

Contained is one starter SSIS package which truncates and loads data into the Fact table (FactAccountBillingType). It is currently configured to create ~50 million rows using a stored procedure and load them into the afformentioned table using a data pipeline. 

There also exist several "metric" objects which are designed to capture row count as a function of time and report on instantaneous row velocity.

The hope is this will provide a sandbox for experimenting with different table configurations such as:
1. adding or dropping indexes
2. adding or dropping foreign keys
3. file partitioning, pre-growing, etc.
4. Using sprocs, temp tables, ctes, etc to acheive maximum throughput to the buffer
5. Different hardware and/or SAN configurations

and anything else a data warehouse profession should want to test. 

