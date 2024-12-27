import boto3
from flask import Flask, request, jsonify
from botocore.exceptions import ClientError
from decimal import Decimal
import uuid
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
import json
from decimal import Decimal 

# Initialize Flask app
app = Flask(__name__)

# Configure Flask-JWT
app.config['JWT_SECRET_KEY'] = 'r0FQJmm/leaRsIhCH3cBevPM6sULf2bZlrhranEy'  # Update with a strong secret key
jwt = JWTManager(app)

# Initialize DynamoDB Client
dynamodb = boto3.resource('dynamodb', region_name='eu-west-2')  # Specify your region
table = dynamodb.Table('DiaLog_Users')  # Your DynamoDB table name

# Function to add or update data in DynamoDB
def save_patient_data(patient_data):
    try:
        response = table.put_item(
            Item=patient_data
        )
        return response
    except ClientError as e:
        return {"error": e.response['Error']['Message']}

# User model (used to create a new user)
class User:
    def __init__(self, first_name, last_name, email, password, gender, birthdate, country_of_residence, weight, height, consent):
        self.userid = str(uuid.uuid4())  # Generate a unique user ID
        self.firstName = first_name
        self.lastName = last_name
        self.email = email
        self.password = password
        self.gender = gender
        self.birthdate = birthdate
        self.residence = country_of_residence
        self.weight = weight
        self.height = height
        self.consent = consent

    def as_dict(self):
        return {
            'userid': self.userid,
            'PK': self.userid,  # Use email as Partition Key (can also use 'userid')
            'SK': f"USER#{self.userid}",  # Sort Key: USER#<email>
            'first_name': self.firstName,
            'last_name': self.lastName,
            'email': self.email,
            'password': self.password,  # (Hash this in production)
            'gender': self.gender,
            'birthdate': self.birthdate,
            'country_of_residence': self.residence,
            'weight': self.weight,
            'height': self.height,
            'consent': self.consent
        }

# Register a new user
@app.route('/register', methods=['POST'])
def register():
    data = request.json
    required_fields = ['first_name', 'last_name', 'email', 'password', 'confirm_password', 'gender', 'birthdate', 'country_of_residence', 'weight', 'height', 'consent']

    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"Missing required field: {field}"}), 400

    if data['password'] != data['confirm_password']:
        return jsonify({"error": "Passwords do not match."}), 400

    # Check if the user already exists in DynamoDB
    response = table.scan(
        FilterExpression=boto3.dynamodb.conditions.Attr('email').eq(data['email'])
    )
    if response['Items']:
        return jsonify({"error": "Email already in use."}), 400

    # Create a new user object
    try:
        new_user = User(
            first_name=data['first_name'],
            last_name=data['last_name'],
            email=data['email'],
            password=data['password'],
            gender=data['gender'],
            birthdate=data['birthdate'],
            country_of_residence=data['country_of_residence'],
            weight=data['weight'],
            height=data['height'],
            consent=data['consent']
        )

        # Convert the user object to dictionary
        user_dict = new_user.as_dict()

        user_dict['SK'] = f"USER#{new_user.userid}"


        # Store user data in DynamoDB
        response = save_patient_data(user_dict)
        if "error" in response:
            return jsonify({"error": response["error"]}), 500
        
        return jsonify({"message": "User registered successfully!"}), 201
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        return jsonify({"error": "An error occurred during registration."}), 500

# Add condition data (diabetes info, etc.)
@app.route('/conditions', methods=['POST'])
def add_conditions():
    data = request.json
    userid = data.get("userid")
    print("extracted ID: ", userid)
    
    # Validate the data
    if not userid:
        return jsonify({"error": "Patient ID is required"}), 400

    # Define condition data (with unique sort key)
    condition_data = {
        'PK': userid,  # Same Partition Key as the user (userid)
        'SK': f"CONDITION#{userid}",  # Unique Sort Key for condition data
        'userid': userid, 
        'diabetes_type': data.get("diabetes_type"),
        'diagnose_date': data.get("diagnose_date"),
        'insulin_type': data.get("insulin_type"),
        'admin_route': data.get("admin_route"),
        'condition': data.get("condition"),
        'medication': data.get("medication"),
        'bs_unit': data.get("bs_unit"),
        'carb_unit': data.get("carb_unit"),
        'lower_bound': Decimal(str(data.get("lower_bound", 0))),
        'upper_bound': Decimal(str(data.get("upper_bound", 0))),
    }
    print("Condition data being saved: ", json.dumps(condition_data, default=str))


    try:
        response = table.put_item(
            Item=condition_data
        )
        return jsonify({"message": "Patient condition data saved successfully!", "patient_id": userid}), 201
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

    #try:
        # Add condition data without overwriting the user data
        response = table.update_item(
            Key={'PK': userid, 'SK': f"CONDITION#{userid}"},
            UpdateExpression="SET #diabetes_type = :diabetes_type, #diagnose_date = :diagnose_date, "
                             "#insulin_type = :insulin_type, #admin_route = :admin_route, "
                             "#condition = :condition, #medication = :medication, "
                             "#bs_unit = :bs_unit, #carb_unit = :carb_unit, "
                             "#lower_bound = :lower_bound, #upper_bound = :upper_bound",
            ExpressionAttributeNames={
                 '#diabetes_type': 'diabetes_type',
                '#diagnose_date': 'diagnose_date',
                '#insulin_type': 'insulin_type',
                '#admin_route': 'admin_route',
                '#condition': 'condition',  # Use placeholder for reserved keyword 'condition'
                '#medication': 'medication',
                '#bs_unit': 'bs_unit',
                '#carb_unit': 'carb_unit',
                '#lower_bound': 'lower_bound',
                '#upper_bound': 'upper_bound'
            },
            ExpressionAttributeValues={
                ':diabetes_type': data.get("diabetes_type"),
                ':diagnose_date': data.get("diagnose_date"),
                ':insulin_type': data.get("insulin_type"),
                ':admin_route': data.get("admin_route"),
                ':condition': data.get("condition"),
                ':medication': data.get("medication"),
                ':bs_unit': data.get("bs_unit"),
                ':carb_unit': data.get("carb_unit"),
                ':lower_bound': Decimal(str(data.get("lower_bound", 0))),
                ':upper_bound': Decimal(str(data.get("upper_bound", 0)))
            },
            ConditionExpression="attribute_not_exists(SK)",  # Prevent overwriting if condition already exists
        )
        return jsonify({"message": "Patient condition data saved successfully!", "patient_id": userid}), 201
    #except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

# Get user data by userid
@app.route('/users/<userid>', methods=['GET'])
@jwt_required()
def get_user(userid):
    try:
        response = table.get_item(Key={'PK': userid, 'SK': f"USER#{userid}"})
        if 'Item' not in response:
            return jsonify({"error": "User not found."}), 404
        return jsonify(response['Item']), 200
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

# Get condition data by userid
@app.route('/conditions/<userid>', methods=['GET'])
def get_conditions(userid):
    try:
        response = table.get_item(Key={'PK': userid, 'SK': f"CONDITION#{userid}"})
        if 'Item' not in response:
            return jsonify({"error": "No condition data found for the specified patient ID"}), 404
        return jsonify(response['Item']), 200
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

# Get all condition data for all patients
@app.route('/conditions', methods=['GET'])
def get_all_conditions():
    try:
        response = table.scan()
        return jsonify({"patients": response.get('Items', [])}), 200
    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500

if __name__ == '__main__':
    app.run(debug=True)
