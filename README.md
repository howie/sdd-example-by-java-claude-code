# SDD Example - Java Project

A sample Java application demonstrating software development practices with Gradle, testing, and code quality checks.

## Prerequisites

- Java 17 or higher
- Git

## Building the Project

This project uses the Gradle wrapper, so you don't need to install Gradle separately.

### Build and Run Tests

```bash
./gradlew build
```

### Run the Application

```bash
./gradlew run
```

### Run Tests Only

```bash
./gradlew test
```

### Run Checkstyle (Code Quality)

```bash
./gradlew checkstyleMain checkstyleTest
```

## Development Setup

### Installing Git Hooks

To ensure code quality before pushing, install the pre-push hook:

```bash
cp hooks/pre-push .git/hooks/pre-push && chmod +x .git/hooks/pre-push
```

This hook will automatically run tests and Checkstyle checks before each push.

## CI/CD

This project uses GitHub Actions for continuous integration. On every push and pull request to the main branch, the following checks are run:

- Build the project
- Run all tests
- Run Checkstyle linting

## Project Structure

```
.
├── app/                        # Application source code
│   ├── src/
│   │   ├── main/java/         # Main application code
│   │   └── test/java/         # Test code
│   └── build.gradle           # Gradle build configuration
├── config/
│   └── checkstyle/            # Checkstyle configuration
├── hooks/                     # Git hooks
└── gradle/                    # Gradle wrapper files
```

## License

See [LICENSE](LICENSE) file for details.
