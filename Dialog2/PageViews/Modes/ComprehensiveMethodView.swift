//
//  ComprehensiveMethodView.swift
//  Dialog2
//
//  Created by primproud on 12/12/2567 BE.
//
import SwiftUI

struct ComprehensiveMethodView: View {
    @State private var date: String = ""
    @State private var time: String = ""
    @State private var bloodSugarLevel: String = ""
    @State private var note: String = ""
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var timing: String = ""
    @State private var insulinNote: String = ""
    @State private var foodTime: String = ""
    @State private var foodName: String = ""
    @State private var portionSize: String = ""
    @State private var carbohydrateIntake: String = ""
    @State private var foodNote: String = ""
    @State private var exerciseName: String = ""
    @State private var duration: String = ""
    @State private var intensity: String = "Medium"

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title Section
                Text("Comprehensive Method")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)

                // Subtitle
                Text("*Ideal refining lifestyle or treatment strategies to improve diabetes management.")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                // Date, Time, and Blood Sugar Section
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        Text("DATE:")
                        Spacer()
                        TextField("", text: $date)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text("TIME:")
                            .multilineTextAlignment(.center)
                            
                        Spacer()
                        TextField("", text: $time)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.blue)
                        Text("BLOOD SUGAR LEVEL:")
                            .lineLimit(1)
                            .layoutPriority(1)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        TextField("", text: $bloodSugarLevel)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                        Text("NOTE:")
                        Spacer()
                        TextField("Optional", text: $note)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.1))
                )

                // Insulin Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("INSULIN")
                        .font(.headline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)

                    HStack {
                        Text("Name:")
                        Spacer()
                        TextField("Enter Medication Name", text: $medicationName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Dosage:")
                        Spacer()
                        TextField("Enter Dosage", text: $dosage)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Timing:")
                        Spacer()
                        TextField("Enter Timing", text: $timing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Note:")
                        Spacer()
                        TextField("Enter Notes", text: $insulinNote)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 2)
                )

                // Food Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("FOOD")
                        .font(.headline)
                        .foregroundColor(.green)

                    HStack {
                        Text("Time:")
                        Spacer()
                        TextField("Enter Time", text: $foodTime)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Food:")
                        Spacer()
                        TextField("Enter Food", text: $foodName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Portion Size:")
                        Spacer()
                        TextField("Enter Portion Size", text: $portionSize)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Carbohydrate Intake:")
                        Spacer()
                        TextField("Enter Carbs", text: $carbohydrateIntake)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Note:")
                        Spacer()
                        TextField("Enter Notes", text: $foodNote)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(0.1))
                )

                // Exercise Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("EXERCISE")
                        .font(.headline)
                        .foregroundColor(.purple)

                    HStack {
                        Text("Name:")
                        Spacer()
                        TextField("Enter Exercise Name", text: $exerciseName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Duration:")
                        Spacer()
                        TextField("Enter Duration", text: $duration)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Intensity:")
                        Spacer()
                        Picker("",selection: $intensity) {
                            Text("Low").tag("Low")
                            Text("Medium").tag("Medium")
                            Text("High").tag("High")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: 200)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.purple, lineWidth: 2)
                )

                // Apply Button
                Button(action: {
                    // Add action for Apply
                }) {
                    Text("APPLY")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct ComprehensiveMethodView_Previews: PreviewProvider {
    static var previews: some View {
        ComprehensiveMethodView()
    }
} 
