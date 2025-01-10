import SwiftUI

struct DoctorContactView: View {
    @State private var doctorName: String = ""
    @State private var doctorEmail: String = ""
    @State private var emergencyContactNumber: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary_Color")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // MARK: - Top Blue Border
                    Color("Primary_Color")
                        .frame(height: 100)
                    
                    // MARK: - Content Section
                    VStack(spacing: 0) {
                        // Header Section
                        ZStack {
                            Color.white
                                .clipShape(RoundedCorners(tl: 0, tr: 0, bl: 20, br: 20))
                            
                            VStack(spacing: 10) {
                                HStack {
                                    Button(action: {
                                        // Handle back button action
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    }
                                    Spacer()
                                    Text("Doctor Contact")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.top, -65)
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                
                                Text("Update your doctor's contact details.")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                    .padding(.top, -35)
                            }
                            .padding()
                        }
                        .frame(height: 80) // Reduced height for header
                        
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
                    
                    // MARK: - Bottom Blue Border
                    Color("Primary_Color")
                        .frame(height: 20) // Small blue border height
                }
            }
            .navigationTitle("")
        }
    }
}

// MARK: Preview
struct DoctorContactView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorContactView()
    }
}
