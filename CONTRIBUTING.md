# Contributing to Elite Tennis Ladder

Thank you for your interest in contributing to Elite Tennis Ladder! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Workflow](#development-workflow)
4. [Coding Standards](#coding-standards)
5. [Testing Guidelines](#testing-guidelines)
6. [Commit Message Guidelines](#commit-message-guidelines)
7. [Pull Request Process](#pull-request-process)

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## Getting Started

### Prerequisites

- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.0.0 or higher)
- Git
- A code editor (VS Code, Android Studio, or IntelliJ IDEA recommended)

### Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/elite_tennis_ladder.git
   cd elite_tennis_ladder
   ```

3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/dipan0saha/elite_tennis_ladder.git
   ```

4. Install dependencies:
   ```bash
   flutter pub get
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## Development Workflow

1. **Create a branch** for your feature or bug fix:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/bug-description
   ```

2. **Make your changes** following the coding standards

3. **Test your changes** thoroughly

4. **Commit your changes** with clear, descriptive messages

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request** from your fork to the main repository

## Coding Standards

### Dart/Flutter Style

- Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format .` before committing
- Run `flutter analyze` to check for issues

### Key Conventions

1. **Naming Conventions**:
   - Classes: `PascalCase`
   - Variables/functions: `camelCase`
   - Constants: `lowerCamelCase`
   - Files: `snake_case.dart`

2. **File Organization**:
   ```
   lib/
   ├── main.dart
   ├── theme/
   ├── screens/
   ├── widgets/
   ├── models/
   ├── services/
   └── utils/
   ```

3. **Imports**:
   - Dart imports first
   - Flutter imports second
   - Package imports third
   - Relative imports last
   - Alphabetically sorted within each group

4. **Widget Structure**:
   - Prefer `const` constructors when possible
   - Extract complex widgets into separate classes
   - Use meaningful widget names

### Code Quality

- Write self-documenting code with clear variable/function names
- Add comments for complex logic
- Keep functions small and focused (single responsibility)
- Avoid deep nesting (max 3 levels preferred)

## Testing Guidelines

### Writing Tests

1. **Unit Tests**: Test individual functions and classes
   ```dart
   test('description of what is being tested', () {
     // Arrange
     // Act
     // Assert
   });
   ```

2. **Widget Tests**: Test UI components
   ```dart
   testWidgets('description of widget behavior', (WidgetTester tester) async {
     // Build widget
     // Interact
     // Verify
   });
   ```

3. **Integration Tests**: Test complete user flows

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Test Coverage

- Aim for >80% code coverage
- All new features must include tests
- Bug fixes should include regression tests

## Commit Message Guidelines

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

```
feat(auth): add email/password authentication

Implements user signup and login using Supabase auth.

Closes #123
```

```
fix(ladder): correct ranking calculation after match

The swap logic was not properly handling ties.

Fixes #456
```

## Pull Request Process

1. **Update Documentation**: Ensure README and other docs reflect your changes

2. **Add Tests**: All code changes must include appropriate tests

3. **Run Quality Checks**:
   ```bash
   flutter format .
   flutter analyze
   flutter test
   ```

4. **Update CHANGELOG**: Add entry for your changes (if applicable)

5. **Fill PR Template**: Complete all sections of the pull request template

6. **Request Review**: Tag relevant reviewers

7. **Address Feedback**: Respond to review comments and make requested changes

8. **Squash Commits** (if requested): Keep git history clean

### PR Review Criteria

- Code follows project standards
- Tests pass and coverage is maintained
- Documentation is updated
- No merge conflicts
- Approved by at least one maintainer

## Questions?

If you have questions or need help:

1. Check existing issues and documentation
2. Join our discussion forum (if available)
3. Create an issue with the `question` label

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions

Thank you for contributing to Elite Tennis Ladder! 🎾
