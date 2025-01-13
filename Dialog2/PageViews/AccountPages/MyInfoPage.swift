// Account and Settings page personalized for each user. Also allows them to navigate through some of their basic information and adjust if changed from registration time.
import SwiftUI

struct MyInfoPage: View {
    var userName: String = "User Name" // User name displayed on the page
    
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
                                    Text("Account & Settings")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.top, -70)
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                
                                // Profile picture and user info
                                HStack(spacing: 40) {
                                    Circle()
                                        .fill(Color("Primary_Color"))
                                        .frame(width: 100, height: 100)
                                        .overlay(
                                            Text(String(userName.prefix(1)))
                                            // Display first letter of username
                                                .foregroundColor(.white)
                                                .font(.system(size: 50, weight: .bold))
                                        )
                                        .overlay(
                                            Image(systemName: "camera")
                                                .foregroundColor(.white)
                                                .padding(6)
                                                .background(Color.gray)
                                                .clipShape(Circle())
                                                .offset(x: 2, y: 5),
                                            alignment: .bottomTrailing
                                        )
                                        .offset(y: -35)
                                    
                                    VStack(alignment: .leading) {
                                        Text(userName)
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.black)
                                        Text("dialog@gmail.com") // Placeholder email
                                            .font(.system(size: 18, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    .offset(x: -10, y: -30)
                                }
                                
                                Spacer()
                            }
                            .padding()
                        }
                        .frame(height: 120)
                        
                        // MARK: - List of Options
                        List {
                            Section {
                                NavigationLink(destination: BasicTherapyInfoView()) {
                                    InfoRow(iconName: "circle.fill", iconColor: .blue, title: "Basic therapy info")
                                }
                                NavigationLink(destination: InsulinTherapyView()) {
                                    InfoRow(iconName: "drop.triangle.fill", iconColor: .teal, title: "Insulin therapy")
                                }
                                NavigationLink(destination: FoodView()) {
                                    InfoRow(iconName: "applelogo", iconColor: .orange, title: "Food")
                                }
                                NavigationLink(destination: AppDataView()) {
                                    InfoRow(iconName: "square.and.arrow.up", iconColor: .blue, title: "App data")
                                }
                                NavigationLink(destination: DoctorContactView()) {
                                    InfoRow(iconName: "stethoscope", iconColor: .purple, title: "Doctor contact")
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .frame(maxWidth: .infinity)
                        .offset(y: -10)
                        
                        // MARK: - Log Out Button
                        VStack {
                            Button(action: {
                                // Handle log out action (under development)
                            }) {
                                Text("Log out")
                                    .foregroundColor(.red)
                                    .font(.system(size: 18, weight: .medium))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                            .offset(y: -17)
                        }
                    }
                    .background(Color(UIColor.systemGray6))
                    
                    // MARK: - Bottom Blue Border
                    Color("Primary_Color")
                        .frame(height: 20)
                }
            }
            .navigationTitle("")
        }
    }
}

// MARK: - InfoRow Component
struct InfoRow: View {
    var iconName: String // System image name for the icon
    var iconColor: Color // Color of the icon
    var title: String    // Title of the row

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(8)
    }
}

// MARK: - Custom Corner Radius Shape
// Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
struct RoundedCorners: Shape {
    var tl: CGFloat = 0 // Top-left corner
    var tr: CGFloat = 0 // Top-right corner
    var bl: CGFloat = 0 // Bottom-left corner
    var br: CGFloat = 0 // Bottom-right corner

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - bl))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + tr))
        path.closeSubpath()
        return path
    }
}
/* end of reference 1 */

// MARK: - Preview
struct MyInfoPage_Previews: PreviewProvider {
    static var previews: some View {
        MyInfoPage()
    }
}
