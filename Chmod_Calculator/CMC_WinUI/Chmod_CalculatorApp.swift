import Foundation
import UWP
import WinAppSDK
import WindowsFoundation
import WinUI

@main
public class PreviewApp: SwiftApplication {

    let c = Calculator()
    var permissions = Permissions()

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

        // ############# Windows UI #############

        let layoutRoot = StackPanel()
        layoutRoot.orientation = .vertical

        // Values
        let valueGrid = Grid()
        let vg_row1 = RowDefinition()
        let vg_row2 = RowDefinition()
        let vg_row3 = RowDefinition()
        vg_row1.height = GridLength(value: 0, gridUnitType: .auto)
        vg_row2.height = GridLength(value: 0, gridUnitType: .auto)
        vg_row3.height = GridLength(value: 0, gridUnitType: .auto)
        
        valueGrid.rowDefinitions.append(vg_row1)
        valueGrid.rowDefinitions.append(vg_row2)
        valueGrid.rowDefinitions.append(vg_row3)

        let vg_col1 = ColumnDefinition()
        let vg_col2 = ColumnDefinition()
        let vg_col3 = ColumnDefinition()
        let vg_col4 = ColumnDefinition()
        vg_col1.width = GridLength(value: 0, gridUnitType: .auto)
        vg_col2.width = GridLength(value: 0, gridUnitType: .auto)
        vg_col3.width = GridLength(value: 0, gridUnitType: .auto)
        vg_col4.width = GridLength(value: 0, gridUnitType: .auto)

        valueGrid.columnDefinitions.append(vg_col1)
        valueGrid.columnDefinitions.append(vg_col2)
        valueGrid.columnDefinitions.append(vg_col3)
        valueGrid.columnDefinitions.append(vg_col4)

        // Increment/decrement buttons
        let btn_specialUp = Button()
        let btn_specialDown = Button()
        let btn_userUp = Button()
        let btn_userDown = Button()
        let btn_groupUp = Button()
        let btn_groupDown = Button()
        let btn_otherUp = Button()
        let btn_otherDown = Button()

        // Button icons
        let sym_specialUp = FontIcon()
        sym_specialUp.glyph = "\u{E70E}"
        let sym_specialDown = FontIcon()
        sym_specialDown.glyph = "\u{E70D}"
        let sym_userUp = FontIcon()
        sym_userUp.glyph = "\u{E70E}"
        let sym_userDown = FontIcon()
        sym_userDown.glyph = "\u{E70D}"
        let sym_groupUp = FontIcon()
        sym_groupUp.glyph = "\u{E70E}"
        let sym_groupDown = FontIcon()
        sym_groupDown.glyph = "\u{E70D}"
        let sym_otherUp = FontIcon()
        sym_otherUp.glyph = "\u{E70E}"
        let sym_otherDown = FontIcon()
        sym_otherDown.glyph = "\u{E70D}"

        btn_specialUp.content = sym_specialUp
        btn_specialDown.content = sym_specialDown
        btn_userUp.content = sym_userUp
        btn_userDown.content = sym_userDown
        btn_groupUp.content = sym_groupUp
        btn_groupDown.content = sym_groupDown
        btn_otherUp.content = sym_otherUp
        btn_otherDown.content = sym_otherDown

        // Common button styles
        let btns = [btn_specialUp, btn_specialDown, btn_userUp, btn_userDown, btn_groupUp, btn_groupDown, btn_otherUp, btn_otherDown]
        btns.forEach { b in
            b.horizontalAlignment = .center
            b.verticalAlignment = .center
            // b.padding = Thickness(left: 5, top: 5, right: 5, bottom: 5)
            b.margin = Thickness(left: 5, top: 5, right: 5, bottom: 5)
        }

        // Set button positions
        Grid.setColumn(btn_specialUp, 0)
        Grid.setColumn(btn_specialDown, 0)
        Grid.setColumn(btn_userUp, 1)
        Grid.setColumn(btn_userDown, 1)
        Grid.setColumn(btn_groupUp, 2)
        Grid.setColumn(btn_groupDown, 2)
        Grid.setColumn(btn_otherUp, 3)
        Grid.setColumn(btn_otherDown, 3)

        Grid.setRow(btn_specialUp, 0)
        Grid.setRow(btn_userUp, 0)
        Grid.setRow(btn_groupUp, 0)
        Grid.setRow(btn_otherUp, 0)
        Grid.setRow(btn_specialDown, 2)
        Grid.setRow(btn_userDown, 2)
        Grid.setRow(btn_groupDown, 2)
        Grid.setRow(btn_otherDown, 2)


        // Textboxes
        let tb_special = TextBox()
        let tb_user = TextBox()
        let tb_group = TextBox()
        let tb_other = TextBox()

        // Common Textbox styles
        let tbs = [tb_special, tb_user, tb_group, tb_other]
        tbs.forEach { tb in
            tb.textAlignment = .center
            tb.margin = Thickness(left: 2.5, top: 0, right: 2.5, bottom: 0)
            tb.text = "0"
        }

        // Textbox positions
        Grid.setRow(tb_special, 1)
        Grid.setRow(tb_user, 1)
        Grid.setRow(tb_group, 1)
        Grid.setRow(tb_other, 1)

        Grid.setColumn(tb_special, 0)
        Grid.setColumn(tb_user, 1)
        Grid.setColumn(tb_group, 2)
        Grid.setColumn(tb_other, 3)

        // Texbox handlers
        let numOnlyHandler: (TextBox?, TextBoxBeforeTextChangingEventArgs?) -> Void = { tb, event in 
            guard let event else { return }

            let notNumRegex = try? Regex("[^0-7]")
            if let notNumRegex, event.newText.contains(notNumRegex) {
                event.cancel = true
            }

            // guard let tb else { return }
            // let newRes: String = tb.text + event.newText
            if event.newText.count >= 2 {
                // print("TOO BIG")
                // let start = event.newText.startIndex
                // let oldRange = event.newText.firstRange(of: tb.text) ?? Range(uncheckedBounds: (lower: start, upper: start))
                // tb.text = String(event.newText[start..<oldRange.lowerBound] + event.newText[oldRange.upperBound...])

                event.cancel = true
            }
        }

        let txtChangedHandler_special: (Any?, TextChangedEventArgs?) -> Void = { [weak self] tb, _ in
            guard let tb = tb as? TextBox else { return }
            guard let num = Int(tb.text) else { return }

            self?.permissions.special.value = num
        }
        let txtChangedHandler_user: (Any?, TextChangedEventArgs?) -> Void = { [weak self] tb, _ in
            guard let tb = tb as? TextBox else { return }
            guard let num = Int(tb.text) else { return }

            self?.permissions.user.value = num
        }
        let txtChangedHandler_group: (Any?, TextChangedEventArgs?) -> Void = { [weak self] tb, _ in
            guard let tb = tb as? TextBox else { return }
            guard let num = Int(tb.text) else { return }

            self?.permissions.group.value = num
        }
        let txtChangedHandler_other: (Any?, TextChangedEventArgs?) -> Void = { [weak self] tb, _ in
            guard let tb = tb as? TextBox else { return }
            guard let num = Int(tb.text) else { return }

            self?.permissions.other.value = num
        }

        tb_special.beforeTextChanging.addHandler(numOnlyHandler)
        tb_user.beforeTextChanging.addHandler(numOnlyHandler)
        tb_group.beforeTextChanging.addHandler(numOnlyHandler)
        tb_other.beforeTextChanging.addHandler(numOnlyHandler)
        tb_special.textChanged.addHandler(txtChangedHandler_special)
        tb_user.textChanged.addHandler(txtChangedHandler_user)
        tb_group.textChanged.addHandler(txtChangedHandler_group)
        tb_other.textChanged.addHandler(txtChangedHandler_other)


        // Configure button actions
        btn_specialUp.click.addHandler { _, _ in
            let num = Int(tb_special.text)
            guard let num else { return }

            if num == 7 { return }
            tb_special.text = String(num + 1)
        }
        btn_specialDown.click.addHandler { _, _ in
            let num = Int(tb_special.text)
            guard let num else { return }

            if num == 0 { return }
            tb_special.text = String(num - 1)
        }
        btn_userUp.click.addHandler { _, _ in
            let num = Int(tb_user.text)
            guard let num else { return }

            if num == 7 { return }
            tb_user.text = String(num + 1)
        }
        btn_userDown.click.addHandler { _, _ in
            let num = Int(tb_user.text)
            guard let num else { return }

            if num == 0 { return }
            tb_user.text = String(num - 1)
        }
        btn_groupUp.click.addHandler { _, _ in
            let num = Int(tb_group.text)
            guard let num else { return }

            if num == 7 { return }
            tb_group.text = String(num + 1)
        }
        btn_groupDown.click.addHandler { _, _ in
            let num = Int(tb_group.text)
            guard let num else { return }

            if num == 0 { return }
            tb_group.text = String(num - 1)
        }
        btn_otherUp.click.addHandler { _, _ in
            let num = Int(tb_other.text)
            guard let num else { return }

            if num == 7 { return }
            tb_other.text = String(num + 1)
        }
        btn_otherDown.click.addHandler { _, _ in
            let num = Int(tb_other.text)
            guard let num else { return }

            if num == 0 { return }
            tb_other.text = String(num - 1)
        }

       
        // Add buttons and textboxes to grid
        valueGrid.children.append(btn_specialUp)
        valueGrid.children.append(btn_specialDown)
        valueGrid.children.append(btn_userUp)
        valueGrid.children.append(btn_userDown)
        valueGrid.children.append(btn_groupUp)
        valueGrid.children.append(btn_groupDown)
        valueGrid.children.append(btn_otherUp)
        valueGrid.children.append(btn_otherDown)
        valueGrid.children.append(tb_special)
        valueGrid.children.append(tb_user)
        valueGrid.children.append(tb_group)
        valueGrid.children.append(tb_other)

        window.content = valueGrid
    }
}
