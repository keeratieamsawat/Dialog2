import unittest
from unittest.mock import patch, MagicMock
from main2 import app  
from flask import jsonify


class TestAddDiabetesInfo(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()
        self.client.testing = True

    @patch('main2.users_table.get_item')  # Mocking DynamoDB get_item
    @patch('main2.users_table.update_item')  # Mocking DynamoDB update_item
    def test_add_diabetes_info_success(self, mock_update, mock_get):
        # Test input data
        input_data = {
            "userid": "f87cd4cb-8959-4daf-a040-88add0d53727",
            "diabetes_type": "Type 1",
            "diagnose_date": "2022-01-01",
            "insulin_type": "Rapid-acting",
            "admin_route": "Subcutaneous",
            "condition": "Stable",
            "medication": "Insulin",
            "lower_bound": 80,
            "upper_bound": 180, 
            "doctor_name": "Martin",
            "doctor_email": "123@ic.ac.uk"
        }

        # Mock DynamoDB get_item response
        mock_get.return_value = {
            'Item': {
                'PK': 'f87cd4cb-8959-4daf-a040-88add0d53727',
                'SK': 'USER#f87cd4cb-8959-4daf-a040-88add0d53727',
                'first_name': 'John',
                'last_name': 'Doe',
                'email': 'johndoe@example.com'
            }
        }

        # Mock DynamoDB update_item behavior (no need to return anything)
        mock_update.return_value = {}

        # Create a test client
        client = app.test_client()

        # Send a POST request to the /add_diabetes_info endpoint
        response = client.post('/add_diabetes_info', json=input_data)

        # Check the response
        self.assertEqual(response.status_code, 201)
        self.assertIn("Diabetes information added successfully!", response.json['message'])

        # Ensure that the get_item and update_item were called with the correct arguments
        mock_get.assert_called_once_with(Key={'PK': 'f87cd4cb-8959-4daf-a040-88add0d53727', 'SK': 'USER#f87cd4cb-8959-4daf-a040-88add0d53727'})
        mock_update.assert_called_once_with(
    Key={'PK': 'f87cd4cb-8959-4daf-a040-88add0d53727', 'SK': 'USER#f87cd4cb-8959-4daf-a040-88add0d53727'},
    UpdateExpression="SET diabetes_info = :diabetes_info",
    ExpressionAttributeValues={":diabetes_info": input_data}
        )

    @patch('main2.users_table.get_item')  # Mocking DynamoDB get_item
    @patch('main2.users_table.update_item')  # Mocking DynamoDB update_item
    def test_update_diabetes_info_success(self, mock_update, mock_get):
        # Test input data to update diabetes information
        updated_data = {
            "userid": "f87cd4cb-8959-4daf-a040-88add0d53727",
            "diabetes_type": "Type 2",
            "diagnose_date": "2023-05-15",
            "insulin_type": "Long-acting",
            "admin_route": "Subcutaneous",
            "condition": "Controlled",
            "medication": "Metformin",
            "lower_bound": 4.0,
            "upper_bound": 7.0,
            "doctor_name": "Martin",
            "doctor_email": "123@ic.ac.uk"
        }

        # Mock DynamoDB get_item response (simulate the user exists)
        mock_get.return_value = {
            'Item': {
                'PK': 'f87cd4cb-8959-4daf-a040-88add0d53727',
                'SK': 'USER#f87cd4cb-8959-4daf-a040-88add0d53727',
                'first_name': 'John',
                'last_name': 'Doe',
                'email': 'johndoe@example.com'
            }
        }

        # Mock DynamoDB update_item behavior (no need to return anything)
        mock_update.return_value = {}

        # Create a test client
        client = app.test_client()

        # Send a PUT request to the /update_diabetes_info endpoint
        response = client.put('/update_diabetes_info', json=updated_data)

        # Check the response
        self.assertEqual(response.status_code, 200)
        self.assertIn("Diabetes information updated successfully!", response.json['message'])

        # Ensure that the get_item and update_item were called with the correct arguments
        mock_get.assert_called_once_with(Key={'PK': 'f87cd4cb-8959-4daf-a040-88add0d53727', 'SK': 'USER#f87cd4cb-8959-4daf-a040-88add0d53727'})
        mock_update.assert_called_once_with(
            Key={'PK': 'f87cd4cb-8959-4daf-a040-88add0d53727', 'SK': 'USER#f87cd4cb-8959-4daf-a040-88add0d53727'},
            UpdateExpression="SET diabetes_info = :diabetes_info",
            ExpressionAttributeValues={":diabetes_info": updated_data}
        )


if __name__ == '__main__':
    unittest.main()