########################################################
# Sample supplyOrder blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


supplyOrder = Blueprint('supplyOrder', __name__)

################ /supplyOrder endpoint ################
# (get) retrieve all supplyOrders
@supplyOrder.route('/supplyOrder', methods=['GET'])
def get_supplyOrder():
    cursor = db.get_db().cursor()
    cursor.execute('select * from SupplyOrder')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (post) add new supplyOrder
@supplyOrder.route('/supplyOrder', methods=['POST'])
def add_new_supplyOrder():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    supplyOrderId = the_data['supplyOrderId']
    ingredientId = the_data['ingredientId']
    ordererId = the_data['ordererId']

    # Constructing the query
    query = 'insert into SupplyOrder (supplyOrderId, ingredientId, ordererId) values ("'
    query += supplyOrderId + '", "'
    query += ingredientId + '", "'
    query += ordererId + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

################ /supplyOrder/{supplyOrderId} endpoint ################
# (get) Retrieve supplyOrders made by one employee
@supplyOrder.route('/supplyOrder/<ordererId>', methods=['GET'])
def get_supplyOrderByOrderer(ordererId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from SupplyOrder where ordererId = {0}'.format(ordererId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# (PUT) Update supply order details
@supplyOrder.route('/supplyOrder/<supplyOrderId>', methods=['PUT'])
def update_supplyOrder(supplyOrderId):
    try:
        # Collecting data from the request object
        the_data = request.json

        # Extracting the variables to be updated
        ingredientId = the_data.get('ingredientId')
        ordererId = the_data.get('ordererId')

        # Constructing the update query
        query = 'UPDATE SupplyOrder SET ingredientId = %s, ordererId = %s WHERE supplyOrderId = %s'
        values = (ingredientId, ordererId, supplyOrderId)

        current_app.logger.info(query)

        # Executing and committing the update statement
        cursor = db.get_db().cursor()
        cursor.execute(query, values)
        db.get_db().commit()

        return 'Supply order {} updated successfully!'.format(supplyOrderId), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (DELETE) Delete a supply order
@supplyOrder.route('/supplyOrder/<supplyOrderId>', methods=['DELETE'])
def delete_supplyOrder(supplyOrderId):
    try:
        # Constructing the delete query
        query = 'DELETE FROM SupplyOrder WHERE supplyOrderId = %s'
        values = (supplyOrderId,)

        current_app.logger.info(query)

        # Executing and committing the delete statement
        cursor = db.get_db().cursor()
        cursor.execute(query, values)
        db.get_db().commit()

        return 'Supply order {} deleted successfully!'.format(supplyOrderId), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (GET) Retrieve details of a specific supply order
@supplyOrder.route('/supplyOrder/<supplyOrderId>', methods=['GET'])
def get_supplyOrderDetails(supplyOrderId):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM SupplyOrder WHERE supplyOrderId = %s', (supplyOrderId,))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        return jsonify(json_data), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


