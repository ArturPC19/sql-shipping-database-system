# Shipping Logistics Database — SQL Project

A complete relational database system designed to manage national and international shipping operations, built for the final exam of the Databases course.

## Project Overview

This project consists of designing, implementing, and validating a relational database for a shipping company.  
The system manages:

- Packages  
- National and international shipments  
- Local companies  
- Drivers  
- Trucks  
- Route assignments  
- Package–truck assignment  
- Shipping counters per city  
- Automatic validations via triggers  
- A stored procedure for detailed shipment reporting  

All database logic was implemented using SQL Server, including table creation, constraints, triggers, and stored procedures.


## Main Components

### 1. Database Schema

The schema includes fully normalized tables with proper PK–FK relationships:

- **Paquete** – master table for package information  
- **Nacional** & **Internacional** – mutually exclusive shipping types  
- **Conductor**, **Camion**, **Conduce** – driver, truck, and assignment tracking  
- **Rutas** – multiple routes for national shipments  
- **C_Local** – local airline companies for international shipments  
- **ConteoEnvios** – aggregated count of shipments per destination city  
- **AsignacionPaquetes** – package–truck assignment  


## Data Integrity & Business Logic

### Exclusivity Triggers

Guarantee that a shipment can only be recorded as **Nacional** OR **Internacional**, never both.

- TRG_Paquete_Exclusividad_Nacional  
- TRG_Paquete_Exclusividad_Internacional

These triggers check for conflicts and prevent invalid inserts.

### Truck Capacity Trigger

#### `TRG_Validar_CargaCamion`

Prevents registering trucks with cargo limits lower than 250 kg or higher than 1250 kg.  
If violated, a custom error message is raised to enforce business logic.


### National Shipments Counter Trigger

#### `TRG_Actualizar_ConteoEnvios`

Automatically increments or creates a shipment counter per destination city each time a new national shipment is added.


### Stored Procedure

#### `ObtenerDetallesEnvio`

Given a package code, this stored procedure returns detailed shipment information.

**For national shipments:**

- ID  
- Shipping type  
- Address  
- Weight  
- Driver  
- Assigned truck  
- Assignment date  
- List of all assigned routes  

**For international shipments:**

- ID  
- Shipping type  
- Address  
- Airline  
- Local company code  


## Testing & Validation

All triggers and procedures were thoroughly tested using:

- Valid inserts  
- Invalid inserts to trigger errors  
- Cross-type conflicts (package appearing in both tables)  
- New city creation for shipment counters  
- Execution of the stored procedure with national and international package codes  

All test queries and examples are included in the SQL file.


## My Contributions

I actively contributed to:

### Planning and Designing the Database Schema  
Ensuring correct relationships, dependencies, and entity structure across the system.

### Creating Tables, Constraints, and Business Rules  
Including primary and foreign keys, CHECK constraints, triggers, and referential integrity rules.

### Validating Logic Through Test Inserts and Debugging  
Executed multiple test cases to verify that triggers and stored procedures behaved correctly under all scenarios.

### Co-building the Stored Procedure  
Participated in the construction of the reporting procedure, including route concatenation and conditional logic depending on shipment type.


## Tools & Technologies

- SQL Server  
- T-SQL  
- Stored Procedures  
- Triggers  
- Constraints & Data Integrity Rules  
- Relational Modeling  
- Entity–Relationship and Relational Diagrams  

