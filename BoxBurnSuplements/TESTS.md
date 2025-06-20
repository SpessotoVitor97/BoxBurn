# Test Specifications

## Philosophy
- All business logic, data, and UI components are covered by unit tests.
- Target: 80%+ code coverage, with focus on critical paths and edge cases.
- Tests are fast, isolated, and use mocks where appropriate.

## Structure
- Tests mirror the main codebase structure:
  - `Domain/`: Use cases, models, business logic
  - `Data/`: Repositories, services, data loaders
  - `Presentation/`: View models, SwiftUI components, extensions

## Coverage
- **Domain**: Use cases (favorites, cart, fetch), model equality/hash, protocol conformance
- **Data**: Mock and real repositories, backend service, data loader
- **Presentation**: View models (state, filtering, actions), SwiftUI view instantiation, extensions

## Framework
- [SwiftTesting](https://github.com/apple/swift-testing) (Swift 5.9+)
- Async/await and Combine publisher support

## Running Tests
- In Xcode: Product > Test (⌘U)
- Or via CLI: `xcodebuild test -scheme BoxBurnSuplements ...`
- Coverage: Enable in scheme, view in Xcode Test Navigator

## Example Test Cases
- Adding/removing favorites and cart items
- Filtering supplements by category
- Loading mock data from JSON
- UI view instantiation and state changes 