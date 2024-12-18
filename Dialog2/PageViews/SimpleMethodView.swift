import SwiftUI

struct SimpleMethodView: View {
    @State private var date: String = ""
    @State private var time: String = ""
    @State private var bloodSugarLevel: String = ""
    @State private var note: String = ""
    @State private var food: String = ""
    @State private var portionSize: String = ""
    @State private var carbohydrateIntake: String = ""
    @State private var foodNote: String = ""
    @State private var foodTime: String = "" // Fixed to prevent repeated use of `time`

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Title Section
                Text("Simple Method")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)

                // Subtitle
                Text("*Ideal for those with stable treatment plans or a low risk of hypoglycemia")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Input Section
                VStack(alignment: .leading, spacing: 15) {
                    Group {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text("DATE:")
                            Spacer()
                            TextField("Enter date", text: $date)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 200)
                        }
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            Text("TIME:")
                            Spacer()
                            TextField("Enter time", text: $time)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 200)
                        }
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                            Text("BLOOD SUGAR LEVEL:")
                            Spacer()
                            TextField("Enter blood sugar level", text: $bloodSugarLevel)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 200)
                        }
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                            Text("NOTE:")
                            Spacer()
                            TextField("Enter notes", text: $note)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 200)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.1))
                )

                // Food Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("FOOD")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.bottom, 5)

                    HStack {
                        Text("Time:")
                        Spacer()
                        TextField("Enter time", text: $foodTime)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Food:")
                        Spacer()
                        TextField("Enter food", text: $food)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Portion Size:")
                        Spacer()
                        TextField("Enter portion size", text: $portionSize)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Carbohydrate Intake:")
                        Spacer()
                        TextField("Enter carbs intake", text: $carbohydrateIntake)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                    HStack {
                        Text("Note:")
                        Spacer()
                        TextField("Enter food notes", text: $foodNote)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 200)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(0.1))
                )

                // Apply Button
                Button(action: {
                    print("User Input Saved")
                }) {
                    Text("APPLY")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .frame(maxHeight: .infinity) // Allow ScrollView to expand fully
    }
}

struct SimpleMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleMethodView()
    }
}

