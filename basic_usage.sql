-- =============================================================================
-- Basic Usage Examples
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Example 1: Single value standardization
-- -----------------------------------------------------------------------------

SELECT `your_project.your_dataset.standard_country_name`('USA') AS result;
-- Returns: United States

SELECT `your_project.your_dataset.standard_country_name`('uk') AS result;
-- Returns: United Kingdom

SELECT `your_project.your_dataset.standard_country_name`('DE') AS result;
-- Returns: Germany


-- -----------------------------------------------------------------------------
-- Example 2: Standardize a column in a table
-- -----------------------------------------------------------------------------

SELECT
  country AS original_country,
  `your_project.your_dataset.standard_country_name`(country) AS standard_country
FROM your_table;


-- -----------------------------------------------------------------------------
-- Example 3: Filter by standardized country
-- -----------------------------------------------------------------------------

SELECT *
FROM your_table
WHERE `your_project.your_dataset.standard_country_name`(country) = 'United States';


-- -----------------------------------------------------------------------------
-- Example 4: Group by standardized country
-- -----------------------------------------------------------------------------

SELECT
  `your_project.your_dataset.standard_country_name`(country) AS country,
  COUNT(*) AS record_count,
  SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY 1
ORDER BY total_revenue DESC;


-- -----------------------------------------------------------------------------
-- Example 5: Join tables using standardized country names
-- -----------------------------------------------------------------------------

SELECT
  a.*,
  b.population,
  b.gdp
FROM your_table a
LEFT JOIN country_stats b
  ON `your_project.your_dataset.standard_country_name`(a.country) = b.country_name;


-- -----------------------------------------------------------------------------
-- Example 6: Create a standardized view
-- -----------------------------------------------------------------------------

CREATE OR REPLACE VIEW `your_project.your_dataset.sales_standardized` AS
SELECT
  *,
  `your_project.your_dataset.standard_country_name`(country) AS country_standardized
FROM sales_data;


-- -----------------------------------------------------------------------------
-- Example 7: Find unrecognized country values
-- -----------------------------------------------------------------------------

SELECT DISTINCT
  country AS unrecognized_country,
  COUNT(*) AS occurrences
FROM your_table
WHERE `your_project.your_dataset.standard_country_name`(country) IS NULL
GROUP BY 1
ORDER BY occurrences DESC;


-- -----------------------------------------------------------------------------
-- Example 8: Data quality report
-- -----------------------------------------------------------------------------

SELECT
  COUNT(*) AS total_records,
  COUNTIF(`your_project.your_dataset.standard_country_name`(country) IS NOT NULL) AS matched_records,
  COUNTIF(`your_project.your_dataset.standard_country_name`(country) IS NULL) AS unmatched_records,
  ROUND(
    COUNTIF(`your_project.your_dataset.standard_country_name`(country) IS NOT NULL) * 100.0 / COUNT(*), 
    2
  ) AS match_rate_percent
FROM your_table;
