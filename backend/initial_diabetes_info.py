import boto3
from flask import Flask, request, jsonify
from botocore.exceptions import ClientError
from decimal import Decimal


# Initialize Flask app
app = Flask(__name__)

# Initialize DynamoDB Client
dynamodb = boto3.resource('dynamodb', region_name='eu-west-2')  # Specify your region
table = dynamodb.Table('DiaLog_Users') 

# Function to add or update diabetic condition data in DynamoDB
def save_patient_data(patient_data):
    try:
        response = table.put_item(
            Item=patient_data
        )
        return response
    except ClientError as e:
        return {"error": e.response['Error']['Message']}

# Add or update diabetic condition data
@app.route('/conditions', methods=['POST'])
def add_conditions():
    data = request.json
    print("Received data:", data) 
    userid = data.get("userid")
    
    # Validate the data
    userid = data.get("userid")
    
    print("Extracted patient_id:", userid)  # Log the patient_id explicitly
    
    # Check if patient_id is explicitly available and valid
    if not userid:
        return jsonify({"error": "Patient ID is required"}), 400
    # Define the data structure for the patient (diabetic condition info)
    patient_data = {
        "userid": userid,
        "diabetes_type": data.get("diabetes_type"),
        "diagnose_date": data.get("diagnose_date"),
        "insulin_type": data.get("insulin_type"),
        "admin_route": data.get("admin_route"),
        "condition": data.get("condition"),
        "medication": data.get("medication"),
        "bs_unit": data.get("bs_unit"),
        "carb_unit": data.get("carb_unit"),
        "lower_bound": Decimal(str(data.get("lower_bound",0))),
        "upper_bound": Decimal(str(data.get("upper_bound",0))),
    }

    # Save to DynamoDB
    response = save_patient_data(patient_data)
    if "error" in response:
        return jsonify({"error": response["error"]}), 500
    
    return jsonify({"message": "Patient condition data saved successfully!", "patient_id": userid}), 201

# Get diabetic condition data for a specific patient
@app.route('/conditions/<patient_id>', methods=['GET'])
def get_conditions(patient_id):
    try:
        response = table.get_item(Key={"patient_id": patient_id})
        if 'Item' not in response:
            return jsonify({"error": "No data found for the specified patient ID"}), 404
        return jsonify(response['Item']), 200
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

# Fetch all patient condition data
@app.route('/conditions', methods=['GET'])
def get_all_conditions():
    try:
        response = table.scan()
        return jsonify({"patients": response.get('Items', [])}), 200
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

if __name__ == '__main__':
    app.run(debug=True)
