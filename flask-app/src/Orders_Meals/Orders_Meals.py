
########################################################
# Sample Orders_Meals blueprint of endpoints
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

Orders_Meals = Blueprint('Orders_Meals', __name__)

################ /Orders_Meals endpoint ################
@Orders_Meals.route('/orders/<orderID>/meals/<mealID>', methods=['POST'])
def add_meal_to_order(orderID, mealID):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('INSERT INTO Orders_Meals (orderID, mealID) VALUES (%s, %s)', (orderID, mealID))
        db.get_db().commit()
        return 'Meal added to order successfully!', 201
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


@Orders_Meals.route('/orders/<orderID>/meals/<mealID>', methods=['DELETE'])
def remove_meal_from_order(orderID, mealID):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('DELETE FROM Orders_Meals WHERE orderID = %s AND mealID = %s', (orderID, mealID))
        db.get_db().commit()
        return 'Meal removed from order successfully!', 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Internal Server Error'}), 500


@Orders_Meals.route('/orders/<int:order_id>/meals', methods=['GET'])
def get_meals_for_order(order_id):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('''
            SELECT m.mealID, m.name, m.price
            FROM Meals AS m
            JOIN Orders_Meals AS om ON m.mealID = om.mealID
            WHERE om.orderID = %s
        ''', (order_id,))
        meals = cursor.fetchall()

        if not meals:
            return 'No meals found for this order.', 404

        # Convert meals to a list of dictionaries for JSON serialization
        meals_data = [{'mealID': meal[0], 'name': meal[1], 'price': meal[2]} for meal in meals]
        
        return jsonify(meals_data), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Failed to retrieve meals for order.'}), 500


@Orders_Meals.route('/orders/<int:order_id>/meals/<int:meal_id>/quantity', methods=['PUT'])
def update_meal_quantity_for_order(order_id, meal_id):
    try:
        # Check if the meal exists in the order
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM Orders_Meals WHERE orderID = %s AND mealID = %s', (order_id, meal_id))
        if not cursor.fetchone():
            return 'Meal not found in order.', 404

        # Update the quantity for the meal in the order
        data = request.json
        new_quantity = data.get('quantity')

        cursor.execute('UPDATE Orders_Meals SET quantity = %s WHERE orderID = %s AND mealID = %s', (new_quantity, order_id, meal_id))
        db.get_db().commit()

        return 'Meal quantity updated successfully for the order!', 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Failed to update meal quantity for order.'}), 500


@Orders_Meals.route('/meals/<int:meal_id>/orders', methods=['GET'])
def get_orders_containing_meal(meal_id):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('''
            SELECT o.orderID, o.isComplete, o.tableNum, o.preparerId
            FROM Orders AS o
            JOIN Orders_Meals AS om ON o.orderID = om.orderID
            WHERE om.mealID = %s
        ''', (meal_id,))
        orders = cursor.fetchall()

        if not orders:
            return 'No orders found containing this meal.', 404

        # Convert orders to a list of dictionaries for JSON serialization
        orders_data = [{'orderID': order[0], 'isComplete': order[1], 'tableNum': order[2], 'preparerId': order[3]} for order in orders]
        
        return jsonify(orders_data), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Failed to retrieve orders containing meal.'}), 500


@Orders_Meals.route('/preparer/<int:preparer_id>/orders', methods=['GET'])
def get_orders_for_preparer(preparer_id):
    try:
        cursor = db.get_db().cursor()
        cursor.execute('''
            SELECT o.orderID, o.isComplete, o.tableNum, om.mealID, om.quantity
            FROM Orders AS o
            JOIN Orders_Meals AS om ON o.orderID = om.orderID
            WHERE o.preparerId = %s
        ''', (preparer_id,))
        orders = cursor.fetchall()

        if not orders:
            return 'No orders found for this preparer.', 404

        # Group orders by orderID and prepare meals data with quantities
        orders_data = {}
        for order in orders:
            order_id = order[0]
            if order_id not in orders_data:
                orders_data[order_id] = {'orderID': order_id, 'isComplete': order[1], 'tableNum': order[2], 'meals': []}
            orders_data[order_id]['meals'].append({'mealID': order[3], 'quantity': order[4]})
        
        return jsonify(list(orders_data.values())), 200
    except Exception as e:
        current_app.logger.error(str(e))
        return jsonify({'error': 'Failed to retrieve orders for preparer.'}), 500



