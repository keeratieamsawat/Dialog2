import unittest
from unittest.mock import patch, MagicMock
from main2 import app  # Import your app
from flask import jsonify
from flask_jwt_extended import create_access_token

class TestGenGraph(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()
        self.client.testing = True
        

    # Helper function to simulate headers with JWT token
    def get_headers_with_jwt(self):
        with app.app_context():  # Ensure the application context is set
            jwt_token = create_access_token(identity='f87cd4cb-8959-4daf-a040-88add0d53727')  # Simulate a user ID
        return {'Authorization': f'Bearer {jwt_token}',
                'Content-Type': 'application/json' }

    @patch('main2.UserClient')  # Mocking the UserClient class
    def test_gen_graph_success(self, mock_user_client):
        # Mock UserClient and its query_data method
        mock_user = MagicMock()
        mock_user.query_data.return_value = {"graph_data": [1, 2, 3, 4, 5]}
        mock_user_client.return_value = mock_user

        # Sample input data
        input_data = {
            "start": "2025-01-01",
            "end": "2025-01-10"
        }

        # Send GET request to /graphs with query parameters and JWT token in headers
        response = self.client.get('/graphs?start_date=2025-01-01&end_date=2025-01-10', headers=self.get_headers_with_jwt())

        # Assertions
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, 'application/json')
        self.assertIn("data", response.json)
        self.assertEqual(response.json['data'], {"graph_data": [1, 2, 3, 4, 5]})

        # Ensure that the query_data method was called with the correct arguments
        mock_user.query_data.assert_called_once_with('2025-01-01', '2025-01-10')
        


    @patch('main2.UserClient')  # Mocking the UserClient class
    def test_gen_graph_missing_parameters(self, mock_user_client):
        # Send GET request to /graphs without required query parameters and with JWT token
        response = self.client.get('/graphs', headers=self.get_headers_with_jwt())

        # Assertions
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.content_type, 'application/json')
        self.assertIn("Missing required parameters", response.json['error'])

    @patch('main2.UserClient')  # Mocking the UserClient class
    def test_gen_graph_data_query_failure(self, mock_user_client):
        # Mock UserClient and its query_data method to return None (indicating failure)
        mock_user = MagicMock()
        mock_user.query_data.return_value = None
        mock_user_client.return_value = mock_user

        # Sample input data
        input_data = {
            "start": "2025-01-01",
            "end": "2025-01-10"
        }

        # Send GET request to /graphs with query parameters and JWT token in headers
        response = self.client.get('/graphs?start_date=2025-01-01&end_date=2025-01-10', headers=self.get_headers_with_jwt())

        # Assertions
        self.assertEqual(response.status_code, 500)
        self.assertEqual(response.content_type, 'application/json')
        self.assertIn("Failed to query data", response.json['error'])

if __name__ == '__main__':
    unittest.main()

