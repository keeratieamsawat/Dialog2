// this file contains:
// details of the user's diabetes conditions

import SwiftUI

// for these pages, use NavigationLink with a binding condition
// to enable automatically entering the next page when user input and saved their details
// the binding condition is of type "Bool"

struct DetailsPageView: View {
    
    // private vars
    @State private var diabetesType: String = "Type I" // Default selection
    @State private var diagnoseDate: Date = Date()
    
    // List of diabetes types to choose from
    let diabetesTypes = ["Type I", "Type II", "Gestational Diabetes", "Other"]
    
    var body: some View {
        
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
            .overlay( // Border around the picker
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Primary_Color"), lineWidth: 2)
            )
            .padding(.horizontal,40) // Same padding as DatePicker
        }
        // button to direct to next page
        NavigationLink(destination: InsulinInfoView()) {
            Text("Next Page")
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

struct InsulinInfoView: View {
    var body: some View {
        Text("What insulin are you taking?")
    }
}

#Preview {
    DetailsPageView()
}
