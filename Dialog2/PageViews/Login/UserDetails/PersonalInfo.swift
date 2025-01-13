// MARK: these pages take in new users' personal information, and propagate into following pages and eventually sent to backend

import SwiftUI

struct PersonalInfoView: View {
    
    // calling the data model
    @ObservedObject var userData = UserRegistrationData()
    
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
                TextField("Your gender", text: $userData.gender)
                    .padding(10) // this padding creates some blank before the text, so that the text does not touch the edge of the frame
                    .frame(height: 40) // standardise height of the frames
                    .overlay(
                        RoundedRectangle(cornerRadius: 8) // make the frame a rectangle with round corners
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10) // slight offset in y-axis for better vertical alignments
                
                // birth date
                Text("Birth Date:")
                    .font(.headline)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2)
                    // using a date picker for birth date selection
                    DatePicker(
                        "Select your birthday",
                        selection: $userData.birthDate,
                        displayedComponents: [.date])
                    .padding(10)
                }
                .frame(height:20) // as there is a date picker inside, the frame height need to be adjusted slightly different from the other frames
                .datePickerStyle(CompactDatePickerStyle()) // date picker style
                
                // country of residence
                Text("Country of Residence:")
                    .font(.headline)
                    .offset(y:10)
                TextField("Enter your country of residence", text: $userData.country)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                
                // emergency contact details
                Text("Emergency Contact:")
                    .font(.headline)
                    .offset(y:10)
                TextField("Details of your emergency contact", text: $userData.emergContact)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                
                // for weight and height
                // using HStack and VStack togehter, to align them next to each other
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Weight:")
                            .font(.headline)
                            .bold()
                        TextField("Enter weight", text: $userData.weight)
                            .padding(10)
                            .frame(height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Primary_Color"),lineWidth: 2))
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Height:")
                            .font(.headline)
                            .bold()
                        TextField("Enter height", text: $userData.height)
                            .padding(10)
                            .frame(height: 40)
                            .overlay( 
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Primary_Color"),lineWidth: 2))
                    }
                }
                
                // button to direct to next page
                NavigationLink(destination: ConsentsView(userData:userData)) {
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


struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfoView(userData: UserRegistrationData())
    }
}
