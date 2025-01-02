from flask import Flask, request, jsonify
import boto3
from datetime import datetime
import smtplib
from email.message import EmailMessage
from botocore.exceptions import ClientError

app = Flask(__name__)

# Initialize DynamoDB resource (replace with your AWS region)
app.config['JWT_SECRET_KEY'] = 'r0FQJmm/leaRsIhCH3cBevPM6sULf2bZlrhranEy'  # Update with a strong secret key

dynamodb = boto3.resource('dynamodb', region_name='eu-west-2')  # Example region
data_table = dynamodb.Table('DiaLog_Data')
users_table = dynamodb.Table('DiaLog_Users')

@app.route('/questionnaire', methods=['POST'])
def submit_questionnaire():
    data = request.json
    current_user_id = data.get('patient_id')  # Extract user ID from the request

    # Validate required fields
    required_fields = ['answers']
    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"Missing required field: {field}"}), 400

    # Store the questionnaire data in DynamoDB
    try:
        # Store answers in the DiaLog_Data table
        for answer in data['answers']:
            question_id = answer['question_id']
            response = answer['answer']
            timestamp = datetime.utcnow().isoformat()  # Use UTC timestamp

            item = {
                'userid': current_user_id,
                'datatype': question_id,
                'date': timestamp,
                'value': response
            }
            data_table.put_item(Item=item)

        store_answers(current_user_id, data['answers'])
        # Send results to the doctor's email
        send_results_to_doctor(current_user_id, data['answers'])

        return jsonify({"message": "Questionnaire submitted successfully!"}), 201

    except Exception as e:
        return jsonify({"error": f"Failed to store questionnaire: {e}"}), 500

def store_answers(patient_id, answers):
    # Store each answer in DynamoDB
    for answer in answers:
        question_id = answer["question_id"]
        response = answer["answer"]
        timestamp = str(datetime.utcnow())  # Use UTC time for the date field
        
        if not question_id or not response:
            print(f"Missing question_id or response for answer: {answer}")
            continue
        
        # Prepare the item for insertion into DynamoDB
        item = {
            'userid': str(patient_id),    # Ensure 'userid' is properly set
            'datatype': str(question_id), # Ensure 'datatype' is properly set (question ID)
            'date': timestamp,            # UTC timestamp
            'value': response             # The answer value
        }
        
        try:
            # Put the item in the DiaLog_Data table
            data_table.put_item(Item=item)
        except ClientError as e:
            print(f"Error storing answer for patient_id {patient_id}: {e}")


def send_results_to_doctor(patient_id, answers):
    user = get_user_by_patient_id(patient_id)  # Fetch user data for the given patient_id

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
    server.login('javacakesdialog@gmail.com', "kwzr qwep klty agqm")
    server.send_message(msg)
    server.quit()


def get_user_by_patient_id(patient_id):
    # Query the DiaLog_Users table for the user by their patient_id (userid)
    try:
        response = users_table.get_item(Key={'userid': patient_id})  # Assuming 'userid' is the partition key
        
        # Check if the item exists
        if 'Item' in response:
            user = response['Item']
            return {
                'firstName': user.get('firstName', 'Unknown'),
                'lastName': user.get('lastName', 'Unknown'),
                'doctorEmail': user.get('doctorEmail', 'doctor@example.com'),
            }
        else:
            # If no user is found, return default values
            return {
                'firstName': 'Unknown',
                'lastName': 'Unknown',
                'doctorEmail': 'doctor@example.com',
            }
    
    except ClientError as e:
        # Handle errors when querying DynamoDB
        print(f"Error getting user by patient_id {patient_id}: {e}")
        return {
            'firstName': 'Unknown',
            'lastName': 'Unknown',
            'doctorEmail': 'doctor@example.com',
        }

if __name__ == '__main__':
    app.run(debug=True)
