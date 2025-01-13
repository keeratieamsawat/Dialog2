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
        mock_table.get_item.return_value = {'Item': {'email': 'johndoe@example.com', 'password': 'password123'}}
        
        data = {
            "email": "johndoe@example.com",
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
        with patch('main2.UserClient') as MockUserClient:
            mock_client = MagicMock()
            MockUserClient.return_value = mock_client
            
            # Mock the return values for the search_data method
            mock_client.search_data.side_effect = lambda field_name: {
                'userid': 'f87cd4cb-8959-4daf-a040-88add0d53727',
                'email': 'johndoe@example.com',
                'name': 'John Doe'
            }.get(field_name, None)  # Default to None if the field is not in the dictionary

            # Make the request to fetch the user data
            response = self.client.get('/users/f87cd4cb-8959-4daf-a040-88add0d53727')

            # Print the response data for debugging
            print(response.data)

            # Assert the response
            self.assertEqual(response.status_code, 200)
            self.assertEqual(response.json['email'], 'johndoe@example.com')
            self.assertEqual(response.json['name'], 'John Doe')
            self.assertEqual(response.json['userid'], 'f87cd4cb-8959-4daf-a040-88add0d53727')

    
if __name__ == '__main__':
    unittest.main()
