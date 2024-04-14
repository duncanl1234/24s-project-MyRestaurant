########################################################
# Sample orders blueprint of endpoints
# Remove this file if you are not using it in your project
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


BOH_emp = Blueprint('BOH_emp', __name__)

################ /BOH endpoint ################
# (get) Get all BOH
@BOH_emp.route('/BOH_emp', methods=['GET'])
def get_employees():
    cursor = db.get_db().cursor()
    cursor.execute('select * from BOH_emp')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (post) add a new BOH hire
@BOH_emp.route('/BOH_emp', methods=['POST'])
def add_new_hire():

    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    bohID = the_data['bohID']
    bohSupervisorID = the_data['bohSupervisorID']
    payRate = the_data['payRate']
    endTime = the_data['endTime']
    startTime = the_data['startTime']
    fName = the_data['fName']
    lName = the_data['lName']

    # constructing the query
    query = 'insert into BOH_emp (bohID, bohSupervisorID, payRate, endTime, startTime, fName, lName) values ("'
    query += bohID + '", "'
    query += bohSupervisorID + '", "'
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

################ /BOH_emp/{empID} endpoint ################
# (GET) get an employee's info
@BOH_emp.route('/BOH_emp/<empID>', methods=['GET'])
def get_employee_info(empID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from BOH_emp where id = {0}'.format(empID))
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
@BOH_emp.route('/BOH_emp/<empID>', methods=['PUT'])
def update_employee_info(empID):
    try:
        employee_data = request.json
        
        cursor = db.get_db().cursor()
        query = 'UPDATE BOH_emp SET bohSupervisorID=%s, payRate=%s, endTime=%s, startTime=%s, fName=%s, lName=%s WHERE bohID=%s'
        cursor.execute(query, (employee_data['bohSupervisorID'], employee_data['payRate'], employee_data['endTime'], employee_data['startTime'], employee_data['fName'], employee_data['lName'], empID))
        
        if cursor.rowcount == 0:
            return jsonify({'error': 'Employee not found'}), 404
        
        db.get_db().commit()
        return 'Success!', 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (DELETE) Delete data of fired employee
@BOH_emp.route('/BOH_emp/<empID>', methods=['DELETE'])
def delete_employee(empID):
    try:
        cursor = db.get_db().cursor()
        query = 'DELETE FROM BOH_emp WHERE bohID=%s'
        cursor.execute(query, (empID,))
        
        if cursor.rowcount == 0:
            return jsonify({'error': 'Employee not found'}), 404
        
        db.get_db().commit()
        return 'Success!', 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500
    
    