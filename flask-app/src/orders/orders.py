########################################################
# Sample orders blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


orders = Blueprint('orders', __name__)

################ /orders endpoint ################
# (get) Get all orders
@orders.route('/orders', methods=['GET'])
def get_orders():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Orders')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (post) add a new order
@orders.route('/orders', methods=['POST'])
def add_new_order():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    orderID = the_data['orderId']
    isComplete = the_data['isComplete']
    tableNum = the_data['tableNum']
    mealId = the_data['mealId']
    preparerId = the_data['preparerId']

    # Constructing the query
    query = 'insert into Orders (orderId, isComplete, tableNum, mealId, preparerId) values ("'
    query += orderID + '", "'
    query += str(isComplete) + '", "'
    query += str(tableNum) + '", '
    query += mealId + '", '
    query += preparerId + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

################ /orders/{orderID} endpoint ################
# (get) Get order details
@orders.route('/orders/<orderId>', methods=['GET'])
def get_order_details(orderId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Orders where orderId = {0}'.format(orderId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (put) Update order details
@orders.route('/orders/<orderId>', methods=['PUT'])
def update_order(orderId):
    # collecting data from the request object
    the_data = request.json

    # Extracting the variables to be updated
    isComplete = the_data.get('isComplete')
    tableNum = the_data.get('tableNum')
    mealId = the_data.get('mealId')
    preparerId = the_data.get('preparerId')

    # Constructing the update query
    query = 'UPDATE Orders SET '
    updates = []
    if isComplete is not None:
        updates.append('isComplete = "{}"'.format(isComplete))
    if tableNum is not None:
        updates.append('tableNum = "{}"'.format(tableNum))
    if mealId is not None:
        updates.append('mealId = "{}"'.format(mealId))
    if preparerId is not None:
        updates.append('preparerId = "{}"'.format(preparerId))
    query += ', '.join(updates)
    query += ' WHERE orderId = "{}"'.format(orderId)

    current_app.logger.info(query)

    # executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Order {} updated successfully!'.format(orderId)

# (delete) Delete order
@orders.route('/orders/<orderId>', methods=['DELETE'])
def delete_order(orderId):
    # Constructing the delete query
    query = 'DELETE FROM Orders WHERE orderId = "{}"'.format(orderId)

    current_app.logger.info(query)

    # executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Order {} deleted successfully!'.format(orderId)


# (GET) Get all orders for a specific table
@orders.route('/orders/table/<tableNum>', methods=['GET'])
def get_orders_by_table(tableNum):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM Orders WHERE tableNum = %s', (tableNum,))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        return jsonify(json_data), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


