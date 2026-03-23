
import SwiftUI

struct Snackbar: View {
    struct Configuration {
        var message: String
        var action: (() -> Void)?
        var actionName: String?
        var isHidden: Bool
    }

    @State private var opacity = 0.0
    @Binding private var isHidden: Bool

    private let presentingView: AnyView

    private var message: String
    private var action: (() -> Void)?
    private var actionName: String?

    init<Presenting>(
        presentingView: Presenting,
        message: String,
        action: (() -> Void)? = nil,
        actionName: String? = nil,
        isHidden: Binding<Bool>
    ) where Presenting: View {
        self.presentingView = AnyView(presentingView)
        self.message = message
        self.action  = action
        self.actionName  = actionName
        _isHidden = isHidden
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                presentingView
                VStack {
                    Spacer()
                    if !isHidden {
                        GroupBox {
                            HStack {
                                Text(message)
                                    .frame(width: geometry.size.width * 0.7, height: 50)
                                    .foregroundColor(.black)

                                if let action = action, let actionName = actionName {
                                    Button(actionName) {
                                        action()
                                        hiddenWithAnimation()
                                    }
                                    .frame(width: geometry.size.width * 0.2, height: 25)
                                }
                            }
                        }
                        .frame(width: geometry.size.width * 0.9, height: 50)
                        .compositingGroup()
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .offset(x: 0, y: -20)
                        .background(.white)
                        .opacity(opacity)
                        .animation(.linear, value: opacity)
                        .onAppear {
                            hiddenWithAnimation()
                        }
                    }
                }
            }
        }
    }

    private func hiddenWithAnimation() {
        opacity = 1.0
        Task {
            try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
            withAnimation {
                isHidden = true
                opacity = 0.0
            }
        }
    }

}

extension View {
    func snackbar(configuration: Binding<Snackbar.Configuration>) -> some View {
        Snackbar(
            presentingView: self,
            message: configuration.wrappedValue.message,
            action: configuration.wrappedValue.action,
            actionName: configuration.wrappedValue.actionName,
            isHidden: configuration.isHidden
        )
    }
}

#Preview {
    @Previewable @State var snackbarConfiguration = Snackbar.Configuration(
        message: "Hello, World!",
        action: {
            print("Action")
        },
        actionName: "Cancel",
        isHidden: true
    )

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
