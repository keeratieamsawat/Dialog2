import SwiftUI

struct InsulinTherapyView: View {
    @State private var therapyType: String = "Pen / Syringes"
    @State private var insulinType: String = "Rapid-acting insulin"
    @State private var customInsulinType: String = ""
    @State private var healthConditions: String = ""
    @State private var otherMedications: String = ""
    @State private var showTherapyTypePicker = false
    @State private var showInputSheet = false
    @State private var inputTitle: String = ""
    @State private var inputText: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary_Color")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // MARK: - Top Blue Border
                    Color("Primary_Color")
                        .frame(height: 100)
                    
                    // MARK: - Content Section
                    VStack(spacing: 0) {
                        // Header Section
                        ZStack {
                            Color.white
                                .clipShape(RoundedCorners(tl: 0, tr: 0, bl: 20, br: 20))
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Button(action: {
                                        // Handle back button action
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    }
                                    Spacer()
                                    Text("Insulin Therapy Info")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.top, -50)
                                    Spacer()
                                }
                                .padding(.bottom, 8)
                                
                                Text("How you take in insulin and how it affects your body")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 20)
                            }
                            .padding(.top, -10)
                            .padding(.bottom, 8)
                        }
                        .frame(height: 120) // Adjust height to fit content
                        
                        // MARK: - List of Options
                        List {
                            // Therapy Type Section
                            Section {
                                Button(action: {
                                    showTherapyTypePicker = true
                                }) {
                                    HStack {
                                        Text("Therapy type")
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(therapyType)
                                            .font(.body)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            // Insulin Type Section
                            Section {
                                Picker("Insulin type", selection: $insulinType) {
                                    Text("Rapid-acting insulin").tag("Rapid-acting insulin")
                                    Text("Short-acting insulin").tag("Short-acting insulin")
                                    Text("Intermediate-acting insulin").tag("Intermediate-acting insulin")
                                    Text("Long-acting insulin").tag("Long-acting insulin")
                                    Text("Other").tag("Other")
                                }
                                .pickerStyle(MenuPickerStyle())
                                
                                // Show custom input field if "Other" is selected
                                if insulinType == "Other" {
                                    TextField("Enter insulin type", text: $customInsulinType)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            }
                            
                            // Other Health Conditions Section
                            Section {
                                Button(action: {
                                    inputTitle = "Other Health Conditions"
                                    inputText = healthConditions
                                    showInputSheet = true
                                }) {
                                    HStack {
                                        Text("Other health conditions")
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(healthConditions.isEmpty ? "Add info" : healthConditions)
                                            .font(.body)
                                            .foregroundColor(healthConditions.isEmpty ? .gray : .black)
                                            .lineLimit(1)
                                    }
                                }
                            }
                            
                            // Other Medications Section
                            Section {
                                Button(action: {
                                    inputTitle = "Other Medications"
                                    inputText = otherMedications
                                    showInputSheet = true
                                }) {
                                    HStack {
                                        Text("Other medications")
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(otherMedications.isEmpty ? "Add info" : otherMedications)
                                            .font(.body)
                                            .foregroundColor(otherMedications.isEmpty ? .gray : .black)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .frame(maxWidth: .infinity)
                        .offset(y: -10)
                    }
                    .background(Color(UIColor.systemGray6))
                    
                    // MARK: - Bottom Blue Border
                    Color("Primary_Color")
                        .frame(height: 20)
                }
            }
            .navigationTitle("")
            .sheet(isPresented: $showTherapyTypePicker) {
                TherapyTypePicker(therapyType: $therapyType)
            }
            .sheet(isPresented: $showInputSheet) {
                InputSheet(
                    title: inputTitle,
                    inputText: $inputText,
                    onSave: { newText in
                        if inputTitle == "Other Health Conditions" {
                            healthConditions = newText
                        } else if inputTitle == "Other Medications" {
                            otherMedications = newText
                        }
                    }
                )
            }
        }
    }
}

struct TherapyTypePicker: View {
    @Binding var therapyType: String
    let options = ["Pen / Syringes", "Pump", "No Insulin", "Other"]

    var body: some View {
        NavigationView {
            List {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        therapyType = option
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(.black)
                            Spacer()
                            if option == therapyType {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Therapy Type")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

struct InputSheet: View {
    let title: String
    @Binding var inputText: String
    var onSave: (String) -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $inputText)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding()
                
                Spacer()
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(inputText)
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

struct InsulinTherapyView_Previews: PreviewProvider {
    static var previews: some View {
        InsulinTherapyView()
    }
}
