import SwiftUI

struct DoctorInfoView: View {
    
    @ObservedObject var diabetesData:DiabetesDetailsData
    
    var body: some View {
        VStack(alignment:.leading,spacing: 30) {
            Text("We would also need your doctor's details so we can contact them in case of emergency...")
                .font(.headline)
                .bold()
            Text("Your Doctor's Name:")
                .font(.headline)
            TextField("Enter your doctor's name", text: $diabetesData.doctorName)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
                .offset(y:-20)
            
            Text("Your Doctor's Email:")
                .font(.headline)
            TextField("Enter your doctor's email", text: $diabetesData.doctorEmail)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
                .offset(y:-20)
            
            // navigate to the home page of the app
            Button(action: {
                if !diabetesData.allDone {
                    diabetesData.allDone = true
                    submitDiabetes()
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
            "diabetes_type":diabetesData.diabetesType,
            "diagnose_date":DateUtils.formattedDate(from: diabetesData.diagnoseDate, format: "yy-MM-dd"),
            "insulin_type":diabetesData.insulinType,
            "admin_route":diabetesData.adminRoute,
            "condition":diabetesData.condition,
            "medication":diabetesData.medication,
            "lower_bound":diabetesData.lowerBound,
            "upper_bound":diabetesData.upperBound,
            "doctor_email":diabetesData.doctorEmail,
            "doctor_name":diabetesData.doctorName
        ]
        
        // convert to JSON
        guard let url = URL(string: "http://127.0.0.1:5000/add_diabetes_info") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    // Assuming the backend returns a success message in the body
                    let responseString = String(data: data, encoding: .utf8) ?? "Unknown response"
                    completion(.success(responseString))
                } catch {
                    completion(.failure(error))
                }
            }
            print("Data being sent to the backend: \(diabetesDetails)")
        }
        
        task.resume()
    }
    
    // MARK: this function submits the diabetes details data to backend
    
    func submitDiabetes() {
        // Send the diabetes details data to the backend
        sendDiabetesData(diabetesData: diabetesData) { result in
            switch result {
            case .success(let responseMessage):
                print("Submission of diabetes details success: \(responseMessage)")
                // Navigate to the next screen or show a success message
            case .failure(let error):
                print("Submission of diabetes details failed: \(error.localizedDescription)")
                // Handle failure (e.g., show an error alert)
            }
        }
    }
}

struct DoctorInfo_Previews: PreviewProvider {
    static var previews: some View {
        DoctorInfoView(diabetesData: DiabetesDetailsData())
    }
}

