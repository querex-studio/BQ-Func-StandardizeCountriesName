-- =============================================================================
-- Test Cases for standard_country_name UDF
-- =============================================================================
-- Run these tests after deploying the function to verify it works correctly.
-- All tests should return is_pass = TRUE
-- =============================================================================

WITH test_cases AS (
  SELECT * FROM UNNEST([
    -- -------------------------------------------------------------------------
    -- Standard ISO names (should return themselves)
    -- -------------------------------------------------------------------------
    STRUCT('United States' AS input, 'United States' AS expected, 'Standard name: United States' AS test_name),
    ('United Kingdom', 'United Kingdom', 'Standard name: United Kingdom'),
    ('Germany', 'Germany', 'Standard name: Germany'),
    ('France', 'France', 'Standard name: France'),
    ('Japan', 'Japan', 'Standard name: Japan'),
    ('Australia', 'Australia', 'Standard name: Australia'),
    
    -- -------------------------------------------------------------------------
    -- ISO 2-letter codes
    -- -------------------------------------------------------------------------
    ('US', 'United States', 'ISO code: US'),
    ('GB', 'United Kingdom', 'ISO code: GB'),
    ('DE', 'Germany', 'ISO code: DE'),
    ('FR', 'France', 'ISO code: FR'),
    ('JP', 'Japan', 'ISO code: JP'),
    ('AU', 'Australia', 'ISO code: AU'),
    ('CN', 'China', 'ISO code: CN'),
    ('BR', 'Brazil', 'ISO code: BR'),
    ('IN', 'India', 'ISO code: IN'),
    ('CA', 'Canada', 'ISO code: CA'),
    
    -- -------------------------------------------------------------------------
    -- Common aliases - United States
    -- -------------------------------------------------------------------------
    ('USA', 'United States', 'Alias: USA'),
    ('U.S.A.', 'United States', 'Alias: U.S.A.'),
    ('U.S.', 'United States', 'Alias: U.S.'),
    ('United States of America', 'United States', 'Alias: United States of America'),
    ('America', 'United States', 'Alias: America'),
    
    -- -------------------------------------------------------------------------
    -- Common aliases - United Kingdom
    -- -------------------------------------------------------------------------
    ('UK', 'United Kingdom', 'Alias: UK'),
    ('U.K.', 'United Kingdom', 'Alias: U.K.'),
    ('Great Britain', 'United Kingdom', 'Alias: Great Britain'),
    ('Britain', 'United Kingdom', 'Alias: Britain'),
    ('England', 'United Kingdom', 'Alias: England'),
    
    -- -------------------------------------------------------------------------
    -- Common aliases - Other countries
    -- -------------------------------------------------------------------------
    ('Russia', 'Russian Federation', 'Alias: Russia'),
    ('South Korea', 'Korea, Republic of', 'Alias: South Korea'),
    ('North Korea', 'Korea, Democratic People''s Republic of', 'Alias: North Korea'),
    ('Iran', 'Iran, Islamic Republic of', 'Alias: Iran'),
    ('Syria', 'Syrian Arab Republic', 'Alias: Syria'),
    ('Vietnam', 'Viet Nam', 'Alias: Vietnam'),
    ('Taiwan', 'Taiwan, Province of China', 'Alias: Taiwan'),
    ('Bolivia', 'Bolivia, Plurinational State of', 'Alias: Bolivia'),
    ('Venezuela', 'Venezuela, Bolivarian Republic of', 'Alias: Venezuela'),
    ('UAE', 'United Arab Emirates', 'Alias: UAE'),
    ('Holland', 'Netherlands', 'Alias: Holland'),
    ('Czech', 'Czech Republic', 'Alias: Czech'),
    ('Czechia', 'Czech Republic', 'Alias: Czechia'),
    ('Burma', 'Myanmar', 'Alias: Burma'),
    ('Ivory Coast', 'Côte d''Ivoire', 'Alias: Ivory Coast'),
    
    -- -------------------------------------------------------------------------
    -- Case insensitivity
    -- -------------------------------------------------------------------------
    ('usa', 'United States', 'Case: lowercase usa'),
    ('USA', 'United States', 'Case: uppercase USA'),
    ('Usa', 'United States', 'Case: mixed case Usa'),
    ('GERMANY', 'Germany', 'Case: uppercase GERMANY'),
    ('germany', 'Germany', 'Case: lowercase germany'),
    ('GeRmAnY', 'Germany', 'Case: mixed case GeRmAnY'),
    
    -- -------------------------------------------------------------------------
    -- Accent handling
    -- -------------------------------------------------------------------------
    ('Côte d''Ivoire', 'Côte d''Ivoire', 'Accent: Côte d''Ivoire'),
    ('Cote d''Ivoire', 'Côte d''Ivoire', 'Accent: Cote d''Ivoire (no accent)'),
    ('Türkiye', 'Turkey', 'Accent: Türkiye'),
    ('Turkiye', 'Turkey', 'Accent: Turkiye (no accent)'),
    ('Réunion', 'Réunion', 'Accent: Réunion'),
    ('Reunion', 'Réunion', 'Accent: Reunion (no accent)'),
    ('Curaçao', 'Curaçao', 'Accent: Curaçao'),
    ('Curacao', 'Curaçao', 'Accent: Curacao (no accent)'),
    ('Åland Islands', 'Åland Islands', 'Accent: Åland Islands'),
    ('Aland Islands', 'Åland Islands', 'Accent: Aland Islands (no accent)'),
    
    -- -------------------------------------------------------------------------
    -- Whitespace and punctuation handling
    -- -------------------------------------------------------------------------
    ('  United States  ', 'United States', 'Whitespace: leading/trailing spaces'),
    ('United  States', 'United States', 'Whitespace: double space'),
    ('UnitedStates', 'United States', 'Whitespace: no space'),
    ('U.S.A', 'United States', 'Punctuation: U.S.A (no trailing dot)'),
    
    -- -------------------------------------------------------------------------
    -- Saint variations
    -- -------------------------------------------------------------------------
    ('Saint Lucia', 'Saint Lucia', 'Saint: Saint Lucia'),
    ('St Lucia', 'Saint Lucia', 'Saint: St Lucia'),
    ('St. Lucia', 'Saint Lucia', 'Saint: St. Lucia'),
    ('Saint Kitts and Nevis', 'Saint Kitts and Nevis', 'Saint: Saint Kitts and Nevis'),
    ('St Kitts and Nevis', 'Saint Kitts and Nevis', 'Saint: St Kitts and Nevis'),
    
    -- -------------------------------------------------------------------------
    -- Abbreviated country names
    -- -------------------------------------------------------------------------
    ('DRC', 'Congo, the Democratic Republic of the', 'Abbreviation: DRC'),
    ('DPRK', 'Korea, Democratic People''s Republic of', 'Abbreviation: DPRK'),
    ('PNG', 'Papua New Guinea', 'Abbreviation: PNG'),
    ('BVI', 'Virgin Islands, British', 'Abbreviation: BVI'),
    ('USVI', 'Virgin Islands, U.S.', 'Abbreviation: USVI'),
    
    -- -------------------------------------------------------------------------
    -- Edge cases
    -- -------------------------------------------------------------------------
    ('', NULL, 'Edge case: empty string'),
    ('   ', NULL, 'Edge case: only whitespace'),
    ('xyz', NULL, 'Edge case: unrecognized input'),
    ('NotACountry', NULL, 'Edge case: invalid country name')
  ])
),

results AS (
  SELECT
    test_name,
    input,
    expected,
    `your_project.your_dataset.standard_country_name`(input) AS actual,
    CASE 
      WHEN expected IS NULL AND `your_project.your_dataset.standard_country_name`(input) IS NULL THEN TRUE
      WHEN `your_project.your_dataset.standard_country_name`(input) = expected THEN TRUE
      ELSE FALSE
    END AS is_pass
  FROM test_cases
)

SELECT
  test_name,
  input,
  expected,
  actual,
  is_pass,
  CASE WHEN is_pass THEN '✓' ELSE '✗' END AS status
FROM results
ORDER BY is_pass, test_name;


-- =============================================================================
-- Summary
-- =============================================================================

-- SELECT
--   COUNT(*) AS total_tests,
--   COUNTIF(is_pass) AS passed,
--   COUNTIF(NOT is_pass) AS failed,
--   ROUND(COUNTIF(is_pass) * 100.0 / COUNT(*), 1) AS pass_rate
-- FROM results;
