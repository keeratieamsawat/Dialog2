// MARK: this page comes after the DetailsPage, taking in user's doctor information, and an "All done" button that sends all user input data to backend

import SwiftUI

struct DoctorInfoView: View {
    
    @StateObject var diabetesData:DiabetesDetailsData
    
    var body: some View {
        VStack(alignment:.leading,spacing: 30) {
            Text("We would also need your doctor's details so we can contact them in case of emergency...")
                .font(.headline)
                .bold()
            Text("Your Doctor's Name:")
                .font(.headline)
            
            // TextField to enter doctor's name
            TextField("Enter your doctor's name", text: $diabetesData.doctorName)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
                .offset(y:-20)
            
            Text("Your Doctor's Email:")
                .font(.headline)
            
            // TextField to enter doctor email
            TextField("Enter your doctor's email", text: $diabetesData.doctorEmail)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
                .offset(y:-20)
            
            // after user registers all their diabetes details data, click "All done" button will navigate them to the home page of the app, and they can start logging entries
            
            // on clicking the button, all the data propagated from the previous pages will be sent to backend database as well
            
            Button(action: {
                if !diabetesData.allDone {
                    
                    // boolean variable becomes "true" when button clicked
                    diabetesData.allDone = true
                    
                    // calling submitDiabetes function written below to submit data to database
                    submitDiabetes()
                    // (similar logic used in ConsentsView page)
                }
            }) {
                Text("All done!")
                    .bold()
                    .frame(height:40)
                    .frame(maxWidth:.infinity)
                    .foregroundColor(.white)
                    .background(Color("Primary_Color"))
                    .cornerRadius(10)
                    .padding(.horizontal,40)
            }
            // navigation to home page
            .navigationDestination(isPresented: $diabetesData.allDone) {
                HomePageView(diabetesData:diabetesData)
                
            }
        }
        .padding(40)
    }
    
// MARK: this function sends all diabetes details data to backend database
    
    func sendDiabetesData(diabetesData:DiabetesDetailsData, completion: @escaping (Result<String, Error>) -> Void) {
        
        // prepare data for sending, matching variable names in the backend code
        
        let diabetesDetails: [String: Any] = [
            "userid":diabetesData.userID,
            "diabetes_type": diabetesData.diabetesType,
            "diagnose_date": DateUtils.formattedDate(from: diabetesData.diagnoseDate, format: "yyyy-MM-dd"),
            "insulin_type": diabetesData.insulinType,
            "admin_route": diabetesData.adminRoute,
            "condition": diabetesData.condition,
            "medication": diabetesData.medication,
            "lower_bound": diabetesData.lowerBound,
            "upper_bound": diabetesData.upperBound,
            "doctor_email": diabetesData.doctorEmail,
            "doctor_name": diabetesData.doctorName
        ]

// Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
        // similar code was also being used in other pages - Signin and ConsentsView.
        
        // convert to JSON
        // the URL directs to the database, with "add_diabetes_info" as the endpoint on backend Python code
        guard let url = URL(string: "http://127.0.0.1:5000/add_diabetes_info") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // http method is POST
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: diabetesDetails, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        // perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // printing error message
            if let error = error {
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                }
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    // assuming the backend returns a success message in the body
                    let responseString = String(data: data, encoding: .utf8) ?? "Unknown response"
                    DispatchQueue.main.async {
                        print("Response: \(responseString)")
                    }
                    completion(.success(responseString))
                } catch {
                    DispatchQueue.main.async {
                        print("Error during data parsing: \(error.localizedDescription)")
                    }
                    completion(.failure(error))
                }
            }
            DispatchQueue.main.async {
                // print the data provided by the frontend, sending to the backend
                print("Data being sent to the backend: \(diabetesDetails)")
            }
        }
        
        task.resume()
    }
    
/* end of reference 1 */
    
// MARK: this function submits the diabetes details data to backend, under the condition that "All done" button is clicked
   
// Reference 2 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
    // similar code being used in ConsentsView and Signin pages as well
    
    func submitDiabetes() {
        // Send the diabetes details data to the backend
        sendDiabetesData(diabetesData: diabetesData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseMessage):
                    print("Submission of diabetes details success: \(responseMessage)")
                    // print out message that indicate submission success
                case .failure(let error):
                    print("Submission of diabetes details failed: \(error.localizedDescription)")
                    // print error messages when failure
                }
            }
        }
    }
}
/* end of reference 2 */

// preview provider to preview the UI with diabetesData being passed
    struct DoctorInfo_Previews: PreviewProvider {
        static var previews: some View {
            DoctorInfoView(diabetesData: DiabetesDetailsData())
        }
    }

