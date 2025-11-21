# Contributing to Bali Calendar App

Thank you for your interest in contributing to the Bali Calendar App! This project aims to preserve and promote Balinese Hindu cultural heritage through modern technology.

## 🙏 Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors. We value:
- Respect for Balinese Hindu traditions and cultural sensitivity
- Constructive feedback and collaboration
- Patience and understanding with all skill levels
- Focus on accuracy and cultural authenticity

## 🎯 How Can You Contribute?

### 1. Calendar Accuracy Verification
- Verify calendar calculations against traditional sources
- Cross-reference holy day dates with temple calendars
- Validate weton calculations with traditional experts
- Report any discrepancies in Saka or Pawukon calculations

### 2. Holy Days Database
- Add local village holy days (odalan)
- Contribute regional ceremony dates
- Provide descriptions and cultural context
- Verify existing holy day information

### 3. Algorithm Improvements
- Optimize calculation performance
- Improve accuracy of edge cases
- Enhance Dewasa Ayu logic
- Add new calendar features

### 4. Documentation
- Improve code documentation
- Add cultural explanations
- Translate documentation to Balinese/Indonesian
- Create user guides and tutorials

### 5. UI/UX Enhancements
- Improve user interface design
- Enhance accessibility features
- Add animations and transitions
- Optimize mobile experience

### 6. Testing
- Write unit tests for new features
- Add integration tests
- Perform manual testing on different devices
- Report bugs and issues

### 7. Translations
- Translate app to Balinese language
- Improve Indonesian translations
- Add English translations
- Localize cultural terms appropriately

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Git for version control
- Basic understanding of Balinese calendar systems (helpful but not required)

### Setting Up Development Environment

1. **Fork the repository**
   - Click the "Fork" button on GitHub
   - Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/bali-calendar.git
   cd bali-calendar
   ```

2. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/bali-calendar.git
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Verify installation**
   ```bash
   flutter doctor
   flutter test
   ```

## 📝 Development Workflow

### 1. Create a Branch
Always create a new branch for your work:
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `test/` - Test additions or modifications
- `refactor/` - Code refactoring

### 2. Make Your Changes

#### Code Style
- Follow Dart style guide: https://dart.dev/guides/language/effective-dart
- Use `flutter analyze` to check for issues
- Format code with `dart format .`
- Keep functions small and focused
- Add comments for complex logic
- Use meaningful variable names

#### Architecture Guidelines
This project follows Clean Architecture:
```
lib/
├── data/          # Data models and repositories
├── domain/        # Business logic and services
├── presentation/  # UI screens, widgets, and providers
└── core/          # Shared utilities and constants
```

- Keep business logic in `domain/services/`
- UI components in `presentation/`
- Data models in `data/models/`
- Shared utilities in `core/`

#### Testing Requirements
- Write tests for new features
- Ensure existing tests pass
- Aim for meaningful test coverage
- Test edge cases and special scenarios

Run tests:
```bash
# Run all tests
flutter test

# Run specific test file
dart run test/your_test_file.dart

# Run with coverage
flutter test --coverage
```

### 3. Commit Your Changes

Write clear, descriptive commit messages:
```bash
git add .
git commit -m "feat: add Galungan date calculation"
```

Commit message format:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `test:` - Test additions/modifications
- `refactor:` - Code refactoring
- `style:` - Code formatting
- `chore:` - Maintenance tasks

### 4. Keep Your Branch Updated
```bash
git fetch upstream
git rebase upstream/main
```

### 5. Push Your Changes
```bash
git push origin feature/your-feature-name
```

### 6. Create a Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Select your branch
4. Fill in the PR template:
   - **Title**: Clear, descriptive title
   - **Description**: What changes were made and why
   - **Related Issues**: Link any related issues
   - **Testing**: How you tested the changes
   - **Screenshots**: For UI changes

## 🔍 Pull Request Guidelines

### Before Submitting
- [ ] Code follows project style guidelines
- [ ] All tests pass (`flutter test`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] Code is properly formatted (`dart format .`)
- [ ] Documentation is updated if needed
- [ ] Commit messages are clear and descriptive

### PR Review Process
1. Maintainers will review your PR
2. Address any requested changes
3. Once approved, your PR will be merged
4. Your contribution will be acknowledged!

## 📚 Specific Contribution Areas

### Adding Holy Days

To add new holy days, edit `assets/data/holy_days.json`:

```json
{
  "id": "unique-id",
  "name": "Holy Day Name",
  "nameBalinese": "Nama Bali",
  "category": "major|tumpek|purnama|tilem|kajeng_kliwon|other",
  "description": "Description in English",
  "descriptionBalinese": "Deskripsi dalam Bahasa Bali",
  "date": "2025-03-15",
  "isRecurring": false,
  "sakaDate": {
    "year": 1947,
    "sasih": "Kasanga",
    "day": 15,
    "phase": "Penanggal"
  }
}
```

### Improving Algorithms

When modifying calendar algorithms:
1. Document the mathematical basis
2. Provide references to traditional sources
3. Add comprehensive tests
4. Verify against known dates
5. Update `doc/ALGORITHM_DOCUMENTATION.md`

### Cultural Accuracy

When contributing cultural content:
- Cite traditional sources when possible
- Consult with Balinese Hindu experts
- Use appropriate terminology
- Respect religious significance
- Provide context and explanations

## 🐛 Reporting Bugs

### Before Reporting
- Check if the issue already exists
- Verify it's reproducible
- Test on latest version

### Bug Report Template
```markdown
**Description**
Clear description of the bug

**Steps to Reproduce**
1. Go to '...'
2. Click on '...'
3. See error

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Screenshots**
If applicable

**Environment**
- Device: [e.g. Pixel 6]
- OS: [e.g. Android 13]
- App Version: [e.g. 1.0.0]
```

## 💡 Suggesting Features

### Feature Request Template
```markdown
**Feature Description**
Clear description of the feature

**Use Case**
Why is this feature needed?

**Proposed Solution**
How should it work?

**Alternatives Considered**
Other approaches you've thought about

**Cultural Context**
Any relevant Balinese cultural considerations
```

## 📖 Documentation Standards

### Code Documentation
```dart
/// Calculates the Pawukon date for a given Gregorian date.
///
/// The Pawukon calendar is a 210-day cycle used in Balinese Hindu tradition.
/// This method converts a Gregorian date to its corresponding position in
/// the Pawukon cycle.
///
/// Parameters:
///   - [date]: The Gregorian date to convert
///
/// Returns:
///   A [PawukonDate] object containing all cycle information
///
/// Example:
/// ```dart
/// final pawukon = service.getPawukonDate(DateTime(2025, 1, 15));
/// print(pawukon.wuku.name); // Outputs: "Sinta"
/// ```
PawukonDate getPawukonDate(DateTime date) {
  // Implementation
}
```

### README Updates
- Keep README.md up to date with new features
- Update progress indicators
- Add examples for new functionality
- Maintain accurate roadmap

## 🌟 Recognition

Contributors will be recognized in:
- GitHub contributors list
- App credits screen
- Release notes for significant contributions

## 📞 Getting Help

- **Questions**: Open a GitHub Discussion
- **Issues**: Create a GitHub Issue
- **Chat**: Join our community (if available)
- **Email**: Contact maintainers for sensitive matters

## 🙏 Cultural Sensitivity

This app deals with religious and cultural content. Please:
- Approach contributions with respect and humility
- Verify cultural accuracy with knowledgeable sources
- Use appropriate language and terminology
- Consider the spiritual significance of the content
- When in doubt, ask for guidance

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Om Swastyastu** 🙏

Thank you for helping preserve and promote Balinese Hindu cultural heritage!

---

<div align="center">
  <sub>Questions? Open an issue or discussion on GitHub</sub>
</div>
