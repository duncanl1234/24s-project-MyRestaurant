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
    cursor.execute('select * from Tables')
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
    query = 'insert into Tables (tableNum, numSeats, isReserved, fohId) values ("'
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


# (PUT) Update table details
@tables.route('/tables/<tableNum>', methods=['PUT'])
def update_table(tableNum):
    try:
        # Collecting data from the request object
        the_data = request.json

        # Extracting the variables to be updated
        numSeats = the_data.get('numSeats')
        isReserved = the_data.get('isReserved')
        fohId = the_data.get('fohId')

        # Constructing the update query
        query = 'UPDATE Tables SET '
        updates = []
        if numSeats is not None:
            updates.append('numSeats = "{}"'.format(numSeats))
        if isReserved is not None:
            updates.append('isReserved = "{}"'.format(isReserved))
        if fohId is not None:
            updates.append('fohId = "{}"'.format(fohId))
        query += ', '.join(updates)
        query += ' WHERE tableNum = "{}"'.format(tableNum)

        current_app.logger.info(query)

        # Executing and committing the update statement
        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

        return 'Table {} updated successfully!'.format(tableNum), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (DELETE) Delete a table
@tables.route('/tables/<tableNum>', methods=['DELETE'])
def delete_table(tableNum):
    try:
        # Constructing the delete query
        query = 'DELETE FROM Tables WHERE tableNum = "{}"'.format(tableNum)

        current_app.logger.info(query)

        # Executing and committing the delete statement
        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

        return 'Table {} deleted successfully!'.format(tableNum), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


# (GET) Get details of a specific table
@tables.route('/tables/<tableNum>', methods=['GET'])
def get_table_details(tableNum):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM Tables WHERE tableNum = {}'.format(tableNum))
        row = cursor.fetchone()
        if row:
            table_details = {
                'tableNum': row[0],
                'numSeats': row[1],
                'isReserved': row[2],
                'fohId': row[3]
            }
            return jsonify(table_details), 200
        else:
            return jsonify({'error': 'Table not found'}), 404
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500



# (PUT) Merge tables
@tables.route('/tables/merge', methods=['PUT'])
def merge_tables():
    try:
        # Collecting data from the request object
        merge_data = request.json

        # Extracting table numbers to be merged
        table_nums = merge_data.get('tableNumbers')

        if len(table_nums) < 2:
            return jsonify({'error': 'Merge requires at least two table numbers'}), 400

        # Assuming all tables have the same number of seats, reservation status, and FOH ID
        # Fetching the common attributes from the first table
        cursor = db.get_db().cursor()
        cursor.execute('SELECT numSeats, isReserved, fohId FROM Tables WHERE tableNum = %s', (table_nums[0],))
        first_table_data = cursor.fetchone()

        if first_table_data is None:
            return jsonify({'error': 'Table {} not found'.format(table_nums[0])}), 404

        num_seats, is_reserved, foh_id = first_table_data

        # Updating the other tables to match the attributes of the first table
        for table_num in table_nums[1:]:
            cursor.execute('UPDATE Tables SET numSeats = %s, isReserved = %s, fohId = %s WHERE tableNum = %s',
                           (num_seats, is_reserved, foh_id, table_num))
            if cursor.rowcount == 0:
                return jsonify({'error': 'Table {} not found'.format(table_num)}), 404

        db.get_db().commit()

        return 'Tables {} merged successfully!'.format(table_nums), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500

