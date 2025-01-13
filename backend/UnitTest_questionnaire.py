#this script contains tests for /questionnaire and /send-questionnaire endpoints

import unittest
from unittest.mock import patch, MagicMock
from main2 import app

class TestQuestionnaireEndpoints(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    #Reference - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com 
    @patch('main2.store_answers')
    @patch('main2.send_results_to_doctor')
    def test_submit_questionnaire_success(self, mock_send_results_to_doctor, mock_store_answers):
        #mock the store_answer and send_results_to_doctor functions 
        mock_store_answers.return_value = None
        mock_send_results_to_doctor.return_value = None

        #valid input 
        data = {
            "userid": "user123",
            "answers": [
                {"question_id": "1", "answer": "Yes"},
                {"question_id": "2", "answer": "No"}
            ]
        }
        #referece ends
        
        # Send a POST request to the /questionnaire endpoint
        response = self.app.post('/questionnaire', json=data)

        self.assertEqual(response.status_code, 201)
        self.assertIn("Questionnaire submitted successfully!", response.get_data(as_text=True))
        mock_store_answers.assert_called_once_with("user123", data['answers'])
        mock_send_results_to_doctor.assert_called_once_with("user123", data['answers'])

    def test_submit_questionnaire_invalid_json(self):
        response = self.app.post('/questionnaire', data="Invalid JSON")

        self.assertEqual(response.status_code, 400)
        self.assertIn("Invalid JSON format", response.get_data(as_text=True))

    def test_submit_questionnaire_missing_userid(self):
        data = {
            "answers": [
                {"question_id": "1", "answer": "Yes"}
            ]
        }

        response = self.app.post('/questionnaire', json=data)

        self.assertEqual(response.status_code, 400)
        self.assertIn("Missing 'userid' in request data", response.get_data(as_text=True))

    def test_submit_questionnaire_invalid_answers_field(self):
        # Define input data with invalid 'answers' field
        data = {
            "userid": "user123",
            "answers": "Not a list"
        }
        response = self.app.post('/questionnaire', json=data)

        self.assertEqual(response.status_code, 400)
        self.assertIn("Invalid or missing 'answers' field", response.get_data(as_text=True))

    @patch('main2.store_answers', side_effect=Exception("Database error"))
    def test_submit_questionnaire_store_answers_failure(self, mock_store_answers):
        data = {
            "userid": "user123",
            "answers": [
                {"question_id": "1", "answer": "Yes"}
            ]
        }

        response = self.app.post('/questionnaire', json=data)

        self.assertEqual(response.status_code, 500)
        self.assertIn("Failed to store questionnaire", response.get_data(as_text=True))
        mock_store_answers.assert_called_once()

if __name__ == '__main__':
    unittest.main()
