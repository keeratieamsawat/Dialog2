
import unittest
from unittest.mock import patch, MagicMock
from main2 import app  
import json

class TestDiaLogApp(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        """Set up the test client."""
        cls.client = app.test_client()
    
    @patch('boto3.resource')
    def test_login_success(self, mock_dynamodb):
        """Test login with correct credentials."""
        mock_table = MagicMock()
        mock_dynamodb.return_value.Table.return_value = mock_table
        # Mock response from DynamoDB
        mock_table.get_item.return_value = {'Item': {'email': 'Ginny@ic.ac.uk', 'password': 'password123'}}
        
        data = {
            "email": "Ginny@ic.ac.uk",
            "password": "password123"
        }
        response = self.client.post('/login', json=data)
        print(response.data)  # Debugging purposes only
        self.assertEqual(response.status_code, 200)
        self.assertIn("Login successful", response.json['message'])

    def test_login_missing_credentials(self):
        """Test login with missing password."""
        data = {"email": "johndoe@example.com"}
        response = self.client.post('/login', json=data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("Email and password required", response.json['error'])

    @patch('boto3.resource')
    def test_get_user(self, mock_dynamodb):
        """Test fetching a single user."""
        mock_table = MagicMock()
        mock_dynamodb.return_value.Table.return_value = mock_table
        # Mock response for fetching a single user
        mock_table.get_item.return_value = {
    'Item': {
        'userid': 'f87cd4cb-8959-4daf-a040-88add0d53727',
        'email': 'johndoe@example.com',
        'name': 'John Doe'
    }}
        response = self.client.get('/users/f87cd4cb-8959-4daf-a040-88add0d53727')
        print(response.data)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['email'], 'johndoe@example.com')

    @patch('boto3.resource')
    def test_export_user(self, mock_dynamodb):
        """Test exporting user data."""
        mock_table = MagicMock()
        mock_dynamodb.return_value.Table.return_value = mock_table
        # Correctly mock the expected response
        mock_table.get_item.return_value = {
            'Item': {
                'userid': 'f87cd4cb-8959-4daf-a040-88add0d53727',
                'email': 'johndoe@example.com',
                'name': 'John Doe'
            }
        }
        
        response = self.client.get('/users/f87cd4cb-8959-4daf-a040-88add0d53727/export')
        print(response.data)
        self.assertEqual(response.status_code, 200)
        self.assertIn("userid: f87cd4cb-8959-4daf-a040-88add0d53727", response.data.decode())


    @patch('boto3.resource')
    def test_export_user(self, mock_dynamodb):
        """Test exporting user data."""
        mock_table = MagicMock()
        mock_dynamodb.return_value.Table.return_value = mock_table
        # Mock response for exporting user data
        mock_table.get_item.return_value = {'Item': {'userid': 'f87cd4cb-8959-4daf-a040-88add0d53727', 'email': 'johndoe@example.com'}}
        
        response = self.client.get('/users/f87cd4cb-8959-4daf-a040-88add0d53727/export')
        print(response.data)
        self.assertEqual(response.status_code, 200)
        self.assertIn("User data exported successfully", response.json['message'])

if __name__ == '__main__':
    unittest.main()
