# Quickfire

## Flutter on Steroids

Quickfire is a powerful Dart CLI tool that supercharges your Flutter project setup. With just a few commands, you can create a new Flutter project with all the essential features and configurations, allowing you to focus on building your app.

### Getting Started

1. **Installation:**

   ```bash
   pub global activate quickfire

### Project Customization

Quickfire guides you through the setup process to tailor your Flutter project according to your preferences.

- **Project Name:**
  - Enter a unique name for your Flutter project.

- **State Management:**
  - Choose between Bloc and Riverpod for efficient state management.

- **Authentication System:**
  - Select your preferred authentication system:
    - Firebase
    - Appwrite
    - Supabase

- **Onboarding Screen:**
  - Decide whether you want to include an onboarding screen in your app.

- **CI/CD Integration:**
  - Opt for Fastlane integration for seamless CI/CD.

### Project Structure

Quickfire generates a Flutter project with a simple, scalable, and clean codebase. The project structure is designed to enhance your development experience.

```plaintext
.
├── lib
│   ├── screens
│   │   ├── home_screen.dart
│   │   ├── onboarding_screen.dart   # (optional)
│   ├── blocs
│   │   ├── counter_bloc.dart        # (if Bloc selected)
│   │   ├── app_state_notifier.dart  # (if Riverpod selected)
│   ├── services
│   │   ├── authentication_service.dart
│   ├── main.dart
├── fastlane
│   ├── Fastfile
├── ...
