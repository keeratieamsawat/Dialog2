from flask import Flask, request, jsonify
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from datetime import datetime, timezone
import boto3
import smtplib
from email.message import EmailMessage
from botocore.exceptions import ClientError
import uuid
from boto3.dynamodb.conditions import Key
from decimal import Decimal
import json
import logging



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

    def search_data(self, field_name):
        try:
            # Query the user's main record
            response = users_table.get_item(Key={'PK': self.user_id})
            if 'Item' not in response:
                raise ValueError("User not found")

            # Check if the requested field is in the main record
            user_data = response['Item']
            if field_name in user_data:
                return user_data[field_name]

            # Check if the field is in the diabetes_info structure
            diabetes_info = user_data.get('diabetes_info', {})
            if field_name in diabetes_info:
                return diabetes_info[field_name]

            raise ValueError(f"Field {field_name} not found")
        except Exception as e:
            print(f"Error retrieving data: {e}")
            return None

    def query_by_date_range(self, data_type, start_datetime, end_datetime):
        try:
            response = data_table.query(
                KeyConditionExpression=(
                        Key('userid#datatype').eq(f'{self.user_id}#{data_type}') &
                        Key('date').between(start_datetime, end_datetime)
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
        self.first_name = first_name
        self.last_name = last_name
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
            'first_name': self.first_name,
            'last_name': self.last_name,
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
    userid = str(data.get("userid"))

    if not isinstance(userid, str) or not userid.strip():
        return jsonify({"error": "Invalid or missing User ID"}), 400

    # Fetch user from DynamoDB (assuming user already exists)
    try:
        print(f"Received request data: {data}")
        response = users_table.get_item(Key={'userid': userid})
        print(f"DynamoDB get_item response: {response}")
        if 'Item' not in response:
            return jsonify({"error": "User not found"}), 404

        update_expression = "SET diabetes_type = :diabetes_type, diagnose_date = :diagnose_date, insulin_type = :insulin_type, admin_route = :admin_route, #condition = :condition, medication = :medication, lower_bound = :lower_bound, upper_bound = :upper_bound, doctor_name = :doctor_name, doctor_email = :doctor_email"
        expression_values = {
            ":diabetes_type": data.get('diabetes_type'),
            ":diagnose_date": data.get('diagnose_date'),
            ":insulin_type": data.get('insulin_type'),
            ":admin_route": data.get('admin_route'),
            ":condition": data.get('condition'),
            ":medication": data.get('medication'),
            ":lower_bound": Decimal(data.get('lower_bound')),
            ":upper_bound": Decimal(data.get('upper_bound')),
            ":doctor_name": data.get('doctor_name'),
            ":doctor_email": data.get('doctor_email'),
        }


        print("Updating DynamoDB with diabetes info...")
        users_table.update_item(
            Key={'userid': userid},
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_values,
            ExpressionAttributeNames={
                "#condition": "condition"  # 'condition' is a reserved word in DynamoDB
            }
        )
        

        return jsonify({"message": "Diabetes information added successfully!"}), 201

    except ClientError as e:
        error_message = e.response['Error']['Message']
        print(f"Error during DynamoDB operation: {error_message}")
        return jsonify({"error": error_message}), 500
    

    #update the diabetic info 
@app.route('/update_diabetes_info', methods=['PUT'])
def update_diabetes_info():
    data = request.json
    userid = data.get("userid")

    if not userid:
        return jsonify({"error": "User ID is required"}), 400

    try:
        # Fetch user from DynamoDB to verify existence
        response = users_table.get_item(Key={'userid': userid})
        if 'Item' not in response:
            return jsonify({"error": "User not found"}), 404

        updated_diabetes_info = {}

        for field in [
            "diabetes_type", "diagnose_date", "insulin_type", 
            "admin_route", "condition", "medication", 
            "lower_bound", "upper_bound", "doctor_name", "doctor_email"
        ]:
            if data.get(field) is not None:
                updated_diabetes_info[field] = data[field]

        if not updated_diabetes_info:
            return jsonify({"error": "No valid fields provided for update"}), 400

        # Update the database with only the provided fields
        update_expression = "SET " + ", ".join(f"{field} = :{field}" for field in updated_diabetes_info)
        expression_values = {f":{field}": value for field, value in updated_diabetes_info.items()}

        users_table.update_item(
            Key={'userid': userid},
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_values
        )

        return jsonify({"message": "Diabetes information updated successfully!"}), 200

    except ClientError as e:
        error_message = e.response['Error']['Message']
        print(f"Error during DynamoDB operation: {error_message}")
        return jsonify({"error": error_message}), 500
    

@app.route('/get_diabetes_info/<string:userid>', methods=['GET'])
def get_diabetes_info(userid):
    if not userid:
        return jsonify({"error": "User ID is required"}), 400

    try:
        # Fetch the user's record from DynamoDB
        response = users_table.get_item(Key={'userid': userid})

        if 'Item' not in response:
            return jsonify({"error": "User not found"}), 404

        # Extract diabetes information
        item = response['Item']
        diabetes_info = {
            "diabetes_type": item.get("diabetes_type"),
            "diagnose_date": item.get("diagnose_date"),
            "insulin_type": item.get("insulin_type"),
            "admin_route": item.get("admin_route"),
            "condition": item.get("condition"),
            "medication": item.get("medication"),
            "lower_bound": item.get("lower_bound"),
            "upper_bound": item.get("upper_bound"),
            "doctor_name": item.get("doctor_name"),
            "doctor_email": item.get("doctor_email")
        }

        # Return the diabetes information
        return jsonify({"userid": userid, "diabetes_info": diabetes_info}), 200

    except ClientError as e:
        error_message = e.response['Error']['Message']
        print(f"Error during DynamoDB operation: {error_message}")
        return jsonify({"error": error_message}), 500




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
    conditions = data.get("conditions")
    
    if not user_id:
        return jsonify({"error": "User ID is required"}), 400
    
    if not conditions or not isinstance(conditions, list):
        return jsonify({"error": "Conditions data is required and must be a list"}), 400

    try:
        for condition in conditions:
            datatype = condition.get('datatype')
            value = condition.get('value')  # Blood sugar value or other
            date = condition.get('date')  # Ensure each condition has a unique identifier
            
            if not datatype or value is None or not date:
                return jsonify({"error": "Each condition must have datatype, value, and date"}), 400
            
            try:
                datetime.strptime(date, '%Y-%m-%dT%H:%M:%S')
            except ValueError:
                return jsonify({"error": "Invalid date format"}), 400
            
            # Create the composite key
            composite_key = f"{user_id}#{datatype}"

            # Prepare the item for insertion into DynamoDB
            item = {
                'userid#datatype': composite_key,  # Composite key
                'date': date,                      # Date of the condition
                'value': value,      # Store condition details
                'timestamp': datetime.now(timezone.utc).isoformat()  # Timestamp of the entry
            }

            # Insert the item into DynamoDB
            try:
                data_table.put_item(Item=item)
            except Exception as e:
                print(f"Error inserting into DynamoDB: {str(e)}")
                return jsonify({"error": "Failed to insert data into DynamoDB"}), 500


        return jsonify({"message": "User conditions saved successfully!", "user_id": user_id}), 201
    except Exception as e:
        print(f"Error in add_conditions: {str(e)}")
        return jsonify({"error": str(e)}), 500


@app.route('/conditions/<user_id>', methods=['GET'])
def get_conditions(user_id):
    try:
        # Retrieve data from DynamoDB
        # Scan the table for all conditions associated with the user_id
        response = data_table.scan(
            FilterExpression="begins_with(userid#datatype, :user_id)",
            ExpressionAttributeValues={
                ':user_id': user_id
            }
        )
        
        # Check if data exists
        items = response.get('Items', [])
        if not items:
            return jsonify({"error": "No data found for the specified user ID"}), 404

        conditions = [
            {
                'datatype': item['userid#datatype'].split('#')[1],
                'date': item['date'],
                'value': item['value']
            }
            for item in items
        ]

        return jsonify({"user_id": user_id, "conditions": conditions}), 200
    except Exception as e:
        print(f"Error in get_conditions: {str(e)}")
        return jsonify({"error": str(e)}), 500
    

@app.route('/conditions/<user_id>/<datatype>', methods=['PUT'])
def update_conditions(user_id, datatype):
    data = request.json

    if not data or 'value' not in data or 'date' not in data:
        error_message = "Condition data (value and date) is required"
        logging.error(error_message)
        return jsonify({"error": error_message}), 400
    
    value = data.get('value')
    date = data.get('date')

    try:
        composite_key = f"{user_id}#{datatype}"

        logging.debug(f"Attempting to update condition for user_id: {user_id}, datatype: {datatype}, value: {value}, date: {date}")

        # Check if the item exists in DynamoDB before updating
        response = data_table.get_item(Key={'userid#datatype': composite_key})
        if 'Item' not in response:
            error_message = "Condition not found for the given user_id and datatype"
            logging.error(f"{error_message} (user_id: {user_id}, datatype: {datatype})")
            return jsonify({"error": error_message}), 404
        
        logging.debug(f"Found condition data in DynamoDB: {response}")
        
        # Update the item
        update_response = data_table.update_item(
            Key={'userid#datatype': composite_key},
            UpdateExpression="SET value = :value, date = :date",
            ExpressionAttributeValues={
                ':value': value,
                ':date': date
            },
            ReturnValues="UPDATED_NEW"
        )

        logging.debug(f"Update response from DynamoDB: {update_response}")

        # Get the updated data from the update response
        updated_data = update_response.get('Attributes', {})
        if not updated_data:
            error_message = "Condition not found for the given user_id and datatype"
            logging.error(f"{error_message} (user_id: {user_id}, datatype: {datatype})")
            return jsonify({"error": error_message}), 404
        
        logging.info(f"Successfully updated condition for user_id: {user_id}, datatype: {datatype}")

        return jsonify({
            "message": "User condition data updated successfully!",
            "updated_data": updated_data
        }), 200
    
    except Exception as e:
        logging.error(f"Error in update_conditions: {str(e)}")
        return jsonify({"error": str(e)}), 500

    
@app.route('/graphs', methods=['GET'])
@jwt_required()
def gen_graph():
    data = request.json()

    current_user_id = get_jwt_identity()  # Extract user_id from the JWT
    user = UserClient(current_user_id)  # Create a User instance

    start_date = request.args.get('start_datetime')
    end_date = request.args.get('end_datetime')

    print("DEBUG: Received start_date =", start_date)
    print("DEBUG: Received end_date =", end_date)

    if not start_date or not end_date:
        return jsonify({"error": "Missing required parameters"}), 400, {'Content-Type': 'application/json'}

    data = user.query_data(start_date, end_date)
    print("DEBUG: query_data result =", data)
    if data is None:
        print("DEBUG: query_data returned None, triggering 500 response.")
        return jsonify({"error": "Failed to query data"}), 500

    return jsonify({"data": data})


@app.route('/alert-doctor', methods=['POST'])
def send_alert():
    try:
        # Extract the data from the request
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['userid', 'bloodSugarLevel']
        missing_fields = [field for field in required_fields if field not in data]
        if missing_fields:
            return jsonify({"error": f"Missing required fields: {', '.join(missing_fields)}"}), 400
        
        # Extract the user ID and blood sugar level
        current_user_id = data['userid']
        bloodSugarLevel = data['bloodSugarLevel']
        
        # Create a User instance
        user = UserClient(current_user_id)

        # Retrieve user data for constructing the email
        firstname = user.search_data('first_name')
        lastname = user.search_data('last_name')
        doctor_email = user.search_data('doctor_email')

        if not firstname or not lastname or not doctor_email:
            return jsonify({"error": "User data incomplete. Unable to send alert."}), 400
        
        # Create the email message
        msg = EmailMessage()
        msg.set_content(f'Your patient, {firstname} {lastname}, has recorded an unsafe blood sugar level of {bloodSugarLevel} mol/L.')
        msg['Subject'] = 'Patient Alert from DiaLog'
        msg['From'] = 'javacakesdialog@gmail.com'
        msg['To'] = doctor_email

        # Send the message via SMTP
        server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        server.login('javacakesdialog@gmail.com', "kwzr qwep klty agqm")
        server.send_message(msg)
        server.quit()

        return jsonify({"message": "Alert sent to doctor successfully!"}), 200

    except Exception as e:
        return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500



# send notifications accroding to user's personal settings - eg. at a specific time every day


# Questionnaire endpoint to submit responses
@app.route('/questionnaire', methods=['POST'])
def submit_questionnaire():
    # Ensure the request has JSON content type
    if not request.is_json:
        return jsonify({"error": "Invalid JSON format"}), 400

    try:
        data = request.get_json()  # Get JSON data

        if not data:
            return jsonify({"error": "Invalid JSON format"}), 400

        # Extract user ID and check if it's provided
        current_user_id = data.get('userid')
        if not current_user_id:
            return jsonify({"error": "Missing 'userid' in request data"}), 400

        # Validate required fields
        required_fields = ['answers']
        if not all(field in data for field in required_fields) or not isinstance(data['answers'], list):
            return jsonify({"error": "Invalid or missing 'answers' field"}), 400

        # Store answers in the DiaLog_Data table using store_answers
        store_answers(current_user_id, data['answers'])

        # Send results to the doctor's email
        send_results_to_doctor(current_user_id, data['answers'])

        return jsonify({"message": "Questionnaire submitted successfully!"}), 201

    except Exception as e:
        app.logger.error(f"Error in submitting questionnaire: {str(e)}")  # Log the exception for debugging
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
                'first_name': user.get('first_name', 'Unknown'),
                'last_name': user.get('last_name', 'Unknown'),
                'doctor_email': user.get('doctor_email', 'Unkown'),
            }
        else:
            return {
                'first_name': 'Unknown',
                'last_name': 'Unknown',
                'doctor_email': 'Unknown',
            }
    except ClientError as e:
        print(f"Error getting user by patient_id {patient_id}: {e}")
        return {'first_name': 'Unknown', 'last_name': 'Unknown', 'doctor_email': 'Unknown'}

# Helper function to send results to the doctor
def send_results_to_doctor(patient_id, answers):
    user = get_user_by_patient_id(patient_id)
    firstname = user['first_name']
    lastname = user['last_name']
    doctor_email = user['doctor_email']
    
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