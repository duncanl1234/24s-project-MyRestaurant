########################################################
# Sample meals blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


meals = Blueprint('meals', __name__)

################ /meals endpoint ################
# (get) Get list of all offered meals
@meals.route('/meals', methods=['GET'])
def get_meals():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Meals')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (post) add new menu item
@meals.route('/meals', methods=['POST'])
def add_new_table():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    mealId = the_data['mealId']
    name = the_data['name']
    price = the_data['price']

    # Constructing the query
    query = 'insert into Meals (mealId, name, price) values ("'
    query += mealId + '", "'
    query += name + '", "'
    query += str(price) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

################ /meals/{mealId} endpoint ################
# (get) Get info for a specific meal
@meals.route('/meals/<mealId>', methods=['GET'])
def get_mealId(mealId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from ingredients where id = {0}'.format(mealId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (put) change item details (i.e. price)
@meals.route('/meals/<mealId>', methods=['PUT'])
def update_ingredient(mealId):
    # collecting data from the request object
    the_data = request.json

    # Extracting the variables to be updated
    name = the_data.get('name')
    price = the_data.get('price')

    # Constructing the update query
    query = 'UPDATE meals SET '
    updates = []
    if name is not None:
        updates.append('name = "{}"'.format(name))
    if price is not None:
        updates.append('price = "{}"'.format(price))
    query += ', '.join(updates)
    query += ' WHERE mealId = "{}"'.format(mealId)

    current_app.logger.info(query)

    # executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Meal {} updated successfully!'.format(mealId)

# (delete) Delete menu item
@meals.route('/meals/<mealId>', methods=['DELETE'])
def delete_meal(mealId):
    # Constructing the delete query
    query = 'DELETE FROM meals WHERE mealId = "{}"'.format(mealId)

    current_app.logger.info(query)

    # executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Meal {} deleted successfully!'.format(mealId)


# (POST) Add new menu item
@meals.route('/meals', methods=['POST'])
def add_new_meal():
    try:
        # Collecting data from the request object
        data = request.json
        mealId = data.get('mealId')
        name = data.get('name')
        price = data.get('price')

        # Constructing the INSERT query
        query = 'INSERT INTO meals (mealId, name, price) VALUES (%s, %s, %s)'
        cursor = db.get_db().cursor()
        cursor.execute(query, (mealId, name, price))
        db.get_db().commit()

        return 'Meal added successfully!', 201
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


