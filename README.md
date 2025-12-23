# Elite Tennis Ladder 🎾

[![Flutter CI](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/dipan0saha/elite_tennis_ladder/actions/workflows/flutter-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A modern, mobile-first tennis ladder application built with Flutter and Supabase. Elite Tennis Ladder provides an ad-free, intuitive platform for managing tennis ladder competitions with real-time ranking updates, challenge systems, and match tracking.

## ✨ Features

- 🎯 **Position-Based Challenge System**: Challenge players within allowed ranking positions
- 📊 **Real-Time Rankings**: Automatic ranking updates based on match results
- 🏆 **Match Management**: Comprehensive score reporting and verification
- 👤 **Player Profiles**: Detailed stats, match history, and achievements
- 🔔 **Push Notifications**: Stay updated on challenges, matches, and rankings
- 🌓 **Dark Mode**: Full support for light and dark themes
- 📱 **Mobile-First**: Optimized for iOS, Android, and web
- 🔒 **Secure Authentication**: Email/password auth with role-based access

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.16.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (3.0.0 or higher)
- A [Supabase](https://supabase.com) account
- Code editor (VS Code, Android Studio, or IntelliJ IDEA)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/dipan0saha/elite_tennis_ladder.git
   cd elite_tennis_ladder
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` and add your Supabase credentials:
   ```
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Set up Supabase**
   - Create a new project at [supabase.com](https://supabase.com)
   - See [supabase/README.md](supabase/README.md) for detailed setup instructions

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| Android  | ✅ Supported |
| iOS      | ✅ Supported |
| Web      | ✅ Supported |
| Desktop  | 🔜 Planned |

## 🧪 Testing

Run tests with:
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 🏗️ Project Structure

```
elite_tennis_ladder/
├── lib/
│   ├── main.dart              # App entry point
│   ├── theme/                 # Custom theme and colors
│   ├── screens/               # UI screens (coming soon)
│   ├── widgets/               # Reusable widgets (coming soon)
│   ├── models/                # Data models (coming soon)
│   ├── services/              # Business logic & API (coming soon)
│   └── utils/                 # Utilities (coming soon)
├── test/                      # Test files
├── supabase/                  # Database migrations
├── docs/                      # Documentation
├── .github/                   # GitHub workflows and templates
└── pubspec.yaml              # Dependencies
```

## 🎨 Design System

Elite Tennis Ladder follows a comprehensive design system:

- **Primary Color**: Tennis Green (#2E7D32)
- **Secondary Color**: Court Blue (#1976D2)
- **Typography**: Roboto font family
- **Components**: Material Design 3
- **Spacing**: 8px base grid system

See [docs/design/DESIGN_SYSTEM.md](docs/design/DESIGN_SYSTEM.md) for complete specifications.

## 📖 Documentation

- [Tech Stack Evaluation](docs/tech_stack_evaluation/README.md)
- [Design System](docs/design/DESIGN_SYSTEM.md)
- [UI Mockups](docs/design/UI_MOCKUPS.md)
- [Wireframes](docs/design/wireframes/README.md)
- [Requirements](docs/requirements/README.md)
- [Competitor Analysis](docs/competitor_feature_parity/README.md)
- [Supabase Setup](supabase/README.md)

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:

- Code of conduct
- Development workflow
- Coding standards
- Testing guidelines
- Pull request process

## 📋 Roadmap

### Current Sprint (Epic 3: Project Setup)
- [x] Flutter project initialization
- [x] Supabase configuration
- [x] CI/CD setup

### Upcoming Sprints
- Epic 4: Authentication & User Management
- Epic 5: Ladder Management
- Epic 6: Challenge System
- Epic 7: Ranking & Logic Algorithms

See [docs/epics/Epics.csv](docs/epics/Epics.csv) for the complete roadmap.

## 🛠️ Built With

- [Flutter](https://flutter.dev/) - UI framework
- [Dart](https://dart.dev/) - Programming language
- [Supabase](https://supabase.com/) - Backend as a Service
  - PostgreSQL database
  - Authentication
  - Real-time subscriptions
  - Storage
- [Material Design 3](https://m3.material.io/) - Design system

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Dipan Saha** - *Initial work* - [@dipan0saha](https://github.com/dipan0saha)

See also the list of [contributors](https://github.com/dipan0saha/elite_tennis_ladder/contributors) who participated in this project.

## 🙏 Acknowledgments

- Inspired by traditional tennis ladder systems
- Built with Flutter's amazing hot reload and Material Design
- Powered by Supabase's real-time capabilities

## 📞 Support

- 📧 Email: support@elitetennisladder.com (placeholder)
- 🐛 Issues: [GitHub Issues](https://github.com/dipan0saha/elite_tennis_ladder/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/dipan0saha/elite_tennis_ladder/discussions)

---

Made with ❤️ and ☕ by the Elite Tennis Ladder team
