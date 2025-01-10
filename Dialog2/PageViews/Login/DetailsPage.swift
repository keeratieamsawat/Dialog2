// this file contains:
// details of the user's diabetes conditions

import SwiftUI

struct DetailsPageView: View {
    
    // private vars
    @State private var diabetesType: String = "Type I" // default selection
    @State private var diagnoseDate: Date = Date()
    
    // list of diabetes types for picker
    let diabetesTypes = ["Type I","Type II","Gestational Diabetes","Other"]
    
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
                        selection: $diagnoseDate, displayedComponents: [.date])
                    .padding(10)
                }
                .frame(width:300,height:50) // Ensure DatePicker height is consistent
                .padding(.horizontal,40) // Padding around the DatePicker
                .datePickerStyle(CompactDatePickerStyle())
                
                // Picker for diabetes type
                Picker("Diabetes Type", selection: $diabetesType) {
                    ForEach(diabetesTypes, id: \.self) { type in
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
            NavigationLink(destination: InsulinInfoView()) {
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
    
    @State private var insulinType: String = "Rapid-acting" // default
    @State private var adminRoute: String = "Injection" //default
    
    // list of insulin types for picker
    let insulinTypes = ["Rapid-acting","Short-acting", "Intermediate-acting","Long-acting","I'm not taking insulin"]
    // list of insulin administration routes
    let adminRoutes = ["Injection","Pen","Pump","Other","I'm not taking insulin"]
    
    var body: some View {
        VStack(spacing:30) {
            Text("What insulin are you taking?")
                .font(.title3)
                .bold()
                .padding(.leading,20)
                .padding(.top,20)
            
            // drop-down picker for insulin types
            Picker("Insulin Type", selection: $insulinType) {
                ForEach(insulinTypes, id: \.self) { type in
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
            
            // drop-down picker for insulin administration
            Picker("Administration", selection: $adminRoute) {
                ForEach(adminRoutes, id: \.self) { type in
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
            NavigationLink(destination: MedicationView()) {
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
    
    // allow user type in other condition and medication
    @State private var condition: String = ""
    @State private var medication: String = ""
    
    var body: some View {
        VStack(spacing:30) {
            Text("What other health conditions have you been diagnosed, if any?")
                .font(.title3)
                .bold()
            // input other conditions
            TextField("Enter other conditions...", text: $condition)
                .padding(10)
                .frame(height:40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
            // no other conditions/don't know
            Text("I don't have other conditions")
                .bold()
                .frame(maxWidth:.infinity)
                .frame(height:40)
                .foregroundColor(.white)
                .background(Color("Primary_Color"))
                .cornerRadius(10)
            Text("I don't know")
                .bold()
                .frame(maxWidth:.infinity)
                .frame(height:40)
                .foregroundColor(.white)
                .background(Color("Primary_Color"))
                .cornerRadius(10)
            
            Text("What other medications are you taking, if any?")
                .font(.title3)
                .bold()
            // input other medications
            TextField("Enter other medications...", text: $medication)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
            // no other medications
            Text("I don't take other medications")
                .bold()
                .frame(height:40)
                .frame(maxWidth:.infinity)
                .foregroundColor(.white)
                .background(Color("Primary_Color"))
                .cornerRadius(10)
            // button to direct to next page
            NavigationLink(destination: bsRangeView()) {
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
        .padding(.horizontal,40)
    }
}


// MARK: choose target BS range for control

struct bsRangeView: View {
    
    // target range, hyper and hypo
    @State private var lowerBound: Float = 0.0 // initial value
    @State private var upperBound: Float = 0.0
    
    var body: some View {
        VStack(spacing:30){
            Text("What is your target blood sugar range?")
                .font(.title3)
                .bold()
            
            // target range lower bound
            Text("Lower bound: \(lowerBound,specifier: "%.2f")")
                .font(.caption)
            Slider(value: $lowerBound, in: 0.0...20.0, step: 0.1)
                .padding(40)
                .accentColor(Color("Primary_Color"))
                .offset(y:-40)
            
            // target range upper bound
            Text("Upper bound in:")
                .font(.headline)
            Text("Upper bound: \(upperBound,specifier:"%.2f")")
                .font(.caption)
            Slider(value: $upperBound, in: 0.0...20.0, step: 0.1)
                .padding(40)
                .accentColor(Color("Primary_Color"))
                .offset(y:-40)
            
            // display chosen range
            Text("Your chosen range: \(lowerBound,specifier: "%.2f") to \(upperBound,specifier: "%.2f") ")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .offset(y:-40)
            
            NavigationLink(destination: DoctorInfoView()) {
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

#Preview {
    DetailsPageView()
}
