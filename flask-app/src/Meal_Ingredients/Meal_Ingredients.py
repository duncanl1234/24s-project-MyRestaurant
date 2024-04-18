########################################################
# Sample Meal_Ingredients blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


Meal_Ingredients = Blueprint('Meal_Ingredients', __name__)

################ /supplyOrder endpoint ################
# (get) retrieve all Meal_Ingredients
@Meal_Ingredients.route('/Meal_Ingredients', methods=['GET'])
def get_Meal_Ingredients():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Meal_Ingredients')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (post) add new Meal_Ingredient
@Meal_Ingredients.route('/Meal_Ingredients', methods=['POST'])
def add_new_Meal_Ingredients():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    mealId = the_data['mealId']
    ingredientId = the_data['ingredientId']

    # Constructing the query
    query = 'insert into Meal_Ingredients (mealId, ingredientId) values ("'
    query += mealId + '", "'
    query += ingredientId + '")'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

################ /Meal_Ingredients/{mealId} endpoint ################
# (get) Retrieve supplyOrders made by one employee
@Meal_Ingredients.route('/Meal_Ingredients/<mealId>', methods=['GET'])
def get_Meal_IngredientByMeal(mealId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Meal_Ingredients where mealId = {0}'.format(mealId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# (PUT) Update Meal_Ingredients details for a meal
@Meal_Ingredients.route('/Meal_Ingredients/<mealId>', methods=['PUT'])
def update_Meal_Ingredients(mealId):
    try:
        # Collecting data from the request object
        the_data = request.json

        # Extracting the variables to be updated
        mealId = the_data.get('mealId')
        ingredientId = the_data.get('ingredientId')

        # Constructing the update query
        query = 'UPDATE Meal_Ingredients SET mealId = %s, ingredientId = %s WHERE mealId = %s'
        values = (mealId, ingredientId, mealId)

        current_app.logger.info(query)

        # Executing and committing the update statement
        cursor = db.get_db().cursor()
        cursor.execute(query, values)
        db.get_db().commit()

        return 'Meal Ingredient {} updated successfully!'.format(mealId), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (DELETE) Delete a Meal_Ingredient
@Meal_Ingredients.route('/Meal_Ingredients/<mealId>', methods=['DELETE'])
def delete_Meal_Ingredients(mealId):
    try:
        # Constructing the delete query
        query = 'DELETE FROM Meal_Ingredients WHERE mealId = %s'
        values = (mealId,)

        current_app.logger.info(query)

        # Executing and committing the delete statement
        cursor = db.get_db().cursor()
        cursor.execute(query, values)
        db.get_db().commit()

        return 'Meal Ingredient {} deleted successfully!'.format(mealId), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (GET) Retrieve details of a specific Meal Ingredient by ingredient
@Meal_Ingredients.route('/Meal_Ingredients/<ingredientId>', methods=['GET'])
def get_Meal_IngredientsDetails(ingredientId):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM Meal_Ingredients WHERE ingredientId = %s', (ingredientId,))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        return jsonify(json_data), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


