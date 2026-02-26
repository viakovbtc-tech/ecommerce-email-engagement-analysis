# Global Sales EDA

## Project Overview

This project presents an end-to-end Exploratory Data Analysis (EDA) of a global retail company operating both online and offline sales channels.

The objective was to clean, transform, merge, and analyze transactional, product, and geographic data in order to extract business insights and identify growth opportunities.

---

## Dataset

The analysis is based on three datasets:

- **events.csv** — transactional sales data
- **products.csv** — product categories and product IDs
- **countries.csv** — country codes, regions, and sub-regions

Key relationships:
- `Product ID` → connects events to products
- `Country Code (alpha-3)` → connects events to countries

---

## Data Preparation

The project includes:

- Missing value handling
- Type conversion (dates, numeric fields)
- Duplicate detection and text normalization
- Logical consistency checks
- Feature engineering:
  - Revenue
  - Profit
  - Shipping delay
  - Time-based features (month, weekday)

---

## Key Business Questions

1. Which product categories generate the highest revenue and profit?
2. Which regions and countries drive performance?
3. Is there monthly or weekly seasonality?
4. Does shipping delay affect profitability?
5. How do online and offline channels compare?

---

## Key Insights

- Europe is the dominant revenue-generating region.
- Office Supplies and Household categories form the financial core of the business.
- Sales demonstrate clear monthly and weekly seasonality.
- Shipping delay varies significantly by country.
- No strong direct relationship between delivery speed and profit was identified.
- Online and offline channels contribute almost equally.

---

## Tools & Technologies

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Plotly
- Google Colab

---

## How to Run

1. Open `Global_Sales_EDA.ipynb` in Google Colab or Jupyter Notebook.
2. Install required libraries:

pip install -r requirements.txt

3. Make sure dataset files are available locally or update file paths accordingly.

---

## Business Conclusion

The company’s business model is stable and driven by strong product categories and the European market. Growth opportunities lie in geographic expansion and targeted logistics optimization.
