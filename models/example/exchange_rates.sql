{{ config(materialized='table') }}

SELECT
    f.key AS country_code,
    f.value::FLOAT AS exchange_rate
FROM (
    SELECT $1 AS json_data
    FROM @"SALES_CDC_DB"."RAW_DATA"."API_JSON_STAGE"/exchange-rates.json
    (FILE_FORMAT => SALES_CDC_DB.RAW_DATA.JSON_FORMAT)
) src
,LATERAL FLATTEN(input => src.json_data[0]:rates) f

