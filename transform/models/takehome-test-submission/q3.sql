{{ 
    config(
        materialized='view'
    ) 
}}

WITH vendor_gmv AS (
    SELECT
        v.vendor_name,
        v.country_name,
        ROUND(SUM(o.gmv_local), 2) AS total_gmv
    FROM
        `template-for-submission`.test-example.orders o
    LEFT JOIN
        `template-for-submission`.test-example.vendors v
    ON
        o.vendor_id = v.id
    GROUP BY
        v.vendor_name, v.country_name
),
ranked_vendors AS (
    SELECT
        vendor_name,
        country_name,
        total_gmv,
        ROW_NUMBER() OVER (PARTITION BY country_name ORDER BY total_gmv DESC) AS rank
    FROM
        vendor_gmv
)
SELECT
    vendor_name,
    country_name,
    total_gmv
FROM
    ranked_vendors
WHERE
    rank = 1;