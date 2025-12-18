{{ config(materialized='table') }}

SELECT
    sales."ORDERID" AS id,
    sales."ORDERLINEID" AS order_line_id,
    sales."ORDERDATE" AS order_date,
    sales."CUSTOMERID" AS customer_id,
    sales."PRODUCTID" AS product_id,
    sales."QUANTITY" AS quantity,
    sales."UNITPRICE" AS unit_price,
    sales."UNITPRICE" * currency.exchange_rate AS unit_price_usd,
    sales."DISCOUNT" AS discount,
    sales."DISCOUNT" * currency.exchange_rate AS discount_usd,
    sales."TAXAMOUNT" AS tax_amount,
    sales."TAXAMOUNT" * currency.exchange_rate AS tax_amount_usd,
    sales."CURRENCYCODE" AS currency_code,
    currency.exchange_rate AS exchange_rate,
    ROUND(
        (sales."QUANTITY" * (unit_price_usd - discount_usd - tax_amount_usd)),
        2
    ) AS sales_amount_usd
FROM "SALES_CDC_DB"."RAW_DATA".SALES sales
LEFT OUTER JOIN {{ ref('exchange_rates') }} currency
    ON sales."CURRENCYCODE" = currency.country_code
