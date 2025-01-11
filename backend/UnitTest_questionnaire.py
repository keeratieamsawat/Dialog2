import unittest
from unittest.mock import patch
from flask import Flask, jsonify
from flask.testing import FlaskClient
from main2 import app  # Assuming your app is named 'app.py'
from flask_jwt_extended import jwt_required

class TestQuestionnaireEndpoint(unittest.TestCase):
    
    def setUp(self):
        self.client = app.test_client()  # This sets up the test client

    @patch('main2.store_answers')  # Mock store_answers function
    @patch('main2.send_results_to_doctor')  # Mock send_results_to_doctor function
    @patch('flask_jwt_extended.jwt_required')
    def test_submit_questionnaire_success(self, mock_jwt, mock_send_results, mock_store_answers):
        # Arrange
        mock_jwt.return_value = None
        mock_store_answers.return_value = None  # Mock successful storage
        mock_send_results.return_value = None  # Mock successful email sending
        data = {"answers": [{"question_id": 1, "answer": "yes"}]}
        
        # Act
        response = self.client.post('/questionnaire', json=data)
        
        # Assert
        self.assertEqual(response.status_code, 201)
        self.assertIn('Questionnaire submitted successfully!', response.json['message'])

    @patch('flask_jwt_extended.jwt_required')
    def test_submit_questionnaire_invalid_json(self, mock_jwt):
        # Arrange: Invalid JSON
        mock_jwt.return_value = None
        invalid_json = '{invalid_json}'  # This will cause a JSON parsing error
        
        # Act
        response = self.client.post('/questionnaire', data=invalid_json, content_type='application/json')
        
        # Assert: Expect a 422 error for invalid JSON
        self.assertEqual(response.status_code, 422)
        self.assertIn('Invalid JSON format', response.json['error'])

    @patch('flask_jwt_extended.jwt_required')
    def test_submit_questionnaire_missing_answers_field(self, mock_jwt):
        # Arrange: Missing 'answers' field
        data = {"missing_answers_field": "some_value"}  # Missing 'answers' field
        
        mock_jwt.return_value = None
        response = self.client.post('/questionnaire', json=data)
        
        # Assert: Expect a 422 error as the 'answers' field is missing
        self.assertEqual(response.status_code, 422)
        self.assertIn("Invalid or missing 'answers' field", response.json['error'])

    @patch('main2.store_answers')
    @patch('flask_jwt_extended.jwt_required')
    def test_submit_questionnaire_storage_failure(self, mock_jwt, mock_store_answers):
        # Arrange: Simulate storage failure
        mock_jwt.return_value = None
        mock_store_answers.side_effect = Exception("Storage error")  # Mocking storage failure
        
        data = {"answers": [{"question_id": 1, "answer": "yes"}]}
        
        # Act
        response = self.client.post('/questionnaire', json=data)
        
        # Assert: Expect a 500 error due to storage failure
        self.assertEqual(response.status_code, 500)
        self.assertIn("Failed to store questionnaire", response.json['error'])

if __name__ == '__main__':
    unittest.main()
