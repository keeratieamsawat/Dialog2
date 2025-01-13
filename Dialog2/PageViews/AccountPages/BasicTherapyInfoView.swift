// Page view to display and update basic therapy information
import SwiftUI

struct BasicTherapyInfoView: View {
    // State to store diabetes type, patient sex, and year of diagnosis
    @State private var diabetesType: String = "Type 2"
    @State private var sex: String = "-"
    @State private var yearOfDiagnosis: Int = 2022
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // MARK: - Top Blue Bar
                ZStack {
                    Color("Primary_Color")
                        .frame(height: 100)
                        .edgesIgnoringSafeArea(.top)

                    Text("Basic Therapy Info")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 55)
                        .padding(.bottom, 10)
                }

                // MARK: - Content Section
                VStack(spacing: 0) {
                    ZStack {
                        Color.white

                        VStack(spacing: 8) {
                            Text("Change your therapy details if needed.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)
                        }
                        .padding()
                    }
                    .frame(height: 80)

                    // MARK: - List of Options
                    List {
                        // Diabetes Type Section
                        // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
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
                            /* end of reference 1 */

                            // Sex Section
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

                            // Year of Diagnosis Section
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

                // MARK: - Bottom Blue Bar
                ZStack {
                    Color("Primary_Color")
                        .frame(height: 80)
                        .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

// MARK: - Diabetes Type Selection View
// Reference 2 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
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
/* end of reference 2 */

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

// MARK: - Preview
struct BasicTherapyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BasicTherapyInfoView()
    }
}
