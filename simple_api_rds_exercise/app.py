from flask import Flask, jsonify, render_template

import pymysql
import config
import queries

# create flask app
app = Flask(__name__)

# establish my sql connection
mysql = pymysql.connect(host=config.mysql_host, user=config.mysql_user, password=config.mysql_password, database=config.mysql_database, )

# function to fetch query with mysql and handle exceptions
def fetch_query(query):
    try:
        cur = mysql.cursor(pymysql.cursors.DictCursor) # set response type to dictionary
        cur.execute(query)
        data = cur.fetchall()
        cur.close()
    except:
        return {
            'success': False,
            'message': 'could not fetch from database'
        }

    return {
        'success': True,
        'data': data
    }

@app.route("/")
def welcome():
    return render_template('index.html')

@app.route("/top_customer_spends")
def customer_spend():
    data = fetch_query(query=queries.get_top_customers)
    return jsonify(data)

@app.route("/monthly_sales_report")
def monthly_sales():
    data = fetch_query(query=queries.get_monthly_sales)
    return jsonify(data)

@app.route("/unordered_products")
def unordered_products():
    data = fetch_query(query=queries.get_products_never_ordered)
    return jsonify(data)

@app.route("/average_order_by_country")
def average_order_by_country():
    data = fetch_query(query=queries.get_avg_order_by_country)
    return jsonify(data)

@app.route("/frequent_buyers")
def frequent_buyers():
    data = fetch_query(query=queries.get_frequent_buyers)
    return jsonify(data)




if __name__ == '__main__':
   app.run(debug=True, port=config.PORT)