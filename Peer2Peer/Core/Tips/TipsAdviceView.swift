import SwiftUI

struct TipsAdviceView: View {
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Disclaimer Section
                    disclaimerSection()
                    
                    // Blink Importance Section
                    blinkImportanceSection()
                    
                    // Condensed Tips Section
                    tipsSection()

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Tips & Advice")
        }
    }
    
    // Disclaimer Section
    @ViewBuilder
    private func disclaimerSection() -> some View {
        VStack(alignment: .leading) {
            Text("Important Note")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text("""
                This app provides only information and should not be used as medical advice. Always consult with your physician for professional medical advice, diagnosis, or treatment.
                """)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 3)
    }
    
    // Blink Importance Section
    @ViewBuilder
    private func blinkImportanceSection() -> some View {
        VStack(alignment: .leading) {
            Text("The Importance of Blinking")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text("""
                Blinking is crucial for keeping your eyes healthy. It produces a tear film that lubricates the eyes. Without blinking, tears evaporate, which can cause discomfort and dry eyes.
                """)
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 3)
    }
    
    // Condensed Tips Section
    @ViewBuilder
    private func tipsSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Helpful Tips for Eye Health")
                .font(.headline)
            
            Group {
                tipView(title: "1. Get a comprehensive eye exam.",
                        content: "An annual eye exam can prevent or treat computer vision issues. Tell your eye doctor about your screen time.")

                tipView(title: "2. Use proper lighting.",
                        content: "Make sure the lighting in your workspace is comfortable. Reduce harsh outdoor or indoor lighting.")

                tipView(title: "3. Minimize glare.",
                        content: "Glare from screens can strain your eyes. Use anti-glare filters or glasses with anti-reflective coating.")

                tipView(title: "4. Upgrade your display.",
                        content: "High-resolution screens with anti-reflective coatings are easier on your eyes than older monitors.")

                tipView(title: "5. Adjust your display settings.",
                        content: "Set the brightness of your screen to match your environment and reduce blue light exposure with the color temperature settings.")

                tipView(title: "6. Blink more often.",
                        content: "Follow the 20-20-20 rule: every 20 minutes, blink and look at something 20 feet away for 20 seconds.")

                tipView(title: "7. Exercise your eyes.",
                        content: "Shift focus between near and far objects to relax your eye muscles.")

                tipView(title: "8. Take frequent breaks.",
                        content: "Rest your eyes for 10 minutes every hour to prevent eye strain.")

                tipView(title: "9. Modify your workstation.",
                        content: "Position your monitor slightly below eye level and ensure comfortable posture.")

                tipView(title: "10. Consider computer glasses.",
                        content: "Talk to your eye doctor about specialized glasses for digital devices.")
            }
        }
    }
    
    // Helper function for each tip
    @ViewBuilder
    private func tipView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            Text(content)
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

#Preview {
    TipsAdviceView()
}
