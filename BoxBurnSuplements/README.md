# BoxBurnSuplements

BoxBurnSuplements is a modern iOS app for discovering, searching, and purchasing supplements, built with Swift, SwiftUI, Combine, and Clean Architecture principles.

## Features
- Browse and search supplements by category
- Favorites and cart management
- Amazon-like UI/UX with tab bar and side menu
- Dynamic category and supplement loading from JSON/mock backend
- Checkout flow and order summary
- Localization (PT-BR default, easy to extend)
- 80%+ unit test coverage using SwiftTesting

## Architecture
- **Clean Architecture**: Domain, Data, and Presentation layers
- **SOLID Principles**: Modular, testable, and maintainable code
- **Combine**: Reactive data flow
- **SwiftUI**: Declarative UI
- **Mock/Real Repository**: Easily swap between mock data and real backend

## Getting Started
1. Clone the repo
2. Open `BoxBurnSuplements.xcodeproj` in Xcode 15+
3. Run on iOS Simulator (iOS 17+ recommended)
4. To run tests: Product > Test (⌘U) or `xcodebuild test ...`

## Running Tests & Coverage
- Tests use [SwiftTesting](https://github.com/apple/swift-testing) (Swift 5.9+)
- Coverage: Enable in scheme, view in Xcode Test Navigator (pie chart)

## Localization
- All user-facing strings are localized (PT-BR default)
- Add more languages in `Resources/Localizable.strings`

## Contributing
- Fork, branch, and submit PRs
- Follow Clean Architecture and SOLID
- Add/maintain tests for new features

---
© 2025 Vitor Spessoto. MIT License. 