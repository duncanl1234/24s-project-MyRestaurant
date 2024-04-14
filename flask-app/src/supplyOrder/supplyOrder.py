########################################################
# Sample supplyOrder blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


supplyOrder = Blueprint('SupplyOrder', __name__)

################ /supplyOrder endpoint ################
# (get) retrieve all supplyOrders
@supplyOrder.route('/SupplyOrder', methods=['GET'])
def get_supplyOrder():
    cursor = db.get_db().cursor()
    cursor.execute('select * from supplyOrder')
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
@supplyOrder.route('/SupplyOrder', methods=['POST'])
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
@supplyOrder.route('/SupplyOrder/<ordererId>', methods=['GET'])
def get_supplyOrderByOrderer(ordererId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from supplyOrder where ordererId = {0}'.format(ordererId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response