import SwiftUI

struct SettingsView: View {
    @Binding var isMenuShowing: Bool
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text(NSLocalizedString("settings_title", comment: "Settings"))
                .font(.title)
                .fontWeight(.bold)
            
            Text(NSLocalizedString("settings_coming_soon", comment: "Settings page coming soon..."))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(NSLocalizedString("settings_title", comment: "Settings"))
        .navigationBarItems(leading: HamburgerButton(isMenuShowing: $isMenuShowing))
    }
} 