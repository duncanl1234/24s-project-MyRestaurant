########################################################
# Sample ingredients blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


ingredients = Blueprint('ingredients', __name__)

################ /ingredients/{ingredientID} endpoint ################
# (get) Get ingredient info
@ingredients.route('/ingredients/<ingredientId>', methods=['GET'])
def get_ingredientId(IngredientId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from ingredients where id = {0}'.format(IngredientId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (put) Update ingredient details
@ingredients.route('/ingredients/<IngredientId>', methods=['PUT'])
def update_ingredient(IngredientId):
    # collecting data from the request object
    the_data = request.json

    # Extracting the variables to be updated
    supply = the_data.get('supply')
    name = the_data.get('name')
    supplierID = the_data.get('supplierID')
    mealId = the_data.get('mealId')

    # Constructing the update query
    query = 'UPDATE ingredients SET '
    updates = []
    if supply is not None:
        updates.append('supply = "{}"'.format(supply))
    if name is not None:
        updates.append('name = "{}"'.format(name))
    if supplierID is not None:
        updates.append('supplierID = "{}"'.format(supplierID))
    if mealId is not None:
        updates.append('mealId = "{}"'.format(mealId))
    query += ', '.join(updates)
    query += ' WHERE IngredientId = "{}"'.format(IngredientId)

    current_app.logger.info(query)

    # executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Ingredient {} updated successfully!'.format(IngredientId)

# (delete) Delete any unecessary ingredients
@ingredients.route('/Ingredients/<IngredientId>', methods=['DELETE'])
def delete_ingredient(IngredientId):
    # Constructing the delete query
    query = 'DELETE FROM ingredients WHERE IngredientId = "{}"'.format(IngredientId)

    current_app.logger.info(query)

    # executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Order {} deleted successfully!'.format(IngredientId)