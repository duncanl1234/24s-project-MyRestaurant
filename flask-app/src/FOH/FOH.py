########################################################
# Sample orders blueprint of endpoints
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

################ /FOH_emp/{fohId} endpoint ################
# (get) Get an employee's info
@FOH_emp.route('/FOH_emp/<fohId>', methods=['GET'])
def get_employee_info(fohId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from FOH_emp where fohId = {0}'.format(fohId))
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
@FOH_emp.route('/FOH_emp/<fohId>', methods=['PUT'])
def update_employee_info(fohId):
    try:
        employee_data = request.json
        
        cursor = db.get_db().cursor()
        query = 'UPDATE FOH_emp SET fohSupervisorID=%s, payRate=%s, endTime=%s, startTime=%s, fName=%s, lName=%s WHERE fohID=%s'
        cursor.execute(query, (employee_data['fohSupervisorID'], employee_data['payRate'], employee_data['endTime'], employee_data['startTime'], employee_data['fName'], employee_data['lName'], fohId))
        
        if cursor.rowcount == 0:
            return jsonify({'error': 'Employee not found'}), 404
        
        db.get_db().commit()
        return 'Success!', 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (DELETE) Delete data of fired employee
@FOH_emp.route('/FOH_emp/<fohId>', methods=['DELETE'])
def delete_employee(fohId):
    try:
        cursor = db.get_db().cursor()
        query = 'DELETE FROM FOH_emp WHERE fohId=%s'
        cursor.execute(query, (fohId,))
        
        if cursor.rowcount == 0:
            return jsonify({'error': 'Employee not found'}), 404
        
        db.get_db().commit()
        return 'Success!', 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (PUT) Update employee pay rate
@FOH_emp.route('/FOH_emp/<fohId>/payRate', methods=['PUT'])
def update_employee_pay_rate(fohId):
    try:
        # get the new pay rate from the request JSON data
        new_pay_rate = request.json.get('payRate')

        cursor = db.get_db().cursor()
        query = 'UPDATE FOH_emp SET payRate=%s WHERE fohId=%s'
        cursor.execute(query, (new_pay_rate, fohId))

        if cursor.rowcount == 0:
            return jsonify({'error': 'Employee not found'}), 404

        db.get_db().commit()
        return 'Pay rate updated successfully!', 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500



