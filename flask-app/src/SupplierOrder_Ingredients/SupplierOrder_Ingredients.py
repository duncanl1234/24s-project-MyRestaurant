########################################################
# Sample SupplierOrder_Ingredients blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


SupplierOrder_Ingredients = Blueprint('SupplierOrder_Ingredients', __name__)

################ /SupplierOrder_Ingredients endpoint ################
# (get) retrieve all SupplierOrder_Ingredients
@SupplierOrder_Ingredients.route('/SupplierOrder_Ingredients', methods=['GET'])
def get_SupplierOrder_Ingredients():
    cursor = db.get_db().cursor()
    cursor.execute('select * from SupplierOrder_Ingredients')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (post) add new SupplierOrder_Ingredient
@SupplierOrder_Ingredients.route('/SupplierOrder_Ingredients', methods=['POST'])
def add_new_SupplierOrder_Ingredients():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    supplyOrderId = the_data['supplyOrderId']
    ingredientId = the_data['ingredientId']

    # Constructing the query
    query = 'insert into SupplierOrder_Ingredients (supplyOrderId, ingredientId) values ("'
    query += supplyOrderId + '", "'
    query += ingredientId + '")'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

################ /SupplierOrder_Ingredients/{supplyOrderId} endpoint ################
# (get) Retrieve SupplierOrder_Ingredients for a specific supplyOrder
@SupplierOrder_Ingredients.route('/SupplierOrder_Ingredients/<supplyOrderId>', methods=['GET'])
def get_SupplierOrder_IngredientByOrderer(supplyOrderId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from SupplierOrder_Ingredients where supplyOrderId = {0}'.format(supplyOrderId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# (PUT) Update SupplierOrder_Ingredients details
@SupplierOrder_Ingredients.route('/SupplierOrder_Ingredients/<supplyOrderId>', methods=['PUT'])
def update_SupplierOrder_Ingredients(supplyOrderId):
    try:
        # Collecting data from the request object
        the_data = request.json

        # Extracting the variables to be updated
        supplyOrderId = the_data.get('supplyOrderId')
        ingredientId = the_data.get('ingredientId')

        # Constructing the update query
        query = 'UPDATE SupplierOrder_Ingredients SET supplyOrderId = %s, ingredientId = %s WHERE supplyOrderId = %s'
        values = (supplyOrderId, ingredientId, supplyOrderId)

        current_app.logger.info(query)

        # Executing and committing the update statement
        cursor = db.get_db().cursor()
        cursor.execute(query, values)
        db.get_db().commit()

        return 'SupplyOrder_Ingredient {} updated successfully!'.format(supplyOrderId), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (DELETE) Delete a SupplierOrder_Ingredient
@SupplierOrder_Ingredients.route('/SupplierOrder_Ingredients/<supplyOrderId>', methods=['DELETE'])
def delete_SupplierOrder_Ingredients(supplyOrderId):
    try:
        # Constructing the delete query
        query = 'DELETE FROM SupplierOrder_Ingredients WHERE supplyOrderId = %s'
        values = (supplyOrderId,)

        current_app.logger.info(query)

        # Executing and committing the delete statement
        cursor = db.get_db().cursor()
        cursor.execute(query, values)
        db.get_db().commit()

        return 'SupplyOrder_Ingredient {} deleted successfully!'.format(supplyOrderId), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (GET) Retrieve details of a specific ingredientId
@SupplierOrder_Ingredients.route('/SupplierOrder_Ingredients/<ingredientId>', methods=['GET'])
def get_SupplierOrder_IngredientsDetails(ingredientId):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM SupplierOrder_Ingredients WHERE ingredientId = %s', (ingredientId,))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        return jsonify(json_data), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


