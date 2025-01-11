from flask import Flask, request, jsonify
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
import datetime
import boto3
import smtplib
from email.message import EmailMessage
from botocore.exceptions import ClientError
import uuid
from boto3.dynamodb.conditions import Key
from decimal import Decimal
import json



# Initialize Flask app
app = Flask(__name__)

# Setup DynamoDB
dynamodb = boto3.resource('dynamodb')
data_table = dynamodb.Table('DiaLog_Data')
users_table = dynamodb.Table('DiaLog_Users')

# Setup JWT
app.config['JWT_SECRET_KEY'] = 'r0FQJmm/leaRsIhCH3cBevPM6sULf2bZlrhranEy'  # Update with a strong secret key
jwt = JWTManager(app)


class UserClient:
    def __init__(self, user_id):
        self.user_id = user_id

    def search_data(self, attribute):
        try:
            response = users_table.get_item(
    Key={'userid': self.user_id},
    ProjectionExpression="#name, email",
    ExpressionAttributeNames={"#name": "name"}
)


            item = response.get('Item')
            if item:
                return item
            else:
                print("Item not found")
        except Exception as e:
            print(f"Error searching data: {e}")
            return None

    def query_by_date_range(self, data_type, start_date, end_date):
        try:
            response = data_table.query(
                KeyConditionExpression=(
                        Key('userid#datatype').eq(f'{self.user_id}#{data_type}') &
                        Key('date').between(f'{start_date}T00:00:00', f'{end_date}T23:59:59')
                ),
                ProjectionExpression="#date, #value",
                ExpressionAttributeNames={'#date': 'date', '#value': 'value'},
                Limit=500
            )
            return response.get('Items', [])
        except Exception as e:
            print(f"Error querying data: {e}")
            return None

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
    response = users_table.scan(
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
        users_table.put_item(Item=user_dict)

        return jsonify({"message": "User registered successfully!"}), 201
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        return jsonify({"error": "An error occurred during registration."}), 500


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

        # Prepare the diabetes info
        diabetes_info = {
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

        # Use the update_item method to add or update the diabetes information
        try:
            update_expression = "SET diabetes_info = :diabetes_info"
            expression_values = {
                ":diabetes_info": diabetes_info
            }

            users_table.update_item(
                Key={'PK': userid, 'SK': f"USER#{userid}"},
                UpdateExpression=update_expression,
                ExpressionAttributeValues=expression_values
            )

            return jsonify({"message": "Diabetes information added successfully!"}), 201

        except ClientError as e:
            return jsonify({"error": e.response['Error']['Message']}), 500

    except ClientError as e:
        return jsonify({"error": e.response['Error']['Message']}), 500



# User login
# User login endpoint
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"error": "Email and password required."}), 400

    response = users_table.scan(
        FilterExpression="email = :email",
        ExpressionAttributeValues={":email": email}
    )
    users = response.get('Items', [])
    user = users[0] if users else None

    if user and user.get('password') == password:
        access_token = create_access_token(identity=user['userid'])
        return jsonify({"message": "Login successful", "access_token": access_token}), 200

    return jsonify({"error": "Invalid credentials."}), 401


# Get a specific user by ID
@app.route('/users/<user_id>', methods=['GET'])
def get_user(user_id):
    client = UserClient(user_id)
    user = client.search_data(attribute='userid, email, name')
    print(f"Retrieved user: {user}")  # Debugging line

    if not user:
        return jsonify({"error": "User not found."}), 404

    return jsonify(user), 200

# Extract user data to a downloadable file
@app.route('/users/<user_id>/export', methods=['GET'])
def export_user(user_id):
    client = UserClient(user_id)
    user = client.search_data(attribute='userid, email, name')  # Update attributes as needed

    if not user:
        return jsonify({"error": "User not found."}), 404

    user_data = "\n".join([f"{key}: {value}" for key, value in user.items()])
    response_message = {"message": "User data exported successfully"}
    return jsonify(response_message), 200

# Mock database
patient_conditions = {}

# Patient conditions
@app.route('/conditions', methods=['POST'])
def add_conditions():
    data = request.json
    user_id = data.get("user_id")
    
    if not user_id:
        return jsonify({"error": "User ID is required"}), 400
    
    # Save data to DynamoDB
    try:
        data_table.put_item(
            Item={
                'user_id': user_id,
                'condition_data': data  # Storing all condition data as one attribute
            }
        )
        return jsonify({"message": "User condition data saved successfully!", "user_id": user_id}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/conditions/<user_id>', methods=['GET'])
def get_conditions(user_id):
    try:
        # Retrieve data from DynamoDB
        response = data_table.get_item(
            Key={
                'user_id': user_id
            }
        )
        
        # Check if data exists
        if 'Item' not in response:
            return jsonify({"error": "No data found for the specified user ID"}), 404
        
        # Return the condition data
        return jsonify(response['Item']['condition_data']), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


    
@app.route('/graphs', methods=['GET'])
@jwt_required()
def gen_graph():
    data = request.json()
    start = data.get("start")
    end = data.get("end")

    current_user_id = get_jwt_identity()  # Extract user_id from the JWT
    user = UserClient(current_user_id)  # Create a User instance

    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')

    if not start_date or not end_date:
        return jsonify({"error": "Missing required parameters"}), 400

    data = user.query_data(start_date, end_date)
    if data is None:
        return jsonify({"error": "Failed to query data"}), 500

    return jsonify({"data": data})

@app.route('/alert-doctor', methods=['POST'])
def send_alert(bloodSugarLevel):
    current_user_id = get_jwt_identity()  # Extract user_id from the JWT
    user = User(current_user_id)  # Create a User instance

    firstname = user.search_data('firstName')['firstName']
    lastname = user.search_data('lastName')['lastName']
    doctor_email = user.search_data('doctorEmail')['doctorEmail']
    unit = user.search_data('unit')['unit']

    msg = EmailMessage()
    msg.set_content(f'Your patient, {firstname} {lastname}, has recorded an unsafe blood sugar level of {bloodSugarLevel} {unit}.')

    msg['Subject'] = 'Patient Alert from DiaLog'
    msg['From'] = 'javacakesdialog@gmail.com'
    msg['To'] = doctor_email

    # send the message via our own SMTP server
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.login('javacakesdialog@gmail.com', "kwzr qwep klty agqm")
    server.send_message(msg)
    server.quit()


# send notifications accroding to user's personal settings - eg. at a specific time every day


# Questionnaire endpoint to submit responses
@app.route('/questionnaire', methods=['POST'])
@jwt_required()
def submit_questionnaire():
    data = request.json
    current_user_id = get_jwt_identity()  # Extract user ID from the JWT

    # Validate required fields
    required_fields = ['answers']
    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"Missing required field: {field}"}), 400

    # Store the questionnaire data in DynamoDB
    try:
        # Store answers in the DiaLog_Data table using store_answers
        store_answers(current_user_id, data['answers'])

        # Send results to the doctor's email
        send_results_to_doctor(current_user_id, data['answers'])

        return jsonify({"message": "Questionnaire submitted successfully!"}), 201

    except Exception as e:
        return jsonify({"error": f"Failed to store questionnaire: {e}"}), 500


def store_answers(patient_id, answers):
    # Store each answer in DynamoDB using the composite key structure
    for answer in answers:
        question_id = answer.get('question_id')
        response = answer.get('answer')
        timestamp = datetime.utcnow().isoformat()  # Use UTC timestamp

        # Create the composite key (userid#datatype)
        composite_key = f"{patient_id}#{question_id}"

        # Prepare the item for insertion into DynamoDB
        item = {
            'userid#datatype': composite_key,  # Use the composite key
            'date': timestamp,                 # UTC timestamp
            'value': response                  # The answer value
        }

        try:
            # Put the item in the DiaLog_Data table
            data_table.put_item(Item=item)
        except ClientError as e:
            print(f"Error storing answer for patient_id {patient_id}: {e}")


def get_user_by_patient_id(patient_id):
    try:
        response = users_table.get_item(Key={'userid': patient_id})
        if 'Item' in response:
            user = response['Item']
            return {
                'firstName': user.get('firstName', 'Unknown'),
                'lastName': user.get('lastName', 'Unknown'),
                'doctorEmail': user.get('doctorEmail', 'doctor@example.com'),
            }
        else:
            return {
                'firstName': 'Unknown',
                'lastName': 'Unknown',
                'doctorEmail': 'doctor@example.com',
            }
    except ClientError as e:
        print(f"Error getting user by patient_id {patient_id}: {e}")
        return {'firstName': 'Unknown', 'lastName': 'Unknown', 'doctorEmail': 'doctor@example.com'}

# Helper function to send results to the doctor
def send_results_to_doctor(patient_id, answers):
    user = get_user_by_patient_id(patient_id)
    firstname = user['firstName']
    lastname = user['lastName']
    doctor_email = user['doctorEmail']
    
    # Prepare the email content with all questions and answers
    questionnaire_responses = "\n".join([f"Q{answer['question_id']}: {answer['answer']}" for answer in answers])

    msg = EmailMessage()
    msg.set_content(f'Your patient, {firstname} {lastname}, has submitted the following questionnaire responses:\n\n{questionnaire_responses}')
    msg['Subject'] = 'Patient Questionnaire Responses from DiaLog'
    msg['From'] = 'javacakesdialog@gmail.com'
    msg['To'] = doctor_email

    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.login('javacakesdialog@gmail.com', "your_email_password")  # Update with a secure method for password management
    server.send_message(msg)
    server.quit()



if __name__ == '__main__':
    app.run(debug=True)