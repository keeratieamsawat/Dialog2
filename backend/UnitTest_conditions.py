import unittest
from unittest.mock import patch, MagicMock
from main2 import app  # Replace with the actual import for your app
from flask import json

class TestConditionsAPI(unittest.TestCase):

    @patch('main2.data_table.put_item')  # Mock DynamoDB put_item
    def test_add_conditions_success(self, mock_put_item):
        mock_put_item.return_value = None  # Simulate successful insertion

        test_data = {
            "user_id": "2",
            "conditions": [
                {"datatype": "blood_sugar", "value": 150, "date": "2025-01-10T12:00:00"},
                {"datatype": "blood_pressure", "value": 120/80, "date": "2025-01-10T12:00:00"}
            ]
        }

        with app.test_client() as client:
            response = client.post('/conditions', json=test_data)
        print(response.data)

        self.assertEqual(response.status_code, 201)
        self.assertIn('User conditions saved successfully!', response.json.get('message'))

    @patch('main2.data_table.put_item')  # Mock DynamoDB put_item
    def test_add_conditions_missing_user_id(self, mock_put_item):
        test_data = {
            "conditions": [
                {"datatype": "blood_sugar", "value": 150, "date": "2025-01-10T12:00:00"}
            ]
        }

        with app.test_client() as client:
            response = client.post('/conditions', json=test_data)

        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json.get('error'), "User ID is required")

    @patch('main2.data_table.scan')  # Mock DynamoDB scan
    def test_get_conditions_success(self, mock_scan):
        # Mock a response from DynamoDB
        mock_scan.return_value = {
            'Items': [
                {'userid#datatype': '2#blood_sugar', 'date': '2025-01-10T12:00:00', 'value': 150},
                {'userid#datatype': '2#blood_pressure', 'date': '2025-01-10T12:00:00', 'value': 120/80}
            ]
        }

        with app.test_client() as client:
            response = client.get('/conditions/2')
        print(response.data)

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['user_id'], '2')
        self.assertEqual(len(response.json['conditions']), 2)
        self.assertEqual(response.json['conditions'][0]['datatype'], 'blood_sugar')
        self.assertEqual(response.json['conditions'][1]['datatype'], 'blood_pressure')

    @patch('main2.data_table.scan')  # Mock DynamoDB scan
    def test_get_conditions_no_data(self, mock_scan):
        mock_scan.return_value = {'Items': []}

        with app.test_client() as client:
            response = client.get('/conditions/2')

        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.json.get('error'), "No data found for the specified user ID")

    @patch('main2.data_table.get_item')  # Mock DynamoDB get_item
    @patch('main2.data_table.update_item')  # Mock DynamoDB update_item
    def test_update_conditions_success(self, mock_update_item, mock_get_item):
        # Mock the 'get_item' to return a condition matching the format of the composite key
        mock_get_item.return_value = {
            'Item': {
                'userid#datatype': '2#blood_sugar',
                'value': 150,
                'date': '2025-01-10T12:00:00'
            }
        }

        # Mock the 'update_item' to return updated attributes
        mock_update_item.return_value = {
            'Attributes': {
                'value': 160,
                'date': '2025-01-11T12:00:00'
            }
        }

        # Sample data to test the update
        test_data = {"value": 160, "date": "2025-01-11T12:00:00"}

        # Sending the PUT request to update the condition
        with app.test_client() as client:
            response = client.put('/conditions/2/blood_sugar', json=test_data)
        
        print(response.data)  # This will help us debug and understand the response

        # Asserting the response
        self.assertEqual(response.status_code, 200)
        self.assertIn("User condition data updated successfully!", response.json.get('message'))
        self.assertEqual(response.json['updated_data']['value'], 160)


    @patch('main2.data_table.get_item')  # Mock DynamoDB get_item
    @patch('main2.data_table.update_item')  # Mock DynamoDB update_item
    def test_update_conditions_not_found(self, mock_update_item, mock_get_item):
        mock_get_item.return_value = {}  # Simulate no item found
        mock_update_item.return_value = {}

        test_data = {"value": 160, "date": "2025-01-11T12:00:00"}

        with app.test_client() as client:
            response = client.put('/conditions/2/blood_sugar', json=test_data)
        print(response.data)

        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.json.get('error'), "Condition not found for the given user_id and datatype")

    @patch('main2.data_table.update_item')  # Mock DynamoDB update_item
    def test_update_conditions_missing_data(self, mock_update_item):
        test_data = {}  # Missing 'value' and 'date'

        with app.test_client() as client:
            response = client.put('/conditions/2/blood_sugar', json=test_data)

        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json.get('error'), "Condition data (value and date) is required")

if __name__ == '__main__':
    unittest.main()
