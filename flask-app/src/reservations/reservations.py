########################################################
# Sample reservations blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


reservations = Blueprint('reservations', __name__)

################ /reservations endpoint ################
# (get) retrieve all reservations
@reservations.route('/reservations', methods=['GET'])
def get_reservations():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Reservations')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (post) add new reservation
@reservations.route('/reservations', methods=['POST'])
def add_new_reservation():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    resID = the_data['resID']
    numPeople = the_data['numPeople']
    phone = the_data['phone']
    fname = the_data['fname']
    lname = the_data['lname']
    tableNum = the_data['tableNum']

    # Constructing the query
    query = 'insert into Reservations (resID, numPeople, phone, fname, lname, tableNum) values ("'
    query += resID + '", "'
    query += str(numPeople) + '", "'
    query += phone + '", "'
    query += fname + '", "'
    query += lname + '", "'
    query += str(tableNum) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

################ /reservations/{resID} endpoint ################
# (get) Retrieve reservation info
@reservations.route('/reservations/<resID>', methods=['GET'])
def get_resID(resID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Reservations where id = {0}'.format(resID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# (put) update reservation info
@reservations.route('/reservations/<resID>', methods=['PUT'])
def update_reservation(resID):
    # collecting data from the request object
    the_data = request.json

    # Extracting the variables to be updated
    numPeople = the_data.get('numPeople')
    phone = the_data.get('phone')
    fname = the_data.get('fname')
    lname = the_data.get('lname')
    tableNum = the_data.get('tableNum')

    # Constructing the update query
    query = 'UPDATE Reservations SET '
    updates = []
    if numPeople is not None:
        updates.append('name = "{}"'.format(numPeople))
    if phone is not None:
        updates.append('name = "{}"'.format(phone))
    if fname is not None:
        updates.append('name = "{}"'.format(fname))
    if lname is not None:
        updates.append('name = "{}"'.format(lname))
    if tableNum is not None:
        updates.append('price = "{}"'.format(tableNum))
    query += ', '.join(updates)
    query += ' WHERE resID = "{}"'.format(resID)

    current_app.logger.info(query)

    # executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Reservation {} updated successfully!'.format(resID)

# (delete) Cancel reservation
@reservations.route('/reservations/<resID>', methods=['DELETE'])
def delete_reservation(resID):
    # Constructing the delete query
    query = 'DELETE FROM Reservations WHERE mealId = "{}"'.format(resID)

    current_app.logger.info(query)

    # executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Reservation {} deleted successfully!'.format(resID)


# (GET) retrieve reservations based on reservation date
@reservations.route('/reservations/date/<reservationDate>', methods=['GET'])
def get_reservations_by_date(reservationDate):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM Reservations WHERE reservationDate = %s', (reservationDate,))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        return jsonify(json_data), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500

