import unittest
from unittest.mock import patch, MagicMock
from main2 import app

class TestQuestionnaireEndpoints(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    @patch('main2.store_answers')
    @patch('main2.send_results_to_doctor')
    def test_submit_questionnaire_success(self, mock_send_results_to_doctor, mock_store_answers):
        # Mock the store_answers and send_results_to_doctor functions
        mock_store_answers.return_value = None
        mock_send_results_to_doctor.return_value = None

        # Define valid input data
        data = {
            "userid": "user123",
            "answers": [
                {"question_id": "1", "answer": "Yes"},
                {"question_id": "2", "answer": "No"}
            ]
        }

        # Send a POST request to the /questionnaire endpoint
        response = self.app.post('/questionnaire', json=data)

        # Check the response
        self.assertEqual(response.status_code, 201)
        self.assertIn("Questionnaire submitted successfully!", response.get_data(as_text=True))
        mock_store_answers.assert_called_once_with("user123", data['answers'])
        mock_send_results_to_doctor.assert_called_once_with("user123", data['answers'])

    def test_submit_questionnaire_invalid_json(self):
        # Send a POST request with invalid JSON
        response = self.app.post('/questionnaire', data="Invalid JSON")

        # Check the response
        self.assertEqual(response.status_code, 400)
        self.assertIn("Invalid JSON format", response.get_data(as_text=True))

    def test_submit_questionnaire_missing_userid(self):
        # Define input data missing 'userid'
        data = {
            "answers": [
                {"question_id": "1", "answer": "Yes"}
            ]
        }

        # Send a POST request to the /questionnaire endpoint
        response = self.app.post('/questionnaire', json=data)

        # Check the response
        self.assertEqual(response.status_code, 400)
        self.assertIn("Missing 'userid' in request data", response.get_data(as_text=True))

    def test_submit_questionnaire_invalid_answers_field(self):
        # Define input data with invalid 'answers' field
        data = {
            "userid": "user123",
            "answers": "Not a list"
        }

        # Send a POST request to the /questionnaire endpoint
        response = self.app.post('/questionnaire', json=data)

        # Check the response
        self.assertEqual(response.status_code, 400)
        self.assertIn("Invalid or missing 'answers' field", response.get_data(as_text=True))

    @patch('main2.store_answers', side_effect=Exception("Database error"))
    def test_submit_questionnaire_store_answers_failure(self, mock_store_answers):
        # Define valid input data
        data = {
            "userid": "user123",
            "answers": [
                {"question_id": "1", "answer": "Yes"}
            ]
        }

        # Send a POST request to the /questionnaire endpoint
        response = self.app.post('/questionnaire', json=data)

        # Check the response
        self.assertEqual(response.status_code, 500)
        self.assertIn("Failed to store questionnaire", response.get_data(as_text=True))
        mock_store_answers.assert_called_once()

if __name__ == '__main__':
    unittest.main()