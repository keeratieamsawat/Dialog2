// this file contains:
// details of the user's diabetes conditions

import SwiftUI

struct DetailsPageView: View {
    
    // calling the data model
    @ObservedObject var diabetesData:DiabetesDetailsData
    
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
                
                // Date picker for date diagnosed
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Primary_Color"), lineWidth: 2)
                    DatePicker(
                        "Date diagnosed",
                        selection: $diabetesData.diagnoseDate, displayedComponents: [.date])
                    .padding(10)
                }
                .frame(width:300,height:50) // Ensure DatePicker height is consistent
                .padding(.horizontal,40) // Padding around the DatePicker
                .datePickerStyle(CompactDatePickerStyle())
                
                // Picker for diabetes type
                Picker("Diabetes Type", selection: $diabetesData.diabetesType) {
                    ForEach(diabetesData.diabetesTypes, id: \.self) { type in
                        Text(type)
                            .tag(type) // match the tag to data type
                    }
                }
                .pickerStyle(MenuPickerStyle()) // drop-down menu
                .frame(width:300,height:50) // Ensure Picker width and height are consistent with DatePicker
                .background(Color.white) // Background color for the picker
                .cornerRadius(10) // Rounded corners for the border
                .overlay( // border around the picker
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Primary_Color"), lineWidth: 2)
                )
                .padding(.horizontal,40)
            }
            // button to direct to next page
            NavigationLink(destination: InsulinInfoView(diabetesData:diabetesData)) {
                Text("Confirm")
                    .bold()
                    .frame(width:300,height:50)
                    .foregroundColor(.white)
                    .background(Color("Primary_Color"))
                    .cornerRadius(10)
                    .padding(.horizontal,40)
            }
            .padding(.top,40) // Add overall padding for spacing
        }
    }
}
    
// MARK: insulin type + administration

struct InsulinInfoView: View {
    
    @ObservedObject var diabetesData:DiabetesDetailsData
    
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
            // button to direct to next page
            NavigationLink(destination: MedicationView(diabetesData:diabetesData)) {
                Text("Confirm")
                    .bold()
                    .frame(width:300,height:50)
                    .foregroundColor(.white)
                    .background(Color("Primary_Color"))
                    .cornerRadius(10)
                    .padding(.horizontal,40)
            }
            .padding(.horizontal,40)
        }
    }
}

// MARK: other conditions + other medications

struct MedicationView: View {
    
    @ObservedObject var diabetesData:DiabetesDetailsData
    
    var body: some View {
        VStack(spacing:30) {
            Text("What other health conditions have you been diagnosed, if any? (Enter N/A if not applicable)")
                .font(.title3)
                .bold()
            // input other conditions
            TextField("Enter other conditions...", text: $diabetesData.condition)
                .padding(10)
                .frame(height:40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
            
            Text("What other medications are you taking, if any? (Enter N/A if not applicable)")
                .font(.title3)
                .bold()
            // input other medications
            TextField("Enter other medications...", text: $diabetesData.medication)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
            
            // button to direct to next page
            NavigationLink(destination: bsRangeView(diabetesData:diabetesData)) {
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
        .padding(40)
    }
}



// MARK: choose target BS range for control

struct bsRangeView: View {
    
    @ObservedObject var diabetesData:DiabetesDetailsData
    
    var body: some View {
        VStack(spacing:30){
            Text("What is your target blood sugar range?")
                .font(.title3)
                .bold()
            
            // target range lower bound
            Text("Lower bound: \(diabetesData.lowerBound,specifier: "%.2f")")
                .font(.caption)
            Slider(value: $diabetesData.lowerBound, in: 0.0...20.0, step: 0.1)
                .padding(40)
                .accentColor(Color("Primary_Color"))
                .offset(y:-40)
            
            // target range upper bound
            Text("Upper bound in:")
                .font(.headline)
            Text("Upper bound: \(diabetesData.upperBound,specifier:"%.2f")")
                .font(.caption)
            Slider(value: $diabetesData.upperBound, in: 0.0...20.0, step: 0.1)
                .padding(40)
                .accentColor(Color("Primary_Color"))
                .offset(y:-40)
            
            // display chosen range
            Text("Your chosen range: \(diabetesData.lowerBound,specifier: "%.2f") to \(diabetesData.upperBound,specifier: "%.2f") ")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .offset(y:-40)
            
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

struct DetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        DetailsPageView(diabetesData: DiabetesDetailsData())
    }
}
