#The script contains unit tests for the /alert-doctor endpoint in a Flask app.
#This test suite is structured with the help from ChatGPT to ensure proper testing to ensure proper mocking
# of dependencies like 'UserClient' and 'smtplib.SMTP_SSL' in Flask route testing.

import unittest
from unittest.mock import patch, MagicMock
from flask import Flask, jsonify
from main2 import app, User  # Import your Flask app and User class

class TestSendAlert(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()
        self.client.testing = True

    @patch('main2.UserClient.search_data')
    @patch('main2.smtplib.SMTP_SSL')
    def test_send_alert_success(self, MockSMTP, mock_search_data):
        # Mocking the User's search_data method
        mock_search_data.side_effect = lambda field: {
            'first_name': 'John',
            'last_name': 'Doe',
            'doctor_email': 'doctor@example.com',
        }.get(field)

        # Mock the SMTP_SSL behavior
        mock_smtp_instance = MagicMock()
        MockSMTP.return_value = mock_smtp_instance

        # Example request data
        request_data = {
            "userid": "f87cd4cb-8959-4daf-a040-88add0d53727",
            "bloodSugarLevel": 250
        }

        # Send POST request to /alert-doctor endpoint
        response = self.client.post('/alert-doctor', json=request_data)

        # Check the response status and message
        self.assertEqual(response.status_code, 200)
        self.assertIn("Alert sent to doctor successfully!", response.json['message'])

        # Ensure that the email was sent
        mock_smtp_instance.send_message.assert_called_once()

        # Verify the email content
        msg = mock_smtp_instance.send_message.call_args[0][0]
        self.assertIn('Your patient, John Doe, has recorded an unsafe blood sugar level of 250 mol/L.', msg.get_content())

    @patch('main2.UserClient.search_data')
    def test_send_alert_missing_fields(self, mock_search_data):
        # Simulate missing 'bloodSugarLevel'
        request_data = {
            "userid": "f87cd4cb-8959-4daf-a040-88add0d53727"
        }

        # Send POST request to /alert-doctor endpoint
        response = self.client.post('/alert-doctor', json=request_data)

        # Check the response status and error message
        self.assertEqual(response.status_code, 400)
        self.assertIn("Missing required fields: bloodSugarLevel", response.json['error'])

    @patch('main2.UserClient.search_data')
    @patch('main2.smtplib.SMTP_SSL')
    def test_send_alert_incomplete_user_data(self, MockSMTP, mock_search_data):
        # Mocking incomplete user data (e.g., missing doctor email)
        mock_search_data.side_effect = lambda field: {
            'first_name': 'John',
            'last_name': 'Doe',
        }.get(field)

        # Mock the SMTP_SSL behavior
        mock_smtp_instance = MagicMock()
        MockSMTP.return_value = mock_smtp_instance

        # Example request data
        request_data = {
            "userid": "f87cd4cb-8959-4daf-a040-88add0d53727",
            "bloodSugarLevel": 250
        }

        # Send POST request to /alert-doctor endpoint
        response = self.client.post('/alert-doctor', json=request_data)

        # Check the response status and error message
        self.assertEqual(response.status_code, 400)
        self.assertIn("User data incomplete. Unable to send alert.", response.json['error'])

    @patch('main2.UserClient.search_data')
    def test_send_alert_error(self, mock_search_data):
        # Mocking an exception during the user data retrieval
        mock_search_data.side_effect = Exception("Some error")

        # Example request data
        request_data = {
            "userid": "f87cd4cb-8959-4daf-a040-88add0d53727",
            "bloodSugarLevel": 250
        }

        # Send POST request to /alert-doctor endpoint
        response = self.client.post('/alert-doctor', json=request_data)

        # Check the response status and error message
        self.assertEqual(response.status_code, 500)
        self.assertIn("An unexpected error occurred", response.json['error'])

if __name__ == '__main__':
    unittest.main()
