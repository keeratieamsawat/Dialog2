// MARK: this file contains UI pages for user's diabetes condition details
// the variables are stored as a data model in separate file "DiabetesDetailsData"

import SwiftUI

struct DetailsPageView: View {
    
    // calling the data model
    @StateObject var diabetesData:DiabetesDetailsData
    
    var body: some View {
        NavigationStack {
            
// MARK: diagnosis time + diabetes type:
            
            VStack(spacing: 30) {
                Text("We'll need some details about your condition...")
                    .font(.headline)
                    .bold()
                    .padding(.leading,20) // padding from the left
                    .padding(.top,40) // padding from the top
                Text("First off, when were you diagnosed, and what diabetes type are you diagnosed with?")
                    .font(.title3)
                    .bold()
                    .padding(.leading,20)
                    .padding(.top,20)
                
                // date picker for diagnosis date, using the specific structure for a date picker in SwiftUI
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Primary_Color"), lineWidth: 2)
                    DatePicker(
                        "Date diagnosed",
                        selection: $diabetesData.diagnoseDate, displayedComponents: [.date])
                    .padding(10)
                }
                .frame(width:300,height:50) // set height and width for date picker frame
                .datePickerStyle(CompactDatePickerStyle())
                
                // picker for diabetes type, using SwiftUI's drop-down menu style
                Picker("Diabetes Type", selection: $diabetesData.diabetesType) {
                    ForEach(diabetesData.diabetesTypes, id: \.self) { type in
                        Text(type)
                            .tag(type) // matching each tag to the data type of the variable, in this case, a String
                    }
                }
                .pickerStyle(MenuPickerStyle()) // drop-down menu style
                .frame(width:300,height:50) // set width and height the same as the date picker
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Primary_Color"), lineWidth: 2)
                )
            }
            
            // "Confirm" button that navigates to next page
            NavigationLink(destination: InsulinInfoView(diabetesData:diabetesData)) {
                // diabetesData argument passed into the navigation link, to ensure data from this page is propagated to the next
                Text("Confirm")
                    .bold()
                    .frame(width:300,height:50)
                    .foregroundColor(.white)
                    .background(Color("Primary_Color"))
                    .cornerRadius(10)
            }
            .padding(.top,40) // padding for spacing between components
        }
    }
}
    
// MARK: insulin type + administration

struct InsulinInfoView: View {
    
    @StateObject var diabetesData:DiabetesDetailsData
    
    var body: some View {
        VStack(spacing:30) {
            Text("What insulin are you taking?")
                .font(.title3)
                .bold()
                .padding(.leading,20)
                .padding(.top,20)
            
            // drop-down picker for insulin types
            Picker("Insulin Type", selection: $diabetesData.insulinType) {
                ForEach(diabetesData.insulinTypes, id: \.self) { type in
                    Text(type)
                        .tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle()) // drop-down menu
            .frame(width:300,height:50)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Primary_Color"), lineWidth: 2)
            )
            .padding(.horizontal,40)
            
            Text("How do you administer your insulin?")
                .font(.title3)
                .bold()
                .padding(.leading,20)
                .padding(.top,20)
            
            // drop-down picker for insulin administration
            Picker("Administration", selection: $diabetesData.adminRoute) {
                ForEach(diabetesData.adminRoutes, id: \.self) { type in
                    Text(type)
                        .tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle()) // drop-down menu
            .frame(width:300,height:50)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Primary_Color"), lineWidth: 2)
            )
            
            // button for navigation, passing diabetesData argument again
            NavigationLink(destination: MedicationView(diabetesData:diabetesData)) {
                Text("Confirm")
                    .bold()
                    .frame(width:300,height:50)
                    .foregroundColor(.white)
                    .background(Color("Primary_Color"))
                    .cornerRadius(10)
            }
            .padding(.horizontal,40)
        }
    }
}

// MARK: other conditions + other medications

struct MedicationView: View {
    
    @StateObject var diabetesData:DiabetesDetailsData
    
    var body: some View {
        VStack(spacing:30) {
            Text("What other health conditions have you been diagnosed, if any? (Enter N/A if not applicable)")
                .font(.title3)
                .bold()
            // user can type in other conditions
            TextField("Enter other conditions...", text: $diabetesData.condition)
                .padding(10)
                .frame(height:40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
            
            Text("What other medications are you taking, if any? (Enter N/A if not applicable)")
                .font(.title3)
                .bold()
            
            // user can type in other medications
            TextField("Enter other medications...", text: $diabetesData.medication)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
            
            // navigation button, passing diabetesData argument again
            NavigationLink(destination: bsRangeView(diabetesData:diabetesData)) {
                Text("Confirm")
                    .bold()
                    .frame(height:40)
                    .frame(maxWidth:.infinity)
                    .foregroundColor(.white)
                    .background(Color("Primary_Color"))
                    .cornerRadius(10)
            }
        }
        .padding(40)
    }
}

// MARK: choose target BS range for control

struct bsRangeView: View {
    
    @StateObject var diabetesData:DiabetesDetailsData
    
    var body: some View {
        VStack(spacing:30){
            Text("What is your target blood sugar range?")
                .font(.title3)
                .bold()
            
            // target range lower bound, implemented with a slider style that allows the user to slide and choose their target range
            Text("Lower bound: \(diabetesData.lowerBound,specifier: "%.2f")")
            // specifier %.2f ensures 2 decimal places
                .font(.caption)
            Slider(value: $diabetesData.lowerBound, in: 50.0...80.0, step: 0.1)
                .padding(40)
                .accentColor(Color("Primary_Color"))
                .offset(y:-40)
            
            // target range upper bound, slider style
            Text("Upper bound in:")
                .font(.headline)
            Text("Upper bound: \(diabetesData.upperBound,specifier:"%.2f")")
                .font(.caption)
            Slider(value: $diabetesData.upperBound, in: 70.0...120.0, step: 0.1)
                .padding(40)
                .accentColor(Color("Primary_Color"))
                .offset(y:-40)
            
            // line of text to display the chosen range selected by the user with the sliders
            Text("Your chosen range: \(diabetesData.lowerBound,specifier: "%.2f") to \(diabetesData.upperBound,specifier: "%.2f") ")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .offset(y:-40)
            
            // navigation button, passing diabetesData argument again
            NavigationLink(destination: DoctorInfoView(diabetesData:diabetesData)) {
                Text("Confirm")
                    .bold()
                    .frame(height:40)
                    .frame(maxWidth:.infinity)
                    .foregroundColor(.white)
                    .background(Color("Primary_Color"))
                    .cornerRadius(10)
                    .padding(.horizontal,40)
            }
        }
    }
}

// preview provider to allow viewing of the UI pages while passing the diabetesData 
struct DetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        DetailsPageView(diabetesData: DiabetesDetailsData())
    }
}
