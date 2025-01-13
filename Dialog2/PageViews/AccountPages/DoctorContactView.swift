// Page view to display user's doctor contact information
import SwiftUI

struct DoctorContactView: View {
    // MARK: - State Variables
    // Variables to store the doctor's contact details
    @State private var doctorName: String = ""
    @State private var doctorEmail: String = ""
    @State private var emergencyContactNumber: String = ""

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // MARK: - Top Blue Bar & Title
                ZStack {
                    Color("Primary_Color")
                        .frame(height: 100)
                        .edgesIgnoringSafeArea(.top)

                    Text("Doctor Contact")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 55)
                        .padding(.bottom, 10)
                }
                
                // MARK: - Content Section
                VStack(spacing: 0) {
                    ZStack {
                        Color.white

                        VStack(spacing: 10) {
                            Text("Update your doctor's contact details.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray) // Instruction text
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                        }
                        .padding()
                    }
                    .frame(height: 80)
                    
                    // MARK: - List of Options
                    List {
                        Section {
                            // Doctor's Name Field
                            // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
                            HStack {
                                Text("Doctor's Name")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                                TextField("Enter name", text: $doctorName)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.gray)
                            }
                            /* end of reference 1 */
                            
                            // Doctor's Email Field
                            HStack {
                                Text("Doctor's Email")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                                TextField("Enter email", text: $doctorEmail)
                                    .keyboardType(.emailAddress) // Email keyboard type
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.gray)
                            }
                            
                            // Emergency Contact Number Field
                            HStack {
                                Text("Emergency Contact Number")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                                TextField("Enter number", text: $emergencyContactNumber)
                                    .keyboardType(.phonePad) // Phone keyboard type
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle()) // iOS-style grouped list
                    .frame(maxWidth: .infinity)
                    .offset(y: -10)
                }
                .background(Color(UIColor.systemGray6))
                
                // MARK: - Bottom Blue Bar
                ZStack {
                    Color("Primary_Color")
                        .frame(height: 80)
                        .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
struct DoctorContactView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorContactView()
    }
}
