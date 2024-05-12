import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

@main
public class PreviewApp: SwiftApplication {

    let c = Calculator()

    /// A required initializer for the application. Non-UI setup for your application can be done here.
    /// Subscribing to unhandledException is a good place to handle any unhandled exceptions that may occur
    /// in your application.
    public required init() {
        super.init()
        unhandledException.addHandler { (_, args:UnhandledExceptionEventArgs!) in
            print("Unhandled exception: \(args.message)")
        }
    }

    /// onShutdown is called once Application.start returns. This is a good place to do any cleanup
    /// that is necessary for your application before it terminates.
    override public func onShutdown() {    }

    /// onLaunched is called when the application is launched. 
    /// This is where the window is configured and where the initial UI can be created
    override public func onLaunched(_ args: WinUI.LaunchActivatedEventArgs) {
        let window = Window()
        window.title = "WinUI3AnimationsPreview_EDITED"

        try! window.activate()

        let btn = Button()
        btn.content = "A test button"
        btn.click.addHandler { [weak self] _, args in
            print("Button Clicked!")
            print(self?.c.calculate() ?? "Failed to call calculate")
        }

        let panel = StackPanel()
        panel.orientation = .vertical
        panel.spacing = 10
        panel.horizontalAlignment = .center
        panel.verticalAlignment = .center
        panel.children.append(btn)
        window.content = panel
    }
}
