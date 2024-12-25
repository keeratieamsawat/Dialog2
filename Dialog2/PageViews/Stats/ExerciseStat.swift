import SwiftUI

struct ExerciseStatView: View {
    
    // vars for selecting date range
    @State private var fromDate: Date = Date()
    @State private var toDate: Date = Date()
    
    // for exercise data
    @State private var exerciseName: String = "Cardio"
    @State private var duration: String = "40 minutes"
    @State private var intensity: String = "very intense I'm so tired"
    
    var body: some View {
        VStack(spacing: 0) {
            // header
            ZStack {
                Color("Primary_Color")
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .edgesIgnoringSafeArea(.top)
                Text("Exercise Statistics")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y:20)
            }

            // date range pickers
            VStack(alignment: .leading, spacing: 15) {
                Text("Choose a date range to view your exercise data...")
                    .font(.headline)
                    .foregroundColor(.gray)

                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("From:")
                        DatePicker("", selection: $fromDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("To:")
                        DatePicker("", selection: $toDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                }
            }
            .padding()

            // exercise log
            Text("Exercise Log")
                .font(.headline)
                .foregroundColor(.purple)
                .padding(.top)

            // scrollable logs
            ScrollView {
                VStack(spacing: 15) {
                    // some sample logs
                    ForEach(0..<5, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "figure.run")
                                Text("Type of exercise: ")
                                Spacer()
                                Text(exerciseName)
                            }
                            HStack {
                                Image(systemName: "hourglass")
                                Text("Duration: ")
                                Spacer()
                                Text(duration)
                            }
                            HStack {
                                Image(systemName: "drop")
                                Text("Intensity: ")
                                Spacer()
                                Text(intensity)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.purple.opacity(0.1))
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

#Preview {
    ExerciseStatView()
}
