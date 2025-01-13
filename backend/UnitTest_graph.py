#The test contains unit test for /gen_graph endpoint
import unittest
from unittest.mock import patch, MagicMock
from flask import Flask, jsonify
from main2 import app  # Replace with the actual module name containing gen_graph

class TestGenGraph(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    @patch('main2.UserClient')  # Replace with the actual import path of UserClient
    def test_gen_graph_missing_parameters(self, MockUserClient):
        # Test missing parameters
        response = self.app.post('/graphs', json={"userid": "123"})
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json, {"error": "Missing required parameters"})

    
    @patch('main2.UserClient')  # Replace with the actual import path of UserClient
    def test_gen_graph_success(self, MockUserClient):
        # Mock UserClient behavior
        mock_user = MockUserClient.return_value
        mock_user.query_by_date_range.return_value = [
            {"date": "2025-01-01", "value": 100},
            {"date": "2025-01-02", "value": 110}
        ]

        response = self.app.post('/graphs', json={
            "userid": "123",
            "fromDate": "2025-01-01",
            "toDate": "2025-01-15"
        })
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json, {
            "data": [
                {"date": "2025-01-01", "value": 100},
                {"date": "2025-01-02", "value": 110}
            ]
        })

    
if __name__ == '__main__':
    unittest.main()
