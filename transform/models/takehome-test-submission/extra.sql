{{
    config(
        materialized='view'
    )
}}

SELECT year, vendor_name, total_gmv
FROM {{ ref('q4') }}
WHERE country_name = 'Singapore'
ORDER BY total_gmv DESC