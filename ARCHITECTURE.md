# Architecture Documentation

## Overview

QR Code Pro follows **Clean Architecture** principles, ensuring separation of concerns, testability, and maintainability. The application is structured in layers, with dependencies pointing inward.

## Architecture Layers

```
┌─────────────────────────────────────┐
│       Presentation Layer            │
│   (UI, Widgets, State Management)   │
└───────────────┬─────────────────────┘
                │
┌───────────────▼─────────────────────┐
│         Domain Layer                │
│  (Business Logic, Use Cases,        │
│   Repository Interfaces)            │
└───────────────┬─────────────────────┘
                │
┌───────────────▼─────────────────────┐
│          Data Layer                 │
│  (Repositories, Data Sources,       │
│   Models, External APIs)            │
└─────────────────────────────────────┘
```

## Layer Details

### 1. Presentation Layer (`lib/presentation/`)

**Responsibility**: Handle user interface and user interactions

**Components**:
- **Pages**: Full-screen views (HomePage, ScannerPage, GeneratorPage, etc.)
- **Widgets**: Reusable UI components
- **Providers**: Riverpod state management

**Key Principles**:
- Pages are stateless when possible
- Business logic delegated to providers
- Widgets are small and focused
- No direct dependency on data sources

**Example Structure**:
```dart
// Provider (State Management)
final qrProvider = StateNotifierProvider<QRNotifier, QRState>((ref) {
  final repository = ref.watch(qrRepositoryProvider);
  return QRNotifier(repository);
});

// Page (UI)
class ScannerPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qrProvider);
    // UI logic only
  }
}
```

### 2. Domain Layer (`lib/domain/`)

**Responsibility**: Business logic and rules

**Components**:
- **Entities**: Core business objects
- **Repository Interfaces**: Contracts for data operations
- **Use Cases**: Specific business operations

**Key Principles**:
- No dependencies on outer layers
- Pure Dart code (no Flutter dependencies)
- Defines contracts for data layer
- Contains business validation rules

**Example**:
```dart
// Repository Interface
abstract class QRRepository {
  Future<Either<Failure, void>> saveQRCode(QRCodeModel qrCode);
  Future<Either<Failure, List<QRCodeModel>>> getAllQRCodes();
}
```

### 3. Data Layer (`lib/data/`)

**Responsibility**: Data persistence and external communication

**Components**:
- **Models**: Data transfer objects with serialization
- **Repositories**: Implementation of domain interfaces
- **Data Sources**: Direct interaction with storage/APIs

**Key Principles**:
- Implements domain repository interfaces
- Handles data serialization/deserialization
- Manages caching strategies
- Isolates external dependencies

**Example**:
```dart
class QRRepositoryImpl implements QRRepository {
  final LocalStorageService _localStorage;

  @override
  Future<Either<Failure, void>> saveQRCode(QRCodeModel qrCode) async {
    try {
      await _localStorage.saveQRCode(qrCode);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
```

### 4. Core Layer (`lib/core/`)

**Responsibility**: Shared utilities and configurations

**Components**:
- **Constants**: App-wide constant values
- **Errors**: Custom exceptions and failures
- **Theme**: Material Design configuration
- **Utils**: Helper functions and validators
- **Logging**: Centralized logging system

## State Management

### Riverpod Architecture

```dart
// Service Provider (Singleton)
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

// Repository Provider
final qrRepositoryProvider = Provider<QRRepositoryImpl>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return QRRepositoryImpl(localStorage);
});

// State Notifier Provider
final qrProvider = StateNotifierProvider<QRNotifier, QRState>((ref) {
  final repository = ref.watch(qrRepositoryProvider);
  return QRNotifier(repository);
});
```

**Benefits**:
- Compile-time safety
- Easy testing with provider overrides
- Automatic disposal
- DevTools integration

## Error Handling

### Failure vs Exception Pattern

**Exceptions** (Data Layer):
```dart
class CacheException implements Exception {
  final String message;
  final String? code;

  const CacheException({required this.message, this.code});
}
```

**Failures** (Domain Layer):
```dart
class CacheFailure extends Failure {
  const CacheFailure({required String message, String? code})
      : super(message: message, code: code);
}
```

**Usage with Either**:
```dart
Future<Either<Failure, Data>> fetchData() async {
  try {
    final data = await dataSource.getData();
    return Right(data);
  } on Exception catch (e) {
    return Left(CacheFailure(message: e.toString()));
  }
}
```

## Data Flow

### Scanning QR Code

```
User Action (Scan)
    ↓
ScannerPage (UI)
    ↓
QRNotifier (State Management)
    ↓
QRRepository (Domain Interface)
    ↓
QRRepositoryImpl (Data Implementation)
    ↓
LocalStorageService (Data Source)
    ↓
Hive Database
```

### Reading History

```
User Action (View History)
    ↓
HistoryPage (UI)
    ↓
ref.watch(qrProvider)
    ↓
QRNotifier loads data
    ↓
QRRepository.getAllQRCodes()
    ↓
LocalStorageService.getAllQRCodes()
    ↓
Hive Box Query
    ↓
List<QRCodeModel> returned
    ↓
UI Updates via StateNotifier
```

## Dependency Injection

All dependencies are managed through Riverpod providers:

```dart
// Define providers in a hierarchical manner
final storageProvider = Provider<LocalStorageService>(...);
final repositoryProvider = Provider<QRRepository>(...);
final notifierProvider = StateNotifierProvider<QRNotifier, QRState>(...);

// Consume in widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notifierProvider);
    // Use state
  }
}
```

## Testing Strategy

### Unit Tests
- Test business logic in isolation
- Mock dependencies with Mockito
- Test all edge cases

### Widget Tests
- Test UI components
- Verify user interactions
- Test state updates

### Integration Tests
- Test complete user flows
- Verify data persistence
- Test navigation

**Example**:
```dart
void main() {
  late QRNotifier notifier;
  late MockQRRepository mockRepository;

  setUp(() {
    mockRepository = MockQRRepository();
    notifier = QRNotifier(mockRepository);
  });

  test('saveQRCode updates state correctly', () async {
    when(mockRepository.saveQRCode(any))
        .thenAnswer((_) async => const Right(null));

    final result = await notifier.saveQRCode(testQRCode);

    expect(result, true);
    verify(mockRepository.saveQRCode(testQRCode)).called(1);
  });
}
```

## Performance Optimization

### 1. State Management
- Only rebuild affected widgets
- Use `select` for granular updates
- Dispose resources properly

### 2. Storage
- Lazy loading for large lists
- Indexed Hive boxes for fast queries
- Background save operations

### 3. UI
- `const` constructors where possible
- ListView.builder for long lists
- Image caching and optimization

## Security Considerations

### 1. Input Validation
- Validate all user input
- Sanitize QR code data
- Check for malicious patterns

### 2. Data Storage
- Encrypt sensitive data
- Use Hive with encryption
- Secure shared preferences

### 3. Permissions
- Request minimum necessary permissions
- Handle permission denials gracefully
- Explain permission usage to users

## Future Enhancements

### Potential Improvements
1. **Cloud Sync** - Add Firebase backend for cross-device sync
2. **Batch Operations** - Generate multiple QR codes at once
3. **Analytics** - Add Firebase Analytics for usage tracking
4. **ML Integration** - Image recognition for QR codes
5. **Export Options** - PDF, CSV export for bulk codes
6. **Templates** - Pre-made QR code templates
7. **API Integration** - QR code shortening services

### Scalability Considerations
- Repository pattern allows easy backend addition
- Clean architecture supports feature additions
- Provider-based DI enables easy testing
- Modular structure allows team collaboration

## Best Practices

### Code Style
- Follow Dart style guide
- Use `very_good_analysis` linting
- Document public APIs
- Keep functions small and focused

### Git Workflow
- Feature branches
- Conventional commits
- Pull request reviews
- CI/CD integration

### Documentation
- README for project overview
- ARCHITECTURE for design decisions
- Code comments for complex logic
- API documentation with dartdoc

## Conclusion

This architecture provides:
- ✅ **Maintainability** - Easy to modify and extend
- ✅ **Testability** - All layers can be tested independently
- ✅ **Scalability** - Can grow without major refactoring
- ✅ **Flexibility** - Easy to swap implementations
- ✅ **Team Collaboration** - Clear boundaries and responsibilities
