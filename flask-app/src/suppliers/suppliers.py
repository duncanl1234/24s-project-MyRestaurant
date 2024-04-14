########################################################
# Sample suppliers blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


suppliers = Blueprint('suppliers', __name__)

################ /suppliers endpoint ################
# (get) retrieve all suppliers
@suppliers.route('/suppliers', methods=['GET'])
def get_suppliers():
    cursor = db.get_db().cursor()
    cursor.execute('select * from suppliers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (post) add new supplier
@suppliers.route('/suppliers', methods=['POST'])
def add_new_supplier():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    supplierID = the_data['supplierID']
    name = the_data['name']

    # Constructing the query
    query = 'insert into suppliers (supplierID, name) values ("'
    query += supplierID + '", "'
    query += name + '", "'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

################ /suppliers/{supplierID} endpoint ################
# (get) Retrieve supplier info
@suppliers.route('/suppliers/<supplierID>', methods=['GET'])
def get_supplierID(supplierID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from suppliers where id = {0}'.format(supplierID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (put) update supplier info
@suppliers.route('/suppliers/<supplierID>', methods=['PUT'])
def update_supplier(supplierID):
    # collecting data from the request object
    the_data = request.json

    # Extracting the variables to be updated
    name = the_data.get('name')

    # Constructing the update query
    query = 'UPDATE suppliers SET '
    updates = []
    if name is not None:
        updates.append('name = "{}"'.format(name))
    query += ', '.join(updates)
    query += ' WHERE supplierID = "{}"'.format(supplierID)

    current_app.logger.info(query)

    # executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Supplier {} updated successfully!'.format(supplierID)

# (delete) Cancel supplier
@suppliers.route('/suppliers/<supplierID>', methods=['DELETE'])
def delete_suppliers(supplierID):
    # Constructing the delete query
    query = 'DELETE FROM suppliers WHERE supplierID = "{}"'.format(supplierID)

    current_app.logger.info(query)

    # executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Supplier {} deleted successfully!'.format(supplierID)