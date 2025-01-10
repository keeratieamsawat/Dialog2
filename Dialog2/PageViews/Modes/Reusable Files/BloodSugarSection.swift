import SwiftUI

struct BloodSugarSection: View {
    @Binding var selectedDate: Date
    @Binding var bloodSugarTime: Date
    @Binding var bloodSugarLevel: String
    @Binding var mealTiming: String
    @Binding var noteBloodSugar: String

    @State private var alert: BloodSugarAlert?

    var isHyperglycemia: Bool {
        guard let bloodSugar = Double(bloodSugarLevel) else { return false }
        if mealTiming == "Pre-meal" {
            return bloodSugar > 7.0 // Fasting threshold
        } else if mealTiming == "Post-meal" {
            return bloodSugar > 11.0 // 2 hours after meal threshold
        }
        return false
    }

    var body: some View {
        VStack(spacing: 15) {
            // Formatted Date
            HStack {
                Image(systemName: "calendar").foregroundColor(.white)
                Text("DATE:")
                    .foregroundColor(.white)
                Spacer()
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .foregroundColor(.white)
            }

            // Blood Sugar Time
            HStack {
                Image(systemName: "clock").foregroundColor(.white)
                Text("BLOOD SUGAR TIME:")
                    .lineLimit(1)
                    .layoutPriority(1)
                    .foregroundColor(.white)
                Spacer()
                DatePicker("", selection: $bloodSugarTime, displayedComponents: .hourAndMinute)
                    .foregroundColor(.white)
            }

            // Blood Sugar Level
            HStack {
                Image(systemName: "drop.fill").foregroundColor(.yellow)
                Text("BLOOD SUGAR LEVEL:")
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .layoutPriority(1)
                Spacer()
                TextField("", text: $bloodSugarLevel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 200)
                    .onChange(of: bloodSugarLevel) { _ in
                        if isHyperglycemia {
                            alert = BloodSugarAlert(
                                title: "High Blood Sugar",
                                message: "Your blood sugar level is out of range. Please consult a doctor.",
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
            }

            // Condition Picker
            HStack {
                Image(systemName: "pencil").foregroundColor(.white)
                Text("CONDITION:")
                    .foregroundColor(.white)
                Spacer()
                Picker("", selection: $mealTiming) {
                    Text("Pre-meal").tag("Pre-meal")
                    Text("Post-meal").tag("Post-meal")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 200)
            }

            // Explanation Text
            Text("""
            Pre-meal: Before eating your meal.
            Post-meal: Measured 2 hours after your last meal.
            """)
            .font(.footnote)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.top, 3)

            // Notes Field
            HStack {
                Text("NOTE:")
                    .foregroundColor(.white)
                Spacer()
                TextField("Optional", text: $noteBloodSugar)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 200)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.5)))
        .padding(.horizontal)
        .bloodSugarAlert($alert)
    }
}

struct BloodSugarSection_Previews: PreviewProvider {
    static var previews: some View {
        BloodSugarSection(
            selectedDate: .constant(Date()),
            bloodSugarTime: .constant(Date()),
            bloodSugarLevel: .constant(""),
            mealTiming: .constant("Pre-meal"),
            noteBloodSugar: .constant("")
        )
       
    }
}

