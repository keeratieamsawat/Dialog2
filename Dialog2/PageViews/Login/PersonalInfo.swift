import SwiftUI

struct PersonalInfoView: View {

// MARK: storing user inputs to the create account pages

    @State private var gender: String = ""
    @State private var birthDate: Date = Date()
    @State private var country: String = ""
    @State private var emergContact: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) { // use alignment in VStack to align everything to the left
                
                // texts on the create account page
                Text("Step 2 of 3")
                    .font(.subheadline)
                
                Text("Personal Information")
                    .font(.title)
                    .bold() // Make it bold
                
                // MARK: text fields to intake user inputs for creating account
                
                // gender
                Text("Gender:")
                    .font(.headline)
                TextField("Your gender", text: $gender)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10)
                
                // birth date
                Text("Birth Date:")
                    .font(.headline)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2)
                    
                    DatePicker(
                        "Select your birthday",
                        selection: $birthDate,
                        displayedComponents: [.date])
                    .padding(10)
                }
                .frame(height:20)
                .datePickerStyle(CompactDatePickerStyle())
                
                // country of residence
                Text("Country of Residence:")
                    .font(.headline)
                    .offset(y:10)
                TextField("Enter your country of residence", text: $country)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                
                // emergency contact details
                Text("Emergency Contact:")
                    .font(.headline)
                    .offset(y:10)
                TextField("Details of your emergency contact", text: $emergContact)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                
                // for weight and height
                // using HStack and VStack to align them next to each other
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Weight:")
                            .font(.headline)
                            .bold()
                        TextField("Enter weight", text: $weight)
                            .padding(10)
                            .frame(height: 40)
                            .overlay( // Add a border
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Primary_Color"),lineWidth: 2))
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Height:")
                            .font(.headline)
                            .bold()
                        TextField("Enter height", text: $height)
                            .padding(10)
                            .frame(height: 40)
                            .overlay( // Add a border
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Primary_Color"),lineWidth: 2))
                    }
                }
                
                // button to direct to next page
                NavigationLink(destination: ConsentsView()) {
                    Text("Final Step")
                        .bold()
                        .frame(maxWidth:.infinity,minHeight: 50)
                        .foregroundColor(.white)
                        .background(Color("Primary_Color"))
                        .cornerRadius(10)
                        .padding(.horizontal,40)
                }
                
                Spacer() // VStack spacer to push contents up
            }
            .padding(40) // VStack padding to make content not touch the edges
        }
    }
}

struct ConsentsView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) { // use alignment in VStack to align everything to the left
                // texts on the create account page
                Text("Step 3 of 3")
                    .font(.subheadline)
                
                Text("Privacy & Legal Consents")
                    .font(.title)
                    .bold()
                Spacer() // VStack spacer to push contents up
            }
            .padding(30) // VStack padding to make content not touch the edges
        }
    }
}


struct SignInView: View {
    var body: some View {
        Text("Sign In Page")
            .font(.largeTitle)
    }
}

#Preview {
    PersonalInfoView()
}
