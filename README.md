
# 🧹 SQL Data Cleaning Project – Layoffs Dataset

## 📌 Overview

In this project, I performed end-to-end data cleaning using SQL on a layoffs dataset. The dataset initially contained duplicates, inconsistent formatting, missing values, and irrelevant columns. The goal was to transform the raw data into a clean, structured, and analysis-ready format.

---

## ⚙️ Tools & Technologies

* SQL (MySQL)
* Window Functions
* Common Table Expressions (CTEs)

---

## 🔍 Project Steps

### 1. Creating a Working Copy of the Dataset

To preserve the original dataset, I created a duplicate table and inserted all records into it.

```sql
CREATE TABLE new_data1 LIKE layoffs;

INSERT INTO new_data1
SELECT * FROM layoffs;
```

---

### 2. Identifying and Removing Duplicates

Since the dataset had no unique identifier, I used the `ROW_NUMBER()` window function to generate a temporary unique column and detect duplicates.

```sql
SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY company, location, stage, country, 
    funds_raised_millions, industry, total_laid_off, 
    percentage_laid_off, `date`
) AS row_num
FROM new_data1;
```

Using a CTE, I isolated duplicate records:

```sql
WITH duplicate_cte AS (
    SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, stage, country, 
        funds_raised_millions, industry, total_laid_off, 
        percentage_laid_off, `date`
    ) AS row_num
    FROM new_data1
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
```

Then, I created a new table and removed duplicates:

```sql
CREATE TABLE new_data2 (...);

INSERT INTO new_data2
SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY company, location, stage, country, 
    funds_raised_millions, industry, total_laid_off, 
    percentage_laid_off, `date`
) AS row_num
FROM new_data1;

DELETE FROM new_data2
WHERE row_num > 1;
```

---

### 3. Standardizing Data

To ensure consistency across text fields, I cleaned and standardized values.

* Removed extra spaces:

```sql
UPDATE new_data2
SET company = TRIM(company);
```

* Standardized industry values:

```sql
UPDATE new_data2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';
```

* Standardized country names:

```sql
UPDATE new_data2
SET country = 'United States'
WHERE country LIKE 'United States%';

UPDATE new_data2
SET country = TRIM(country);
```

* Converted date format:

```sql
UPDATE new_data2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE new_data2
MODIFY COLUMN `date` DATE;
```

---

### 4. Handling Missing Values

* Replaced empty strings with NULL:

```sql
UPDATE new_data2
SET industry = NULL
WHERE industry = '';
```

* Filled missing industry values using self-join:

```sql
UPDATE new_data2 t1
JOIN new_data2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
```

---

### 5. Removing Irrelevant Data

Rows with no meaningful layoff data were removed:

```sql
DELETE FROM new_data2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```

---

### 6. Final Cleanup

Dropped the helper column used for duplicate detection:

```sql
ALTER TABLE new_data2
DROP COLUMN row_num;
```

---

## ✅ Final Outcome

* Removed duplicate records
* Standardized inconsistent text values
* Converted date formats
* Handled missing and null values
* Eliminated irrelevant data

The dataset is now clean, consistent, and ready for analysis or visualization.

---

## 🚀 Key Learnings

* Practical use of `ROW_NUMBER()` for deduplication
* Importance of data standardization in analysis
* Efficient handling of NULL values using joins
* Structuring SQL workflows for reproducibility

---

## 📂 Project Structure

```
├── raw_data.sql
├── data_cleaning.sql
└── README.md
```

---

## 💡 Conclusion

This project demonstrates the power of SQL in transforming messy real-world data into a structured format. It highlights essential data cleaning techniques that are critical for any data analysis workflow.

