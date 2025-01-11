
import unittest
from unittest.mock import patch, MagicMock
from main2 import app, users_table, data_table
from flask_jwt_extended import create_access_token
from moto import mock_dynamodb2
import boto3

class TestApp(unittest.TestCase):
    @mock_dynamodb2
    def setUp(self):
        # Set up a mock DynamoDB instance
        self.mock_dynamodb = boto3.resource('dynamodb', region_name='eu-west-2')
        self.users_table = self.mock_dynamodb.create_table(
            TableName='DiaLog_Users',
            KeySchema=[
                {'AttributeName': 'PK', 'KeyType': 'HASH'},
                {'AttributeName': 'SK', 'KeyType': 'RANGE'}
            ],
            AttributeDefinitions=[
                {'AttributeName': 'PK', 'AttributeType': 'S'},
                {'AttributeName': 'SK', 'AttributeType': 'S'}
            ],
            ProvisionedThroughput={'ReadCapacityUnits': 1, 'WriteCapacityUnits': 1}
        )
        self.data_table = self.mock_dynamodb.create_table(
            TableName='DiaLog_Data',
            KeySchema=[
                {'AttributeName': 'userid#datatype', 'KeyType': 'HASH'},
                {'AttributeName': 'date', 'KeyType': 'RANGE'}
            ],
            AttributeDefinitions=[
                {'AttributeName': 'userid#datatype', 'AttributeType': 'S'},
                {'AttributeName': 'date', 'AttributeType': 'S'}
            ],
            ProvisionedThroughput={'ReadCapacityUnits': 1, 'WriteCapacityUnits': 1}
        )

        # Add a test client
        app.testing = True
        self.client = app.test_client()

    def tearDown(self):
        self.users_table.delete()
        self.data_table.delete()




    