import SwiftUI

struct DoctorContactView: View {
    @State private var doctorName: String = ""
    @State private var doctorEmail: String = ""
    @State private var emergencyContactNumber: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // MARK: - Top Blue Bar
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
                    // Header Section
                    ZStack {
                        Color.white
                        
                        VStack(spacing: 10) {
                            Text("Update your doctor's contact details.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
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
                            
                            HStack {
                                Text("Doctor's Email")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                                TextField("Enter email", text: $doctorEmail)
                                    .keyboardType(.emailAddress)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text("Emergency Contact Number")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                                TextField("Enter number", text: $emergencyContactNumber)
                                    .keyboardType(.phonePad)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
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

// MARK: Preview
struct DoctorContactView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorContactView()
    }
}
