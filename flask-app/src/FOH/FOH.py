########################################################
# Sample orders blueprint of endpoints
# Remove this file if you are not using it in your project
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


FOH_emp = Blueprint('FOH_emp', __name__)

################ /FOH endpoint ################
# (get) Get all FOH
@FOH_emp.route('/FOH_emp', methods=['GET'])
def get_employees():
    cursor = db.get_db().cursor()
    cursor.execute('select * from FOH_emp')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (post) add a new FOH hire
@FOH_emp.route('/FOH_emp', methods=['POST'])
def add_new_hire():

    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    fohID = the_data['fohID']
    fohSupervisorID = the_data['fohSupervisorID']
    payRate = the_data['payRate']
    endTime = the_data['endTime']
    startTime = the_data['startTime']
    fName = the_data['fName']
    lName = the_data['lName']

    # Constructing the query
    query = 'insert into FOH_emp (fohID, fohSupervisorID, payRate, endTime, startTime, fName, lName) values ("'
    query += fohID + '", "'
    query += fohSupervisorID + '", "'
    query += payRate + '", '
    query += endTime + '", '
    query += startTime + '", '
    query += fName + '", '
    query += lName + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'

################ /FOH_emp/{empID} endpoint ################
# (get) Get an employee's info
@FOH_emp.route('/FOH_emp/<empID>', methods=['GET'])
def get_employee_info(empID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from FOH_emp where id = {0}'.format(empID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (PUT) Update employee info


# (DELETE) Delete data of fired employee