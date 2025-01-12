import boto3
from flask import Flask, request, jsonify, json
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
import datetime
import uuid

app = Flask(__name__)

# Configure Flask-JWT
app.config['JWT_SECRET_KEY'] = 'r0FQJmm/leaRsIhCH3cBevPM6sULf2bZlrhranEy'  # Update with a strong secret key
jwt = JWTManager(app)

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name='eu-west-2')  # Change region if necessary
table = dynamodb.Table('DiaLog_Users')  # Your DynamoDB table name

# User model (we'll use a dictionary structure instead of a SQLAlchemy model)
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

# User registration
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
    response = table.scan(
        FilterExpression=boto3.dynamodb.conditions.Attr('email').eq(data['email'])
    )
    if response['Items']:
        return jsonify({"error": "Email already in use."}), 400

    # Create a new user object
    try:
        # Create a new user object (no need to pass 'userid' since it's auto-generated)
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
        table.put_item(Item=user_dict)

        return jsonify({"message": "User registered successfully!"}), 201
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        return jsonify({"error": "An error occurred during registration."}), 500

# User login
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"error": "Email and password required."}), 400

    # Retrieve user from DynamoDB
    response = table.scan(
        FilterExpression=boto3.dynamodb.conditions.Attr('email').eq(email)
    )

    if not response['Items']:
        return jsonify({"error": "User not found."}), 404

    user = response['Items'][0]

    if user['password'] == password:  # Hash comparison in production
        access_token = create_access_token(identity=user['id'], expires_delta=False)
        return jsonify({"message": "Login successful", "access_token": access_token}), 200

    return jsonify({"error": "Invalid credentials."}), 401

# Get all users
@app.route('/users', methods=['GET'])
@jwt_required()
def get_users():
    response = table.scan()
    users = response['Items']

    return jsonify({"users": users}), 200

# Get a specific user
@app.route('/users/<user_id>', methods=['GET'])
@jwt_required()
def get_user(user_id):
    response = table.get_item(Key={'id': user_id})

    if 'Item' not in response:
        return jsonify({"error": "User not found."}), 404

    return jsonify(response['Item']), 200

# Update user profile
@app.route('/profile', methods=['PUT'])
@jwt_required()
def update_profile():
    current_user_id = get_jwt_identity()
    data = request.json
    updatable_fields = ['weight', 'height']

    # Retrieve user from DynamoDB
    response = table.get_item(Key={'id': current_user_id})

    if 'Item' not in response:
        return jsonify({"error": "User not found."}), 404

    user = response['Item']

    # Update fields
    for field in updatable_fields:
        if field in data:
            user[field] = data[field]

    # Save updated user back to DynamoDB
    table.put_item(Item=user)

    return jsonify({"message": "Profile updated successfully!"}), 200

if __name__ == '__main__':
    app.run(debug=True)
