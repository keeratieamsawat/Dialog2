#The script contains unit tests for the /add_diabetes_info, /update_diabetes_info, and /get_diabetes_info/<string:userid> endpoints

import unittest
from unittest.mock import patch, MagicMock
from main2 import app  
from flask import jsonify
from decimal import Decimal


class TestDiabetesInfo(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()
        self.client.testing = True
        
#Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com 
    @patch('main2.users_table.get_item')  
    @patch('main2.users_table.update_item')  
    def test_add_diabetes_info_success(self, mock_update, mock_get):
        input_data = {
            "userid": "435b1d6c-65ae-4069-9bfc-f0a2f31c01b1",
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

        mock_get.return_value = {
            'Item': {
                'PK': '435b1d6c-65ae-4069-9bfc-f0a2f31c01b1',
                'first_name': 'John',
                'last_name': 'Doe',
                'email': 'jd2@example.com',
                'birthdate': '1990-05-15',
                'country_of_residence': 'UK',
                'weight': 75,
                'height': 180,
                'consent': True
            }
        }

        mock_update.return_value = {}

        client = app.test_client()

        response = client.post('/add_diabetes_info', json=input_data)

        self.assertEqual(response.status_code, 201)
        self.assertIn("Diabetes information added successfully!", response.json['message'])

        mock_get.assert_called_once_with(Key={'userid': '435b1d6c-65ae-4069-9bfc-f0a2f31c01b1'})
        mock_update.assert_called_once_with(
            Key={'userid': '435b1d6c-65ae-4069-9bfc-f0a2f31c01b1'},
            UpdateExpression='SET diabetes_type = :diabetes_type, diagnose_date = :diagnose_date, insulin_type = :insulin_type, admin_route = :admin_route, #condition = :condition, medication = :medication, lower_bound = :lower_bound, upper_bound = :upper_bound, doctor_name = :doctor_name, doctor_email = :doctor_email',
            ExpressionAttributeValues={ ":diabetes_type": "Type 1",
                ":diagnose_date": "2022-01-01",
                ":insulin_type": "Rapid-acting",
                ":admin_route": "Subcutaneous",
                ":condition": "Stable",
                ":medication": "Insulin",
                ":lower_bound": Decimal(80),
                ":upper_bound": Decimal(180),
                ":doctor_name": "Martin",
                ":doctor_email": "123@ic.ac.uk"},
                ExpressionAttributeNames={'#condition': 'condition'}
        )
        print(mock_update.call_args)
        updated_user = mock_update.call_args[1]['ExpressionAttributeValues']
        self.assertEqual(updated_user[':diabetes_type'], 'Type 1')
        self.assertEqual(updated_user[':doctor_name'], 'Martin')
#reference ends 

    @patch('main2.users_table.get_item')  
    @patch('main2.users_table.update_item') 
    def test_update_diabetes_info_success(self, mock_update, mock_get):
        updated_data = {
            "userid": "435b1d6c-65ae-4069-9bfc-f0a2f31c01b1",
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

        mock_get.return_value = {
            'Item': {
                'PK': '435b1d6c-65ae-4069-9bfc-f0a2f31c01b1',
                'first_name': 'John',
                'last_name': 'Doe',
                'email': 'jd2@example.com',
                'birthdate': '1990-05-15',
                'country_of_residence': 'UK',
                'weight': 75,
                'height': 180,
                'consent': True
            }
        }

        mock_update.return_value = {}

        client = app.test_client()

        response = client.put('/update_diabetes_info', json=updated_data)

        self.assertEqual(response.status_code, 200)
        self.assertIn("Diabetes information updated successfully!", response.json['message'])

        mock_get.assert_called_once_with(Key={'userid': '435b1d6c-65ae-4069-9bfc-f0a2f31c01b1'})
        mock_update.assert_called_once_with(
            Key={'userid': '435b1d6c-65ae-4069-9bfc-f0a2f31c01b1'},
            UpdateExpression='SET diabetes_type = :diabetes_type, diagnose_date = :diagnose_date, insulin_type = :insulin_type, admin_route = :admin_route, condition = :condition, medication = :medication, lower_bound = :lower_bound, upper_bound = :upper_bound, doctor_name = :doctor_name, doctor_email = :doctor_email',
            ExpressionAttributeValues={":diabetes_type": "Type 2",
                ":diagnose_date": "2023-05-15",
                ":insulin_type": "Long-acting",
                ":admin_route": "Subcutaneous",
                ":condition": "Controlled",
                ":medication": "Metformin",
                ":lower_bound": 4.0,
                ":upper_bound": 7.0,
                ":doctor_name": "Martin",
                ":doctor_email": "123@ic.ac.uk"}
        )

        updated_user = mock_update.call_args[1]['ExpressionAttributeValues']
        self.assertNotIn('first_name', updated_user)
        self.assertNotIn('birthdate', updated_user)
        self.assertNotIn('email', updated_user)

    @patch('main2.users_table.get_item')  
    def test_get_diabetes_info_success(self, mock_get):
        userid = "435b1d6c-65ae-4069-9bfc-f0a2f31c01b1"

        mock_get.return_value = {
            'Item': {
                'PK': userid,
                'diabetes_type': 'Type 1',
                'diagnose_date': '2022-01-01',
                'insulin_type': 'Rapid-acting',
                'admin_route': 'Subcutaneous',
                'condition': 'Stable',
                'medication': 'Insulin',
                'lower_bound': 80,
                'upper_bound': 180, 
                'doctor_name': 'Martin',
                'doctor_email': '123@ic.ac.uk'
            }
        }

        client = app.test_client()

        response = client.get(f'/get_diabetes_info/{userid}')

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['userid'], userid)
        self.assertIn('diabetes_info', response.json)
        self.assertEqual(response.json['diabetes_info']['diabetes_type'], 'Type 1')

        mock_get.assert_called_once_with(Key={'userid': userid})

    @patch('main2.users_table.get_item')  
    def test_get_diabetes_info_user_not_found(self, mock_get):
        userid = "nonexistent_user"
        mock_get.return_value = {}
        client = app.test_client()
        response = client.get(f'/get_diabetes_info/{userid}')
        self.assertEqual(response.status_code, 404)
        self.assertIn("User not found", response.json['error'])
        mock_get.assert_called_once_with(Key={'userid': userid})

if __name__ == '__main__':
    unittest.main()
