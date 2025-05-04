
# 🛒 Sales Reporting API – Flask + MySQL

This is a lightweight RESTful API built with Flask and MySQL for fetching various sales-related reports from a database.

---

## 🚀 Features

- Retrieve top customers by spend
- View monthly sales reports
- Find products never ordered
- Calculate average order value by country
- Identify frequent buyers

---

## 📦 Project Structure

```
.
├── app.py               # Main Flask application
├── config.py            # Contains configuration values (DB credentials, port)
├── queries.py           # Contains SQL queries for endpoints
```

---

## ⚙️ Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Ghaby-X/amlth-lab.git
cd amlth-lab/simple_api_rds_exercise
```

### 2. Install Dependencies

Ensure you have Python 3 and `pip` installed.


Create and activate a virtual environment (linux environment is being used);

```bash
python3 -m venv venv
source venv/bin/activate
```

Install dependencies;

```bash
pip install -r requirements.txt
```

### 3. Configure Environment

Create a .env file; 
```
touch .env
```

populate the env file with your mysql connection parameters. It should be of this format:

```python
MYSQL_HOST=<your_host>
MYSQL_USER='<your_user>'
MYSQL_PASSWORD='<your_password>'
MYSQL_DATABASE='<your_db>'
```

---

## ▶️ Running the Server

```bash
flask run
```

The server will start on `http://localhost:5000`.

---

## 📬 Available Endpoints

| Endpoint                        | Method | Description                              |
|--------------------------------|--------|------------------------------------------|
| `/`                            | GET    | Welcome message                          |
| `/top_customer_spends`         | GET    | Returns top spending customers           |
| `/monthly_sales_report`        | GET    | Returns monthly sales data               |
| `/unordered_products`          | GET    | Lists products never ordered             |
| `/average_order_by_country`    | GET    | Avg order value grouped by country       |
| `/frequent_buyers`             | GET    | Returns list of frequent buyers          |

---

## 💻 Example Response

```json
{
  "success": true,
  "data": [
    {
      "customer_id": 1,
      "total_spent": 1234.56
    }
  ]
}
```
