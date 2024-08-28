from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

# In-memory storage for simplicity, replace with a database for production
products = []

@app.route('/add_product', methods=['POST'])
def add_product():
    data = request.json
    name = data.get('name')
    expiry_date = data.get('expiry_date')
    
    if not name or not expiry_date:
        return jsonify({"error": "Missing data"}), 400
    
    # Convert expiry_date to a datetime object if it's in the expected format
    try:
        expiry_date_dt = datetime.strptime(expiry_date, '%a, %d %b %Y %H:%M:%S %Z')
    except ValueError:
        return jsonify({"error": "Invalid date format. Expected format is 'EEE, dd MMM yyyy HH:mm:ss GMT'"}), 400
    
    product = {"name": name, "expiry_date": expiry_date_dt}
    products.append(product)
    
    return jsonify({"message": "Product added successfully", "product": product}), 201

@app.route('/get_products', methods=['GET'])
def get_products():
    # Convert datetime objects back to string format for JSON response
    products_list = [
        {"name": product["name"], "expiry_date": product["expiry_date"].strftime('%a, %d %b %Y %H:%M:%S GMT')}
        for product in products
    ]
    return jsonify(products_list), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
