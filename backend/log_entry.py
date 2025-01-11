from flask import Flask, jsonify, request
from flask_jwt_extended import JWTManager, jwt_required, get_jwt_identity
import boto3
from botocore.exceptions import ClientError
import time
from decimal import Decimal

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = 'your_secret_key'  # Change this in a real app
jwt = JWTManager(app)

# DynamoDB configuration
dynamodb = boto3.resource('dynamodb', region_name='eu-west-2')  # Change region if needed
table = dynamodb.Table('DiaLog_Data')  # Replace with your actual DynamoDB table name

# POST /logs: Add a new log entry
@app.route('/logs', methods=['POST'])
@jwt_required()
def add_log():
    current_user = get_jwt_identity()
    data = request.get_json()
    
    log_intensity = data.get('log_intensity', 'simple')  

    blood_sugar_level = data.get('blood_sugar_level')
    insulin_dose = data.get('insulin_dose', None)
    food_intake = data.get('food_intake', '') if log_intensity != 'simple' else None
    exercise = data.get('exercise', '') if log_intensity != 'simple' else None
    medications = data.get('medications', '') if log_intensity != 'simple' else None
    stress_factors = data.get('stress_factors', '') if log_intensity == 'intensive' else None
    carb_intake = data.get('carb_intake', None) if log_intensity == 'intensive' else None
    event_notes = data.get('event_notes', '') if log_intensity == 'intensive' else None

    log_data = {
        'PK': str(current_user),  # Partition Key (user ID)
        'SK': f"LOG#{str(current_user)}#{str(Decimal(time.time()))}",  # Sort Key (unique per log entry)
        'blood_sugar_level': blood_sugar_level,
        'insulin_dose': insulin_dose,
        'food_intake': food_intake,
        'exercise': exercise,
        'medications': medications,
        'stress_factors': stress_factors,
        'carb_intake': carb_intake,
        'event_notes': event_notes,
        'user_id': current_user,
        'log_intensity': log_intensity
    }

    try:
        # Save log entry to DynamoDB
        response = table.put_item(Item=log_data)
        return jsonify({"msg": "Log added successfully"}), 201
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

# GET /logs: Retrieve all log entries for the logged-in user
@app.route('/logs', methods=['GET'])
@jwt_required()
def get_logs():
    current_user = get_jwt_identity()

    # Query for logs using the user ID as the partition key
    try:
        response = table.query(
            KeyConditionExpression=boto3.dynamodb.conditions.Key('PK').eq(str(current_user))
        )
        logs = response['Items']

        output = []
        for log in logs:
            log_data = {
                'id': log.get('SK'),
                'blood_sugar_level': log.get('blood_sugar_level'),
                'insulin_dose': log.get('insulin_dose'),
                'food_intake': log.get('food_intake'),
                'exercise': log.get('exercise')
            }
            output.append(log_data)
        
        return jsonify(output), 200
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

# GET /logs/:id: Retrieve a specific log entry by its ID
@app.route('/logs/<string:id>', methods=['GET'])
@jwt_required()
def get_log_by_id(id):
    current_user = get_jwt_identity()
    
    try:
        # Get the specific log by partition key (PK) and sort key (SK)
        response = table.get_item(
            Key={'PK': str(current_user), 'SK': id}
        )
        
        if 'Item' not in response:
            return jsonify({'msg': 'Log not found'}), 404
        
        log = response['Item']
        log_data = {
            'id': log['SK'],
            'blood_sugar_level': log.get('blood_sugar_level'),
            'insulin_dose': log.get('insulin_dose'),
            'food_intake': log.get('food_intake'),
            'exercise': log.get('exercise')
        }
        
        return jsonify(log_data), 200
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

# PUT /logs/:id: Update an existing log entry
@app.route('/logs/<string:id>', methods=['PUT'])
@jwt_required()
def update_log(id):
    current_user = get_jwt_identity()
    
    try:
        # Retrieve the log entry to be updated
        response = table.get_item(
            Key={'PK': str(current_user), 'SK': id}
        )
        
        if 'Item' not in response:
            return jsonify({'msg': 'Log not found'}), 404
        
        log = response['Item']
        data = request.get_json()

        # Update fields based on the data provided
        updated_log = log
        updated_log['blood_sugar_level'] = data.get('blood_sugar_level', log['blood_sugar_level'])
        updated_log['insulin_dose'] = data.get('insulin_dose', log['insulin_dose'])
        updated_log['food_intake'] = data.get('food_intake', log['food_intake'])
        updated_log['exercise'] = data.get('exercise', log['exercise'])

        # Save the updated log back to DynamoDB
        table.put_item(Item=updated_log)
        
        return jsonify({"msg": "Log updated successfully"}), 200
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

# DELETE /logs/:id: Delete a specific log entry
@app.route('/logs/<string:id>', methods=['DELETE'])
@jwt_required()
def delete_log(id):
    current_user = get_jwt_identity()
    
    try:
        # Retrieve and delete the log entry
        response = table.get_item(
            Key={'PK': str(current_user), 'SK': id}
        )
        
        if 'Item' not in response:
            return jsonify({'msg': 'Log not found'}), 404
        
        table.delete_item(Key={'PK': str(current_user), 'SK': id})
        
        return jsonify({"msg": "Log deleted successfully"}), 200
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

if __name__ == '__main__':
    app.run(debug=True)
