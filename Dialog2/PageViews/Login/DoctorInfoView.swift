import SwiftUI

struct DoctorInfoView: View {
    
    @State private var doctorName: String = ""
    
    var body: some View {
        VStack(alignment:.leading,spacing: 30) {
            Text("We would also need your doctor's details so we can contact them in case of emergency...")
                .font(.headline)
                .bold()
            Text("Your Doctor's Name:")
                .font(.headline)
            TextField("Enter your doctor's name", text: $doctorName)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
                .offset(y:-20)
            Text("Your Doctor's Email:")
                .font(.headline)
            TextField("Enter your doctor's email", text: $doctorName)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
                .offset(y:-20)
            Text("Emergency Contact Number:")
                .font(.headline)
            TextField("Enter emergency contact number", text: $doctorName)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
                .offset(y:-20)
            
            // navigate to the home page of the app
            NavigationLink(destination: HomePageView()) {
                Text("All done!")
                    .bold()
                    .frame(height:40)
                    .frame(maxWidth:.infinity)
                    .foregroundColor(.white)
                    .background(Color("Primary_Color"))
                    .cornerRadius(10)
                    .padding(.horizontal,40)
            }

        }
        .padding(.horizontal,40)
    }
}

#Preview {
    DoctorInfoView()
}

