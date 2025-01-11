import unittest
from unittest.mock import patch, MagicMock
from main2 import app  # Assuming the Flask app is named 'app.py'
import json

class TestDiaLogApp(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        """Set up the test client."""
        cls.client = app.test_client()

    #register test 
    def test_register_success(self):
        data = {
            "first_name": "John",
            "last_name": "Doe",
            "email": "johndoe@example.com",
            "password": "password123",
            "confirm_password": "password123",
            "gender": "Male",
            "birthdate": "1990-01-01",
            "country_of_residence": "USA",
            "emergency_contact": "123456789",
            "weight": 75,
            "height": 180,
            "consent": True
        }
        response = self.client.post('/register', json=data)
        self.assertEqual(response.status_code, 201)
        self.assertIn("User registered successfully", response.json['message'])

    def test_register_missing_field(self):
        data = {
            "first_name": "John",
            "last_name": "Doe",
            "email": "johndoe@example.com",
            "password": "password123",
            "confirm_password": "password123",
            "gender": "Male",
            "birthdate": "1990-01-01",
            "weight": 75,
            "height": 180,
            "consent": True
        }
        response = self.client.post('/register', json=data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("Missing required field", response.json['error'])

    #test initial diabetes info
    @patch('boto3.resource')
    def test_add_diabetes_info(self, mock_dynamodb):
        mock_table = MagicMock()
        mock_dynamodb.return_value.Table.return_value = mock_table
        mock_table.get_item.return_value = {'Item': {'userid': '1234'}}
        
        data = {
            "userid": "1234",
            "diabetes_type": "Type 1",
            "diagnose_date": "2020-01-01",
            "insulin_type": "Rapid",
            "admin_route": "Subcutaneous",
            "condition": "Stable",
            "medication": "Insulin",
            "bs_unit": "mg/dL",
            "carb_unit": "g",
            "lower_bound": 70,
            "upper_bound": 180
        }
        response = self.client.post('/add_diabetes_info', json=data)
        self.assertEqual(response.status_code, 201)
        self.assertIn("Diabetes information added successfully", response.json['message'])

    @patch('boto3.resource')
    def test_login_success(self, mock_dynamodb):
        mock_table = MagicMock()
        mock_dynamodb.return_value.Table.return_value = mock_table
        mock_table.get_item.return_value = {'Item': {'email': 'johndoe@example.com', 'password': 'password123'}}
        
        data = {
            "email": "johndoe@example.com",
            "password": "password123"
        }
        response = self.client.post('/login', json=data)
        self.assertEqual(response.status_code, 200)
        self.assertIn("Login successful", response.json['message'])

    def test_login_missing_credentials(self):
        data = {"email": "johndoe@example.com"}
        response = self.client.post('/login', json=data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("Email and password required", response.json['error'])

    def test_get_users(self):
        # Assuming the mock data is already in DynamoDB
        response = self.client.get('/users')
        self.assertEqual(response.status_code, 200)

    def test_get_user(self):
        response = self.client.get('/users/1234')
        self.assertEqual(response.status_code, 200)
        self.assertIn('Item', response.json)

    def test_export_user(self):
        response = self.client.get('/users/1234/export')
        self.assertEqual(response.status_code, 200)
        self.assertIn("User data exported successfully", response.json['message'])

    @patch('boto3.resource')
    def test_send_alert(self, mock_dynamodb):
        mock_table = MagicMock()
        mock_dynamodb.return_value.Table.return_value = mock_table
        mock_table.get_item.return_value = {'Item': {'doctorEmail': 'doctor@example.com', 'firstName': 'John', 'lastName': 'Doe', 'unit': 'mg/dL'}}
        
        response = self.client.post('/alert-doctor', json={"bloodSugarLevel": 200})
        self.assertEqual(response.status_code, 200)

    def test_submit_questionnaire(self):
        data = {
            "answers": [{"question_id": 1, "answer": "Yes"}]
        }
        response = self.client.post('/questionnaire', json=data)
        self.assertEqual(response.status_code, 201)
        self.assertIn("Questionnaire submitted successfully", response.json['message'])

    @patch('boto3.resource')
    def test_gen_graph(self, mock_dynamodb):
        mock_table = MagicMock()
        mock_dynamodb.return_value.Table.return_value = mock_table
        mock_table.query.return_value = {'Items': [{'date': '2025-01-10', 'value': '120'}]}
        
        response = self.client.get('/graphs?start_date=2025-01-01&end_date=2025-01-10')
        self.assertEqual(response.status_code, 200)
        self.assertIn("data", response.json)

    def test_add_conditions(self):
        data = {
            "patient_id": "1234",
            "condition": "Stable"
        }
        response = self.client.post('/conditions', json=data)
        self.assertEqual(response.status_code, 201)
        self.assertIn("Patient condition data saved successfully", response.json['message'])

    def test_get_conditions(self):
        response = self.client.get('/conditions/1234')
        self.assertEqual(response.status_code, 200)

    def test_get_all_conditions(self):
        response = self.client.get('/conditions')
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
