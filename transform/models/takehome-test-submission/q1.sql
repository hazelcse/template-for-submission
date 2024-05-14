{{
    config(
        materialized='view'
    )
}}

SELECT country_name, ROUND(SUM(gmv_local), 2) AS total_gmv
FROM `template-for-submission`.test-example.orders
GROUP BY country_name