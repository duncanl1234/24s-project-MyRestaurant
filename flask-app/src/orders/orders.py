########################################################
# Sample orders blueprint of endpoints
# Remove this file if you are not using it in your project
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
    cursor.execute('select * from orders')
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
    orderID = the_data['orderID']
    isComplete = the_data['isComplete']
    tableNum = the_data['tableNum']
    mealId = the_data['mealId']
    preparerId = the_data['preparerId']

    # Constructing the query
    query = 'insert into orders (orderID, isComplete, tableNum, mealId, preparerId) values ("'
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
@orders.route('/orders/<orderID>', methods=['GET'])
def get_order_details(orderID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from orders where id = {0}'.format(orderID))
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
@orders.route('/orders/<orderID>', methods=['PUT'])
def update_order(orderID):
    # collecting data from the request object
    the_data = request.json

    # Extracting the variables to be updated
    isComplete = the_data.get('isComplete')
    tableNum = the_data.get('tableNum')
    mealId = the_data.get('mealId')
    preparerId = the_data.get('preparerId')

    # Constructing the update query
    query = 'UPDATE orders SET '
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
    query += ' WHERE orderID = "{}"'.format(orderID)

    current_app.logger.info(query)

    # executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Order {} updated successfully!'.format(orderID)

# (delete) Delete order
@orders.route('/orders/<orderID>', methods=['DELETE'])
def delete_order(orderID):
    # Constructing the delete query
    query = 'DELETE FROM orders WHERE orderID = "{}"'.format(orderID)

    current_app.logger.info(query)

    # executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Order {} deleted successfully!'.format(orderID)
