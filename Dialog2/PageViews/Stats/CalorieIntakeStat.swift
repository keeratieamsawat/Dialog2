import SwiftUI

struct CalorieIntakeStatView: View {
    
    // vars to store from and to date - create a date range
    @State private var fromDate: Date = Date()
    @State private var toDate: Date = Date()
    
    var body: some View {
        VStack() {
            Text("Calorie Intake")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("Choose a date range to view your average calorie intake data...")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
            
            // DatePicker to allow user select date
            HStack() {
                VStack(spacing:5) {
                    //RoundedRectangle(cornerRadius: 10)
                    //.stroke(Color("Primary_Color"), lineWidth: 2)
                    DatePicker(
                        "From:",
                        selection: $fromDate, displayedComponents: [.date])
                    .padding(12)
                    .frame(width:200,height:50)
                    .datePickerStyle(CompactDatePickerStyle())
                    .offset(x:30)
                    Spacer()
                }
                VStack(spacing:5) {
                    //RoundedRectangle(cornerRadius: 10)
                    //.stroke(Color("Primary_Color"), lineWidth: 2)
                    DatePicker(
                        "To:",
                        selection: $toDate, displayedComponents: [.date])
                    .padding(22)
                    .frame(width:200,height:50)
                    .datePickerStyle(CompactDatePickerStyle())
                    Spacer()
                }
            }
            Text("Choose a date range to view your average calorie intake data...")
                .font(.headline)
                .foregroundColor(.gray)

        }
        
        .navigationTitle("Calorie Stats")
        .padding()
    }
    
}

#Preview {
    CalorieIntakeStatView()
}
