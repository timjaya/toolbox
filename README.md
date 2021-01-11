# toolbox
A collection of useful R Functions for Data Science work. Current functionality is focused on helping push/pull to TD, make fiscper, MLFlow logging, etc.

## Installation
Simply use `devtools::install_github("timjaya/toolbox")`.

## Teradata SQL 
The most common way to run SQL in R is usually through `DBI`, `odbc`, and `RJDBC`. However, when using Teradata with R, there are some limitations. For example, multi-line SQL queries cannot be run with `dbGetQuery`, and often get DDL errors.

Furthermore, OSX and Windows use different libraries (odbc vs. RJBDC), which makes code reproducibility difficult. As a solution, `toolbox` includes some functions to improve the TD SQL <-> R workflow, that works for both Windows and OSX. Below are steps to get your SQL running:

### 1. First, create a connection to TD.

#### Windows (Note: set up ODBC in your system first)
```r
td_id <- "TDXYXY123" # the TD name you used in ODBC setup
td_con <- create_td_connection(td_id)

# alternatively, you can use odbc functions
td_con <- DBI::dbConnect(odbc::odbc(), td_id)
```

#### OSX
```r
td_id <- "TDXYXY123_64" # the TD id you used in ODBC setup
td_pwd <- "password" # (OSX only) your Teradata password
jdbc_path <- "~/terajdbc4.jar" # (OSX only) path to JDBC file
url <- "jdbc::teradata//..." # your organization's TD url
td_con <- create_td_connection(td_id, td_pwd, jdbc_path, url)

# alternatively, you can use RJDBC::dbConnect()
```

### 2. Now use the TD connection object to run multi-line queries.

**Warning**: Makes sure your queries end with `;` and formatted correctly!
```r
query <- "
  CREATE VOLATILE MULTISET TABLE test AS (
    SELECT * FROM td_table SAMPLE 10
  ) WITH DATA PRIMARY INDEX(customer) ON COMMIT PRESERVE ROWS;

  SELECT * FROM td_table;"
run_query(td_con, query)
```

### 3. Reset your connection by recreating the TD connection object.

### 4. Write your SQL in a separate file and load/run it.

```r
read_sql_file("query.sql")
#> [1] " CREATE VOLATILE MULTISET TABLE test AS (     SELECT * FROM td_table SAMPLE 10   ) WITH DATA PRIMARY INDEX(customer) ON COMMIT PRESERVE ROWS;    SELECT * FROM td_table;"

query <- read_sql_file("query.sql")
run_query(td_con, query)
```

## Fiscper Functions

- `make_fiscper` to create Fiscper from Dates 
- `fiscper_date` to create Dates from Fiscper

## Coming Soon! 
- R STO Templating
- Writing Tables to Teradata (for windows, use `DBI::dbWriteTable`)



