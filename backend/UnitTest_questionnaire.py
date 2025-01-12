import unittest
from unittest.mock import patch, MagicMock
from main2 import app, send_results_to_doctor  
from flask import jsonify

class TestSubmitQuestionnaire(unittest.TestCase):

    @patch('main2.data_table.put_item')  # Mocking DynamoDB's put_item
    @patch('main2.smtplib.SMTP_SSL')    # Mocking smtplib's SMTP_SSL
    @patch('main2.get_user_by_patient_id')  # Mocking the get_user_by_patient_id function
    def test_submit_questionnaire_success(self, mock_get_user, mock_smtp, mock_put_item):
        # Setup mock return values
        mock_get_user.return_value = {'first_name': 'John', 'last_name': 'Doe', 'doctor_email': 'doctor@example.com'}
        
        mock_smtp.return_value = MagicMock()  # Mocking the SMTP server
        mock_smtp.return_value.login.return_value = None
        mock_smtp.return_value.send_message.return_value = None
        
        # Mock the data to be submitted in the request
        data = {
            'userid': '12345',
            'answers': [
                {'question_id': 'q1', 'answer': 'Yes'},
                {'question_id': 'q2', 'answer': 'No'}
            ]
        }
        
        with app.test_client() as client:
            # Simulate a POST request to the /questionnaire route
            response = client.post('/questionnaire', json=data)

            print(response.data)

            # Assertions
            self.assertEqual(response.status_code, 201)
            self.assertIn("Questionnaire submitted successfully!", response.get_json().get('message'))
            mock_put_item.assert_called()  # Ensure store_answers (and thus DynamoDB put_item) was called
            mock_smtp.return_value.send_message.assert_called()  # Ensure email sending function was called

    @patch('main2.data_table.put_item')
    @patch('main2.get_user_by_patient_id')
    def test_submit_questionnaire_missing_userid(self, mock_get_user, mock_put_item):
        data = {'answers': [{'question_id': 'q1', 'answer': 'Yes'}]}
        
        with app.test_client() as client:
            response = client.post('/questionnaire', json=data)
            
            self.assertEqual(response.status_code, 400)
            self.assertIn("Missing 'userid' in request data", response.get_json().get('error'))

    @patch('main2.data_table.put_item')
    @patch('main2.get_user_by_patient_id')
    def test_submit_questionnaire_invalid_json(self, mock_get_user, mock_put_item):
        data = None  # Invalid JSON format
        
        with app.test_client() as client:
            response = client.post('/questionnaire', json=data)
            
            self.assertEqual(response.status_code, 400)
            self.assertIn("Invalid JSON format", response.get_json().get('error'))

    @patch('main2.data_table.put_item')
    @patch('main2.get_user_by_patient_id')
    def test_submit_questionnaire_invalid_answers(self, mock_get_user, mock_put_item):
        data = {'userid': '12345', 'answers': 'Invalid data'}  # Invalid answers format
        
        with app.test_client() as client:
            response = client.post('/questionnaire', json=data)
            
            self.assertEqual(response.status_code, 400)
            self.assertIn("Invalid or missing 'answers' field", response.get_json().get('error'))

    @patch('main2.data_table.put_item')
    @patch('main2.get_user_by_patient_id')
    @patch('main2.smtplib.SMTP_SSL')
    def test_send_results_to_doctor(self, mock_smtp, mock_get_user, mock_put_item):
        # Mock dependencies
        mock_get_user.return_value = {'first_name': 'John', 'last_name': 'Doe', 'doctor_email': 'doctor@example.com'}
        
        mock_smtp.return_value = MagicMock()
        mock_smtp.return_value.login.return_value = None
        mock_smtp.return_value.send_message.return_value = None
        
        answers = [{'question_id': 'q1', 'answer': 'Yes'}, {'question_id': 'q2', 'answer': 'No'}]
        patient_id = '12345'
        
        # Call send_results_to_doctor
        send_results_to_doctor(patient_id, answers)

        # Assertions
        mock_smtp.return_value.send_message.assert_called_once()  # Check that email was sent

if __name__ == '__main__':
    unittest.main()
