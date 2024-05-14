{{ 
    config(
        materialized='table'
    ) 
}}

WITH vendor_gmv AS (
    SELECT
        v.vendor_name,
        v.country_name,
        EXTRACT(YEAR FROM o.date_local) AS order_year,
        SUM(o.gmv_local) AS total_gmv
    FROM
        `template-for-submission`.test-example.orders o
    LEFT JOIN
        `template-for-submission`.test-example.vendors v
    ON
        o.vendor_id = v.id
    GROUP BY
        v.vendor_name, v.country_name, order_year
),
ranked_vendors AS (
    SELECT
        vendor_name,
        country_name,
        order_year,
        total_gmv,
        ROW_NUMBER() OVER (PARTITION BY country_name, order_year ORDER BY total_gmv DESC) AS rank
    FROM
        vendor_gmv
)
SELECT 
    CONCAT(order_year,'-01-01 T00:00:00') AS year,
    country_name,
    vendor_name,
    ROUND(total_gmv, 2)
FROM ranked_vendors
WHERE rank <= 2
ORDER BY order_year, country_name, rank;