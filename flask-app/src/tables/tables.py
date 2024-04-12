########################################################
# Sample tables blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


tables = Blueprint('tables', __name__)

################ /tables endpoint ################
# (get) Get all table info
@tables.route('/tables', methods=['GET'])
def get_tables():
    cursor = db.get_db().cursor()
    cursor.execute('select * from tables')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (post) add more tables
@tables.route('/tables', methods=['POST'])
def add_new_table():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    tableNum = the_data['tableNum']
    numSeats = the_data['numSeats']
    isReserved = the_data['isReserved']
    fohId = the_data['fohId']

    # Constructing the query
    query = 'insert into tables (tableNum, numSeats, isReserved, fohId) values ("'
    query += str(tableNum) + '", "'
    query += str(numSeats) + '", "'
    query += str(isReserved) + '", '
    query += fohId + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'