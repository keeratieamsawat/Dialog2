import SwiftUI

struct BasicTherapyInfoView: View {
    @State private var diabetesType: String = "Type 2"
    @State private var sex: String = "-"
    @State private var yearOfDiagnosis: Int = 2022

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
                            
                            VStack(spacing: 10) {
                                HStack {
                                    Button(action: {
                                        // Handle back button action
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    }
                                    Spacer()
                                    Text("Basic Therapy Info")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.top, -65)
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                
                                Text("Change your therapy details if needed.")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                    .padding(.top, -35)
                            }
                            .padding()
                        }
                        .frame(height: 80) // Reduced height for header
                        
                        // MARK: - List of Options
                        List {
                            Section {
                                NavigationLink(
                                    destination: DiabetesTypeSelectionView(selectedType: $diabetesType)
                                ) {
                                    HStack {
                                        Text("Diabetes type")
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(diabetesType)
                                            .font(.body)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                NavigationLink(
                                    destination: SexSelectionView(selectedSex: $sex)
                                ) {
                                    HStack {
                                        Text("Sex")
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(sex)
                                            .font(.body)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                NavigationLink(
                                    destination: YearOfDiagnosisSelectionView(selectedYear: $yearOfDiagnosis)
                                ) {
                                    HStack {
                                        Text("Year of diagnosis")
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("\(yearOfDiagnosis)")
                                            .font(.body)
                                            .foregroundColor(.gray)
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
                        .frame(height: 20) // Small blue border height
                }
            }
            .navigationTitle("")
        }
    }
}

// MARK: - Diabetes Type Selection View
struct DiabetesTypeSelectionView: View {
    @Binding var selectedType: String
    let types = ["Type 1", "Type 2"]

    var body: some View {
        List {
            ForEach(types, id: \.self) { type in
                Button(action: {
                    selectedType = type
                }) {
                    HStack {
                        Text(type)
                        Spacer()
                        if selectedType == type {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Diabetes Type")
    }
}

// MARK: - Sex Selection View
struct SexSelectionView: View {
    @Binding var selectedSex: String
    let options = ["Female", "Male", "Other"]

    var body: some View {
        List {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedSex = option
                }) {
                    HStack {
                        Text(option)
                        Spacer()
                        if selectedSex == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Sex")
    }
}

// MARK: - Year of Diagnosis Selection View
struct YearOfDiagnosisSelectionView: View {
    @Binding var selectedYear: Int
    let years = Array(1900...Calendar.current.component(.year, from: Date()))

    var body: some View {
        Picker("Year of Diagnosis", selection: $selectedYear) {
            ForEach(years, id: \.self) { year in
                Text("\(year)").tag(year)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .navigationTitle("Select Year")
    }
}


// MARK: Preview
struct BasicTherapyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BasicTherapyInfoView()
    }
}
