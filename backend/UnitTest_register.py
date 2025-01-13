#this script contains test for /register endpoint

import unittest
from unittest.mock import patch, MagicMock
from main2 import app  
import json

class TestDiaLogApp(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.client = app.test_client() #set up test client
     
    @patch('main2.users_table.scan')  
    def test_register_success(self, mock_scan):
        # Mock the response to simulate no existing user
        mock_scan.return_value = {
            'Items': []
        }
        #input user data 
        data = {
            "first_name": "John",
            "last_name": "Doe",
            "email": "jd2@example.com",
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
        print(response.data)
        self.assertEqual(response.status_code, 201)
        self.assertIn("User registered successfully", response.json['message'])

    @patch('main2.users_table.scan')  
    def test_register_missing_field(self, mock_scan):
        mock_scan.return_value = {
            'Items': []
        }
        #data missing emergency contact
        data = {
            "first_name": "John",
            "last_name": "Doe",
            "email": "jd88@example.com",
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
 
    @patch('main2.users_table.scan') 
    def test_register_email_already_exists(self, mock_scan):
        # Mock the response to simulate an existing user with the same email

        mock_scan.return_value = {
            'Items': [{'email': 'jd2@example.com'}]  # Simulate existing user
        }
 
        data = {
            "first_name": "John",
            "last_name": "Doe",
            "email": "jd2@example.com",
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
        self.assertEqual(response.status_code, 400)
        self.assertIn("Email already in use", response.json['error'])
 
if __name__ == '__main__':

    unittest.main()

 
