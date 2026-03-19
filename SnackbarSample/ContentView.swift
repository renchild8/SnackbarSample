
import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var snackbarConfiguration = Snackbar.Configuration(
        message: "Hello, World!",
        isHidden: true
    )
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Button("Display Snackbar") {
                    $snackbarConfiguration.isHidden.wrappedValue.toggle()
                }.frame(alignment: .center)
                Spacer()
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
        .snackbar(configuration: $snackbarConfiguration)
    }
}

#Preview {
    ContentView()
}
