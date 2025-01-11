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
            "email": "jd1@example.com",
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

    def test_register_missing_field(self):
        data = {
            "first_name": "John",
            "last_name": "Doe",
            "email": "jd1@example.com",
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

if __name__ == '__main__':
    unittest.main()
