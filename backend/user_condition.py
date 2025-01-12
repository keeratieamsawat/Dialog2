from flask import Flask, request, jsonify
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
import uuid
import boto3
from botocore.exceptions import ClientError
from decimal import Decimal
import json

# Initialize Flask app
app = Flask(__name__)

# Setup DynamoDB
dynamodb = boto3.resource('dynamodb')
users_table = dynamodb.Table('DiaLog_Users')

# Setup JWT
app.config['JWT_SECRET_KEY'] = 'r0FQJmm/leaRsIhCH3cBevPM6sULf2bZlrhranEy'  # Update with a strong secret key
jwt = JWTManager(app)

# User class to represent a user and convert to dictionary for storage in DynamoDB
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
            'PK': self.userid,  # User ID as Partition Key
            'SK': f"USER#{self.userid}",  # Sort Key with "USER#" to differentiate
            'first_name': self.firstName,
            'last_name': self.lastName,
            'email': self.email,
            'password': self.password,  # Hash this in production
            'gender': self.gender,
            'birthdate': self.birthdate,
            'country_of_residence': self.residence,
            'weight': self.weight,
            'height': self.height,
            'consent': self.consent
        }

    # Add diabetes info method
    def add_diabetes_info(self, diabetes_data):
        return {
            'PK': self.userid,  # Use the same PK for diabetes info
            'SK': f"DIABETES#{self.userid}",  # Sort Key for diabetes-related data
            'diabetes_type': diabetes_data.get("diabetes_type"),
            'diagnose_date': diabetes_data.get("diagnose_date"),
            'insulin_type': diabetes_data.get("insulin_type"),
            'admin_route': diabetes_data.get("admin_route"),
            'condition': diabetes_data.get("condition"),
            'medication': diabetes_data.get("medication"),
            'bs_unit': diabetes_data.get("bs_unit"),
            'carb_unit': diabetes_data.get("carb_unit"),
            'lower_bound': Decimal(str(diabetes_data.get("lower_bound", 0))),
            'upper_bound': Decimal(str(diabetes_data.get("upper_bound", 0))),
        }

# User registration route
@app.route('/register', methods=['POST'])
def register():
    data = request.json
    required_fields = [
        'first_name', 'last_name', 'email', 'password', 'confirm_password',
        'gender', 'birthdate', 'country_of_residence', 'emergency_contact',
        'weight', 'height', 'consent'
    ]

    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"Missing required field: {field}"}), 400

    if data['password'] != data['confirm_password']:
        return jsonify({"error": "Passwords do not match."}), 400

    if not data.get('consent', False):
        return jsonify({"error": "User must agree to terms and conditions."}), 400

    # Check if the user already exists in DynamoDB
    response = users_table.scan(
        FilterExpression=boto3.dynamodb.conditions.Attr('email').eq(data['email'])
    )
    if response['Items']:
        return jsonify({"error": "Email already in use."}), 400

    try:
        # Create a new user object
        new_user = User(
            first_name=data['first_name'],
            last_name=data['last_name'],
            email=data['email'],
            password=data['password'],  # Hash this in production
            gender=data['gender'],
            birthdate=data['birthdate'],
            country_of_residence=data['country_of_residence'],
            weight=data['weight'],
            height=data['height'],
            consent=data['consent']
        )

        # Ensure the 'userid' is included in the item before saving to DynamoDB
        user_dict = new_user.as_dict()

        # Debugging: print the user_dict to ensure 'userid' is in it
        print("User dictionary being inserted:", json.dumps(user_dict, indent=2))

        # Store user in DynamoDB (new_user.as_dict() includes the generated 'userid')
        users_table.put_item(Item=user_dict)

        return jsonify({"message": "User registered successfully!"}), 201
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        return jsonify({"error": "An error occurred during registration."}), 500

# Add patient diabetes-related data route
@app.route('/add_diabetes_info', methods=['POST'])
def add_diabetes_info():
    data = request.json
    userid = data.get("userid")

    if not userid:
        return jsonify({"error": "User ID is required"}), 400

    # Fetch user from DynamoDB (assuming user already exists)
    try:
        response = users_table.get_item(Key={'PK': userid, 'SK': f"USER#{userid}"})
        if 'Item' not in response:
            return jsonify({"error": "User not found"}), 404

        user_data = response['Item']
        user_data['PK'] = userid
        user_data['SK'] = f"USER#{userid}"
        print("User Data to be inserted:", user_data)  # Print user data for debugging
        response = users_table.put_item(Item=user_data)
        print("Put Item Response:", response)  # Check if the response is successful


        # Add diabetes info to the user data
        user_data['diabetes_info'] = {
            "userid": userid,
            'diabetes_type': data.get('diabetes_type'),
            'diagnose_date': data.get('diagnose_date'),
            'insulin_type': data.get('insulin_type'),
            'admin_route': data.get('admin_route'),
            'condition': data.get('condition'),
            'medication': data.get('medication'),
            'bs_unit': data.get('bs_unit'),
            'carb_unit': data.get('carb_unit'),
            'lower_bound': data.get('lower_bound'),
            'upper_bound': data.get('upper_bound')
        }

        # Update the user with diabetes info in DynamoDB
        users_table.put_item(Item=user_data)

        return jsonify({"message": "Diabetes information added successfully!"}), 201

    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500


if __name__ == '__main__':
    app.run(debug=True)
