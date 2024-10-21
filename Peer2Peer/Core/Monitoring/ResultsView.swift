import SwiftUI

struct ResultsView: View {
    let eyeStrainScore: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Monitoring Results")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Text("Your Eye Strain Score is \(eyeStrainScore)")
                .font(.title2)
                .foregroundColor(eyeStrainScore > 50 ? .red : .green)
                .padding(.top, 20)
            
            Text("Recommended Rest Time: \(recommendedRestTime()) minutes")
                .font(.title3)
                .foregroundColor(.blue)
                .padding(.top, 10)
            
            Spacer()
            
            Button(action: {
                // This will pop the current view and navigate back to the home page
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 40)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    func recommendedRestTime() -> Int {
        return max(eyeStrainScore / 10, 5) // Minimum 5 minutes rest
    }
}
