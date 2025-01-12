import unittest
from unittest.mock import patch, MagicMock
from main2 import app  # Import your Flask app

class TestSendAlert(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()  # Set up the Flask test client
        self.app.testing = True

    @patch('main2.get_jwt_identity')  # Mocking get_jwt_identity
    @patch('main2.User')  # Mocking the User class
    @patch('smtplib.SMTP_SSL')  # Mocking smtplib.SMTP_SSL
    def test_send_alert_success(self, MockSMTP, MockUser, MockGetJWT):
        # Mock the JWT identity to return a user ID
        MockGetJWT.return_value = 'test_user_id'

        # Mock the User instance and the search_data method
        mock_user = MagicMock()
        mock_user.search_data.side_effect = [
            {'first_name': 'John'},  # first_name
            {'last_name': 'Doe'},  # last_name
            {'doctor_email': 'doctor@example.com'},  # doctor_email
            {'unit': 'mg/dL'}  # unit
        ]
        MockUser.return_value = mock_user

        # Mock the SMTP server
        mock_smtp_instance = MagicMock()
        MockSMTP.return_value = mock_smtp_instance

        # Simulate the POST request to the /alert-doctor endpoint
        response = self.app.post(
            '/alert-doctor',
            json={'bloodSugarLevel': 150},  # Test data
        )

        # Verify the response
        self.assertEqual(response.status_code, 200)
        self.assertIn("Alert sent successfully!", response.get_json()["message"])

        # Check the email message was created correctly
        msg = mock_smtp_instance.send_message.call_args[0][0]
        self.assertIn(
            'Your patient, John Doe, has recorded an unsafe blood sugar level of 150 mg/dL.',
            msg.get_payload()
        )

        # Verify the correct subject, sender, and recipient
        self.assertEqual(msg['Subject'], 'Patient Alert from DiaLog')
        self.assertEqual(msg['From'], 'javacakesdialog@gmail.com')
        self.assertEqual(msg['To'], 'doctor@example.com')

        # Check that the email was sent
        mock_smtp_instance.send_message.assert_called_once_with(msg)
        mock_smtp_instance.quit.assert_called_once()

    @patch('main2.get_jwt_identity')  # Mocking get_jwt_identity
    @patch('main2.User')  # Mocking the User class
    @patch('smtplib.SMTP_SSL')  # Mocking smtplib.SMTP_SSL
    def test_send_alert_missing_email(self, MockSMTP, MockUser, MockGetJWT):
        # Mock the JWT identity to return a user ID
        MockGetJWT.return_value = 'test_user_id'

        # Mock the User instance with missing email
        mock_user = MagicMock()
        mock_user.search_data.side_effect = [
            {'first_name': 'John'},  # first_name
            {'last_name': 'Doe'},  # last_name
            {},  # Missing doctor_email
            {'unit': 'mg/dL'}  # unit
        ]
        MockUser.return_value = mock_user

        # Simulate the POST request to the /alert-doctor endpoint
        response = self.app.post(
            '/alert-doctor',
            json={'bloodSugarLevel': 150},  # Test data
        )

        # Verify the response when doctor_email is missing
        self.assertEqual(response.status_code, 400)
        self.assertIn("Doctor email is missing", response.get_json()["error"])

        # Verify that no email was sent
        MockSMTP.return_value.send_message.assert_not_called()

if __name__ == '__main__':
    unittest.main()
