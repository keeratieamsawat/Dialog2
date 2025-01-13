#the script contains tests for /login and /users/<user_id> endpoints

import unittest
from unittest.mock import patch, MagicMock
from main2 import app  
import json

class TestDiaLogApp(unittest.TestCase):

    @classmethod
    def setUpClass(cls): 
        cls.client = app.test_client() 
        
    @patch('boto3.resource')
    #Test login with correct credentials
    def test_login_success(self, mock_dynamodb):
        mock_table = MagicMock() #simulate a DynamoDB table
        mock_dynamodb.return_value.Table.return_value = mock_table
        
        mock_table.get_item.return_value = {'Item': {'email': 'johndoe@example.com', 'password': 'password123'}} # Mock response from DynamoDB
        #credentials
        data = {
            "email": "johndoe@example.com",
            "password": "password123"
        }
        response = self.client.post('/login', json=data)
        print(response.data)  # Debugging
        self.assertEqual(response.status_code, 200)
        self.assertIn("Login successful", response.json['message'])
    
    #Test login with missing password
    def test_login_missing_credentials(self):
        data = {"email": "johndoe@example.com"}
        response = self.client.post('/login', json=data)
        self.assertEqual(response.status_code, 400)
        self.assertIn("Email and password required", response.json['error'])

    #Test fetching a single user
    @patch('boto3.resource')
    def test_get_user(self, mock_dynamodb):
        mock_table = MagicMock()
        mock_dynamodb.return_value.Table.return_value = mock_table
        # Reference - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
        with patch('main2.UserClient') as MockUserClient:
            mock_client = MagicMock()
            MockUserClient.return_value = mock_client
            
            # Mock the return values for the search_data method
            mock_client.search_data.side_effect = lambda field_name: {
                'userid': 'f87cd4cb-8959-4daf-a040-88add0d53727',
                'email': 'johndoe@example.com',
                'name': 'John Doe'
            }.get(field_name, None)  # Default to None if the field is not in the dictionary

            response = self.client.get('/users/f87cd4cb-8959-4daf-a040-88add0d53727')
            #reference ends

            print(response.data) #debug

            self.assertEqual(response.status_code, 200)
            self.assertEqual(response.json['email'], 'johndoe@example.com')
            self.assertEqual(response.json['name'], 'John Doe')
            self.assertEqual(response.json['userid'], 'f87cd4cb-8959-4daf-a040-88add0d53727')

    
if __name__ == '__main__':
    unittest.main()
