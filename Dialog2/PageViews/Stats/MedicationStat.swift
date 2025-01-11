import SwiftUI

struct MedicationStatView: View {
    
    // for medicine intake data
    @State private var condition: String = "high blood pressure"
    @State private var medicationName: String = "medication"
    @State private var medDosage: String = "dose"
    @State private var medNote: String = "BOOM"
    
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                // header
                ZStack {
                    Color("Primary_Color")
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .edgesIgnoringSafeArea(.top)
                    Text("Other Medicine")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(y:20)
                }
                
                Text("You can change you medication record in My Profile page")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top)
                
                
                // medicine intake record
                Text("Other Medicine Intake Record")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .padding(.top)
                
                // scrollable records
                ScrollView {
                    VStack(spacing: 15) {
                        // some sample records
                        ForEach(0..<5, id: \.self) { _ in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "pills")
                                    Text("Condition: ")
                                    Spacer()
                                    Text(condition)
                                }
                                HStack {
                                    Image(systemName: "pills")
                                    Text("Medication: ")
                                    Spacer()
                                    Text(medicationName)
                                }
                                HStack {
                                    Image(systemName: "drop")
                                    Text("Dosage: ")
                                    Spacer()
                                    Text(medDosage)
                                }
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Note: ")
                                    Spacer()
                                    Text(medNote)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.yellow.opacity(0.1))
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                // bottom blue bar
                ZStack {
                    Color("Primary_Color")
                        .frame(height: 80)
                        .edgesIgnoringSafeArea(.bottom)
                        .offset(y:40)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

#Preview {
    MedicationStatView()
}
