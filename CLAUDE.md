This documents how `e_chat_app` is actually built today, so new code matches existing patterns instead of introducing new ones. Where the codebase itself is inconsistent, that's stated directly below — treat it as ground truth over generic Flutter/Dart conventions or the aspirational sketch in `README.md`.

Sections marked **(not set up yet)** describe rules for new work that need a one-time setup first — see [One-Time Setup](#one-time-setup-not-set-up-yet).

## Golden Rules

- **Clarity over complexity.** Pick the simplest solution that works. Someone reading it later should understand it without an explanation. No abstractions, base classes or generics for a single use case.
- **Every new feature or logic change ships with tests**, and `flutter test` must pass in full (not just the new tests) before the work is done. See Testing.
- **No secrets in the app.** Anything bundled in the app (code, `.env`, `--dart-define`) is readable by anyone with the APK/IPA. Secrets live server-side only. See Security.
- **Minimize rebuilds.** `StatelessWidget` + `const` by default, `BlocBuilder`/`BlocSelector` wrapped around the smallest possible subtree. See UI & Performance.
- **Reuse before creating.** Check `lib/core/widgets/`, `features/<feature>/ui/widgets/`, `features/*/shared/widgets/` and the Flutter SDK before building a widget. Change behavior in one place, not in copies.
- State management is Cubit-only (`flutter_bloc`'s `Cubit<T>`). `Bloc` is never used — don't introduce it.
- Every Cubit is registered with `getIt.registerFactory<XCubit>()` in `lib/core/di/injection_container.dart`, then provided via `BlocProvider`/`MultiBlocProvider` inside the matching `case` in `lib/core/routing/app_router.dart`. That's the only wiring point — there is no app-wide provider in `main.dart`.
- Navigate via the `BuildContext` extensions in `lib/core/helper/extenstions.dart` (`context.pushNamed`, `.pushReplacementNamed`, `.pushNamedAndRemoveUntil`, `.pop()`), not raw `Navigator.of(context)` — except popping a locally-opened dialog/modal sheet with a result value, which uses `Navigator.of(context).pop(value)` directly (see `country_picker.dart`).
- Colors and text styles always come from `Theme.of(context).extension<AppTextTheme>()!` / `.extension<AppSemanticColors>()!`. Sizes always use `flutter_screenutil` (`.w`, `.h`, `.r`). Never hardcode either.
- New simple Cubits report errors with a `UiError? error` field + `listenWhen: (a, b) => a.error != b.error` (see State Management → Error Handling). Multi-stage async flows (OTP-style) use the sealed event-stream pattern instead. Don't use the old `errorMessage` + `snackBarEventId` counter idiom in new code.
- **Never use code generation.** No `freezed`, `json_serializable`, `retrofit`, `build_runner`, or any package that needs generated `.g.dart`/`.freezed.dart` files — now or later. Hand-write `fromJson`/`toJson`/`copyWith` in plain Dart classes (see Entities & JSON). `dio`, `easy_localization`, `intl` are also declared but unused — don't reach for them; use direct `SupabaseClient` calls like the rest of the codebase.
- **`core/` is only for code used by several features.** Anything owned by one feature (or shown in one place, like the bottom nav bar) lives in a feature. See [Where Does New Code Go?](#where-does-new-code-go). Never create a `core/utils/` folder.
- Don't silently "fix" existing typos (`onbording`, `OTPEven`, `extenstions.dart`, `navgiateTo`, etc.) as a drive-by inside unrelated work, and don't imitate them in new identifiers either.
- Don't mass-refactor `onbording/`/`splash/` to match the target feature shape in this doc just because they're inconsistent with it — only new features need to follow it.

## Tech Stack

**Actually wired up:** `flutter_bloc` (Cubit), `get_it`, `supabase_flutter`, `flutter_dotenv`, `shared_preferences`, `flutter_screenutil`, `google_fonts`, `flutter_svg`, `image_picker`, `phone_numbers_parser`, `country_flags_pro`, `cached_network_image` (chat avatars).

**Declared in `pubspec.yaml`, zero real usage in `lib/` — dormant, not conventions:** `freezed` / `freezed_annotation`, `json_annotation` / `json_serializable`, `dio`, `retrofit` / `retrofit_generator`, `pretty_dio_logger`, `easy_localization`, `intl`, `flutter_native_splash`. No `build_runner` dev-dependency and no `.g.dart`/`.freezed.dart` files exist anywhere — and that's intentional: **code generation is banned in this project.** Never add `build_runner` or suggest running it.

`environment: sdk: ^3.6.0` in `pubspec.yaml` is a stale floor — `pubspec.lock` actually resolves `dart >=3.10.0` / `flutter >=3.38.0`. Modern Dart 3 syntax (`sealed class`, pattern-matching `switch`, `abstract interface class`) is already in active use — don't self-restrict to older syntax.

Dev dependencies today: `flutter_test`, `flutter_lints`, `bloc_test`, `mocktail`. `analysis_options.yaml` is stock `flutter_lints` with all custom rules commented out.

**Planned additions (not set up yet):** `flutter_secure_storage` (for the auth session).

## One-Time Setup (not set up yet)

These are deliberate tasks, done once. Until they're done, the related rules below can't be followed — say so instead of working around it.

1. **Secure session storage:** add `flutter_secure_storage`, create `SecureSessionStorage` (see Security → Tokens), and pass it to `Supabase.initialize` in `main.dart`. Users will be logged out once after this ships (the old session lived in SharedPreferences).
2. **Remove codegen deps (optional cleanup):** delete `freezed`, `freezed_annotation`, `json_annotation`, `json_serializable`, `retrofit`, `retrofit_generator` from `pubspec.yaml` so nobody reaches for them by accident.
3. **Secrets hygiene:** confirm `.env` is in `.gitignore` (`git check-ignore .env` prints `.env`), and commit a `.env.example` with the same keys and empty values.

## Architecture at a Glance

```
lib/
├── main.dart              # bootstrap (see below)
├── e_chat_app.dart        # ScreenUtilInit > MaterialApp(onGenerateRoute: AppRouter.generateRoute)
├── core/
│   ├── di/                # injection_container.dart — setupAppInstances(), single flat function
│   ├── helper/            # app_config.dart (env), extenstions.dart [sic] (BuildContext nav), ui_error.dart, api_logger.dart — multi-feature helpers only
│   ├── local/             # LocalStore abstraction (SharedPreferences) + a full mini feature-shaped slice for country codes
│   ├── routing/           # app_router.dart (switch on route name), routes.dart (Routes string constants)
│   ├── theme/             # ThemeExtension pattern: AppTextTheme, AppSemanticColors, AppColors, AppGradients, AppFontWeight
│   └── widgets/           # truly cross-feature primitives only (buttons, checkbox, clickable text, countdown timer)
└── features/
    ├── auth/              # largest feature; login/register sub-flows + shared/ steps
    ├── bottom_nav/        # app shell: AppBottomNavBar only (no data/domain)
    ├── chats/             # cleanest example of the target shape — copy this one (see below)
    ├── onbording/         # [sic] — lighter, doesn't fully match the target shape
    └── splash/            # flattest — no data/domain layers, borrows other features' repositories directly
```

Boot sequence (`lib/main.dart`, exact order):
```dart
WidgetsFlutterBinding.ensureInitialized();
await dotenv.load(fileName: ".env");
await AppConfig.initialize();
await Supabase.initialize(url: AppConfig.supabaseUrl, anonKey: AppConfig.supabaseAnonKey);
await setupAppInstances();
runApp(EChatApp(appRouter: AppRouter()));
```
No global `MultiBlocProvider`, no `runZonedGuarded`/`FlutterError.onError`, no orientation lock, no localization wrapper — despite `easy_localization` being a dependency.

`README.md`'s `features/home/` folder sketch doesn't match any real feature — this file is the source of truth for structure, not the README.

## Feature Module Shape (Target Pattern)

New features should follow the shape of `features/chats/` (the cleanest existing feature):
```
features/<feature>/
├── data/
│   └── <name>_repository_impl.dart      # implements the domain contract, talks to SupabaseClient/LocalStore directly
├── domain/
│   ├── entities/                        # plain Dart classes with hand-written fromJson/toJson — no codegen
│   └── repo/
│       └── <name>_repository.dart       # abstract interface class <Name>Repository { ... }
└── ui/
    ├── <name>_screen.dart               # registered against a Route
    ├── <name>_view.dart                 # (optional) sub-section swapped via IndexedStack/switch, not routed
    ├── logic/
    │   ├── <name>_cubit.dart
    │   └── <name>_state.dart
    ├── widgets/                         # widgets used only by this feature
    └── helper/                          # helpers used only by this feature (e.g. chat_time_format.dart)
```
Features with several sub-flows (auth: login + register) add a `shared/` folder for widgets/logic the sub-flows share.

Reality check — this is a target for *new* work, not a retroactive rule:
- `auth/` itself duplicates `logic/`+`ui/` per sub-flow (`login/ui`, `register/ui`, `auth/ui/logic`, `shared/logic/<step>/`) rather than one flat pair.
- `onbording/` has a typo'd `date/` folder instead of `data/`.
- `splash/` skips `data`/`domain` entirely and borrows `OnboardingRepository`/`AuthRepository` directly — cross-feature domain dependencies like this are fine.

No use-case/interactor layer exists anywhere — Cubits call repository interfaces directly.

## Where Does New Code Go?

`core/` is only for code **several features** use. Everything else lives in a feature. Check in order:

| What you're adding | Where it goes |
|---|---|
| Widget reused by several features (button, checkbox, text field) | `lib/core/widgets/` |
| Helper/util used by several features | `lib/core/helper/` |
| Widget used only inside one feature | `features/<feature>/ui/widgets/` |
| Helper used only by one feature (formatters, UI mappers) | `features/<feature>/ui/helper/` |
| Widget/logic shared between sub-flows of one feature (auth login + register) | `features/<feature>/shared/` |
| App-shell piece shown once (bottom nav bar, top bar, drawer) | its own feature, e.g. `features/bottom_nav/ui/` |

- **Start in the feature.** Move to `core/` only when a second feature actually needs it — not "maybe later".
- **"Shown on many screens" ≠ shared.** The bottom nav bar appears everywhere but is one app-shell piece, so it's a feature, not a `core/widgets/` primitive.
- Examples: `features/chats/ui/helper/chat_time_format.dart`, `features/bottom_nav/ui/app_bottom_nav_bar.dart`.

## Recipe: Adding a New Feature or Screen

1. `domain/entities/` — plain Dart classes for anything new the feature needs.
2. `domain/repo/<name>_repository.dart` — `abstract interface class <Name>Repository { ... }`.
3. `data/<name>_repository_impl.dart` — `class <Name>RepositoryImpl implements <Name>Repository`, talking to `SupabaseClient`/`LocalStore` directly.
4. `logic/<name>_cubit.dart` + `<name>_state.dart` — paired, same folder (see State Management below).
5. `ui/<name>_screen.dart` (+ `_view.dart` per sub-section if needed). Check existing widgets first (see UI & Performance).
6. Register in `lib/core/di/injection_container.dart`: `registerLazySingleton` for the repo, `registerFactory` for the cubit.
7. Add a `Routes.<name>` constant in `lib/core/routing/routes.dart`, and a matching `case` in `lib/core/routing/app_router.dart` returning `MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => getIt<XCubit>(), child: const XScreen()))`.
8. **Tests** — Cubit test (success + failure for every public method), `fromJson` test if the entity has one. See Testing.
9. **Security check** — new tables/buckets have RLS policies; no secrets added. See Security.
10. Run `flutter analyze` and `flutter test` — both must be clean.

> `Routes.home` opens `ChatsScreen` (login and splash navigate there).

## State Management

### Cubit / State shape
```dart
class AuthMethodCubit extends Cubit<AuthMethodState> {
  AuthMethodCubit() : super(AuthMethodState.initialState());
  void toggleLoginMethod() {
    emit(state.copyWith(
      loginMethod: state.loginMethod == AuthMethod.phone ? AuthMethod.email : AuthMethod.phone,
    ));
  }
}

enum AuthMethod { phone, email }

class AuthMethodState {
  final AuthMethod loginMethod;
  final String email;
  final bool isEmailValid;
  const AuthMethodState({required this.loginMethod, required this.email, required this.isEmailValid});
  AuthMethodState.initialState() : loginMethod = AuthMethod.phone, email = '', isEmailValid = false;
  AuthMethodState copyWith({AuthMethod? loginMethod, String? email, bool? isEmailValid}) => AuthMethodState(
    loginMethod: loginMethod ?? this.loginMethod,
    email: email ?? this.email,
    isEmailValid: isEmailValid ?? this.isEmailValid,
  );
}
```
Plain Dart class, not freezed/equatable. Small status enums (`OtpStatus`, `CountryStatus`, ...) are declared inline at the top of the `_state.dart` file, not in a separate enums file.

Because states have no `==`, compare **fields**, not whole states, in `buildWhen`/`listenWhen` and in tests.

Cubits that open subscriptions (e.g. a realtime chat stream) cancel them in `close()`:
```dart
@override
Future<void> close() async {
  await _sub?.cancel();
  return super.close();
}
```

### Error handling
Two patterns, chosen by what the Cubit does:

**Multi-stage async flows (OTP-style)** — a sealed domain-event hierarchy returned from the repository, consumed via a Dart 3 `switch` in the Cubit:
```dart
sealed class OTPEven {
  const OTPEven();
}
class OTPSending extends OTPEven { const OTPSending(); }
class OTPFailed extends OTPEven { final String errorMessage; const OTPFailed({required this.errorMessage}); }
class OTPReceived extends OTPEven { const OTPReceived(); }
```

**Simple request/response Cubits (default for new code)** — a `UiError? error` field, not the old counter idiom:
```dart
class UiError {
  final String message;
  UiError(this.message);
}

class XState {
  final UiError? error;
  const XState({required this.error});
  XState copyWith({UiError? error}) => XState(error: error ?? this.error);
}

// in the Cubit:
try {
  ...
} on AuthException catch (e) {
  emit(state.copyWith(error: UiError(e.message)));
} on PostgrestException catch (e) {
  emit(state.copyWith(error: UiError(e.message)));
} catch (_) {
  emit(state.copyWith(error: UiError('Something went wrong. Please try again.')));
}
```
Don't show raw `e.toString()` for unknown errors — it can leak internal details (URLs, table names, stack info) to the user.

```dart
BlocListener<XCubit, XState>(
  listenWhen: (previous, current) => previous.error != current.error,
  listener: (context, state) {
    final error = state.error;
    if (error == null) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(error.message)));
  },
  child: const SizedBox.shrink(),
)
```
`UiError` has no `==`/`Equatable` override, so every new instance is reference-distinct — `listenWhen` fires exactly once per new error with no counter field needed. Lives at `lib/core/helper/ui_error.dart`; first used by `AuthEmailCubit`.

The old `errorMessage` + incrementing `snackBarEventId` counter (e.g. `RegisterUserInformationState`, `OnboardingState`) is the legacy version of this same idea — it's still in existing Cubits, but don't use it in new code, and don't migrate existing Cubits to `UiError` unless you're already changing that Cubit for its own reasons.

No `dartz`/`fpdart`/`Either`, no base `Failure`/`AppException` class anywhere — errors are always encoded directly in state or as domain events, never thrown past the repository boundary.

### DI → Route → Widget wiring
`getIt.registerFactory<XCubit>()` (DI) → `BlocProvider(create: (_) => getIt<XCubit>())` inside the relevant `case` in `app_router.dart` (routing) → `context.read<XCubit>()` for actions, `BlocBuilder`/`BlocSelector`/`BlocConsumer`/`BlocListener` for reactive UI (`context.watch` is never used — it rebuilds the whole `build` method; don't introduce it). See Recipe above for the full sequence.

> `UserRepository`'s registration is currently commented out in `injection_container.dart`, but `RegisterUserInformationCubit(getIt<UserRepository>())` resolves it unconditionally — this throws at runtime today. Pre-existing gap, not something to fix as an unrelated drive-by.

## Repositories & Data Access

```dart
abstract interface class AuthRepository {
  Stream<OTPEven> sendOTP({required String phoneNumber, bool? shouldCreateUser});
  Future<OTPEven> verifyOTP({required String smsCode});
  Future<void> emailMagicLink(String email);
  bool get isSignedIn;
  Future<void> signOut();
}
```
```dart
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;
  AuthRepositoryImpl(this._supabase);
  // talks to _supabase.auth.* directly — no separate data-source/DAO indirection, no network layer
}
```
`SupabaseClient` is injected directly into repository constructors and called on directly (`_supabase.auth.signInWithOtp(...)`, `.verifyOTP(...)`, `.currentUser`) — there's no `core/network/` wrapper, and `dio`/`retrofit` (declared dependencies) aren't used anywhere.

Keep repository impls thin: make the Supabase call, map the result. Put mapping in the entity (`fromJson`) so it's testable without Supabase.

## Entities & JSON (hand-written, no codegen)

Every entity is a plain Dart class with hand-written `fromJson`, `toJson` and (if needed) `copyWith`. No annotations, no generated files.

```dart
class Message {
  final String id;
  final String chatId;
  final String text;
  final DateTime createdAt;
  final String? imageUrl;

  const Message({
    required this.id,
    required this.chatId,
    required this.text,
    required this.createdAt,
    this.imageUrl,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String,
        chatId: json['chat_id'] as String,
        text: json['text'] as String? ?? '',
        createdAt: DateTime.parse(json['created_at'] as String),
        imageUrl: json['image_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'chat_id': chatId,
        'text': text,
        if (imageUrl != null) 'image_url': imageUrl,
      };
}
```

Rules:
- JSON keys match the Supabase column names (`snake_case`); Dart fields are `camelCase`.
- Cast every field explicitly (`as String`, `as int?`). Give a default (`?? ''`) only when a missing value is genuinely fine.
- `toJson` leaves out server-generated fields (`id`, `created_at`) unless the insert needs them.
- Parsing a list: `(rows as List).map((e) => Message.fromJson(e as Map<String, dynamic>)).toList()`.
- Every `fromJson` gets a test: full JSON, and JSON with optional fields missing.

`LocalStore`/`SharedPrefsStore` is the one repository-like pair without an `Impl` suffix — a naming footnote, not a pattern to imitate. New repositories should use `<Name>RepositoryImpl`.

## Security

### The one rule: the app holds no secrets
Everything shipped inside the app can be extracted. `flutter_dotenv` bundles `.env` as a plain asset — anyone can unzip the APK and read it. `--dart-define` and obfuscation make it harder, not impossible.

**Allowed in `.env` (public by design):** `SUPABASE_URL`, `SUPABASE_ANON_KEY`. The anon key is safe *only because* Row Level Security protects the data.

**Never in `.env`, code, `--dart-define`, comments, or git:** the Supabase `service_role` key, any third-party secret key (payments, AI APIs, push-notification server keys, SMTP, etc.), database passwords.

**Where secrets go instead:** Supabase Edge Functions. Store the secret with `supabase secrets set NAME=value`, do the privileged work in the function, and call it from the app:
```dart
await _supabase.functions.invoke('send-push', body: {'chatId': chatId});
```
The user's JWT is attached automatically, so the function knows who's calling.

### Row Level Security (RLS)
- RLS **enabled on every table and storage bucket**, no exceptions. With RLS on and no policy, access is denied — that's the safe default.
- Policies check ownership with `auth.uid()`, e.g. a user can read a chat's messages only if they're a member of that chat.
- The client never decides who can see what. UI validation is for UX; real rules (ownership, required fields, lengths) are enforced in the database via policies and constraints.
- Any new table/bucket in a PR includes its policies. If you can't see the Supabase schema, say which policies are needed rather than assuming they exist.

### Tokens (access + refresh) **(not set up yet)**
- `supabase_flutter` manages the access and refresh tokens and refreshes them automatically. **Never read, store, copy or pass tokens yourself.**
- By default the SDK persists the session in SharedPreferences (not encrypted). We replace that with the platform keystore/keychain via `flutter_secure_storage`:

```dart
// lib/core/local/secure_session_storage.dart
class SecureSessionStorage extends LocalStorage {
  SecureSessionStorage(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() => _storage.containsKey(key: supabasePersistSessionKey);

  @override
  Future<String?> accessToken() => _storage.read(key: supabasePersistSessionKey);

  @override
  Future<void> removePersistedSession() => _storage.delete(key: supabasePersistSessionKey);

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: supabasePersistSessionKey, value: persistSessionString);
}
```
```dart
// main.dart
await Supabase.initialize(
  url: AppConfig.supabaseUrl,
  anonKey: AppConfig.supabaseAnonKey,
  authOptions: FlutterAuthClientOptions(
    localStorage: SecureSessionStorage(const FlutterSecureStorage()),
  ),
);
```
- iOS keychain survives app uninstall, so a reinstall could restore an old session. On first launch after install (a flag missing in `LocalStore`), clear secure storage before `Supabase.initialize`.
- Check the `flutter_secure_storage` README for the Android `minSdk` and iOS keychain setup it needs.

### Local storage
`LocalStore` (SharedPreferences) is **for non-sensitive data only**: onboarding-seen flag, selected country code, UI preferences. Tokens, OTPs, and personal data never go there.

### Logging & release
- Never `print`/`debugPrint` tokens, sessions, OTP codes, phone numbers, emails or message content.
- Release builds use obfuscation: `flutter build apk --release --obfuscate --split-debug-info=build/symbols` (keep the symbols folder out of git; it's needed to read crash stack traces).

## UI & Performance

Goal: each widget rebuilds only when the data *it* shows changes.

### Rebuild rules
- **`StatelessWidget` by default.** Use `StatefulWidget` only for local UI state that owns a controller (`TextEditingController`, `AnimationController`, `ScrollController`, `FocusNode`) — and `dispose()` it.
- **`const` everywhere possible** — constructors and instances. A `const` widget is skipped on rebuild. (Values using `.w`/`.h`/`.r` can't be `const`; that's fine, keep the rest `const`.)
- **Extract widgets into classes, not `_buildX()` methods.** Methods rebuild with their parent and can't be `const`.
- **Wrap the smallest subtree** in `BlocBuilder`, not the whole screen.
- **Rebuild on the field you use**, not the whole state:
```dart
BlocSelector<ChatCubit, ChatState, bool>(
  selector: (state) => state.isSending,
  builder: (context, isSending) => SendButton(isLoading: isSending),
)
```
or `buildWhen: (prev, curr) => prev.messages != curr.messages`.
- **No work in `build`**: no sorting, filtering, parsing or date formatting there. Do it in the Cubit once and store the result in state.

### Lists
- Always `ListView.builder` / `ListView.separated` for dynamic or long lists (never `Column` + `map` inside a scroll view).
- Chat lists: `reverse: true`, and a stable `key: ValueKey(message.id)` per item so Flutter reuses the right element.
- Remote images (avatars, attachments) must be cached — plain `Image.network` refetches on scroll.

### Use what exists
Before writing a widget, check in this order:
1. **Flutter SDK** — e.g. `AnimatedSwitcher`, `AnimatedOpacity`, `RefreshIndicator`, `SliverAppBar`, `showModalBottomSheet`, `Dismissible`, `ListView.separated`. Don't rebuild these from scratch.
2. **`lib/core/widgets/`** — cross-feature primitives (buttons, checkbox, clickable text, countdown timer).
3. **`features/<feature>/ui/widgets/`** and **`features/<feature>/shared/widgets/`** — feature-level widgets.

If an existing widget almost fits, add a parameter to it instead of copying it — so a change happens in one place. Only then create a new one.

Don't add `RepaintBoundary`, custom caching or other performance tricks without a measured problem (Flutter DevTools). Simple rules above cover most cases.

### Widget split
A `_widget.dart` file is a Bloc-connected wrapper around a same-named "dumb" widget with no suffix:
- `otp_input_widget.dart` → `OTPInputWidget` (`BlocBuilder<OTPInputCubit, OTPInputState>`) wraps `otp_input.dart` → `OTPInput` (plain `StatefulWidget`, zero Bloc imports, pure callback props).

Follow this split for new reusable, Cubit-aware UI pieces. The dumb widget is easy to reuse and to widget-test.

`lib/core/widgets/` holds only truly cross-feature primitives. For everything else see [Where Does New Code Go?](#where-does-new-code-go).

## Packages: Build It or Add It?

**Write it yourself** when it's small and clear — roughly one file, no platform code, no security/crypto logic (e.g. a debouncer, a validator, a simple formatter). Put it in `lib/core/helper/` if several features use it, otherwise in `features/<feature>/ui/helper/`.

**Use a package** when doing it yourself would be complex, spread over many files, need platform code, or touch security (e.g. secure storage, image caching, image compression).

**A package must be trusted:**
- Verified publisher or Flutter Favorite on pub.dev.
- Actively maintained (a release in roughly the last 12 months, issues answered).
- High pub points, supports current Dart/Flutter, compatible license.

**Before adding:** check `pubspec.yaml` — don't add a second package for a job one already does. Dormant packages (see Tech Stack) still aren't to be used without asking first. **Always list every new dependency in your summary** so it's a visible decision.

## Code Style & Comments

- **Readable without explanation.** Clear names over clever code. Early returns over nested `if`s. One job per function.
- **Comments: short, and only when needed.** Explain *why*, never *what* — the code already says what.
  - Good: `// Supabase returns newest first; chat UI needs oldest first.`
  - Bad: `// Loop through messages` / `// Emit new state`
- No commented-out code, no TODOs without a reason, no doc comments restating the method name.

## Naming Conventions

- Files: snake_case always. Classes: PascalCase matching the filename.
- Imports are always absolute `package:e_chat_app/...` — never relative (`../`), even for same-folder siblings.
- Suffix glossary:
  - `_repository` / `_repository_impl` — domain contract / data-layer implementation.
  - `_cubit` / `_state` — always paired 1:1, same `logic/` folder.
  - `_screen` — registered directly against a `Route`.
  - `_view` — a sub-section swapped in via `IndexedStack`/`switch`, not independently routed.
  - `_step` — a reusable, cubit-aware composite shared between `login` and `register` (e.g. `AuthPhoneStep`).
  - `_widget` — the Bloc-connected wrapper of a same-named dumb widget (see UI & Performance).
  - `_impl` — the sole implementation of a same-named contract.
  - `_test` — test file mirroring the file it tests (see Testing).
- Quote style and trailing commas are genuinely inconsistent in existing code — there's no rule to follow here, don't invent one.
- Existing typos are pervasive and intentional to leave alone: `onbording`/`onborading`, `OTPEven`/`OTPVerfiyed`/`OTPAutoVerfiyed`, `loginWithEmailMigicLink`, `navgiateTo`/`NavgiateTo`, `extenstions.dart`, `countris_code_repository_impl.dart`, the `date/` folder in `onbording/`. Spell new identifiers correctly, but don't silently rename these as a drive-by inside unrelated work — a typo cleanup is a separate, deliberate task.

## Testing

Purpose: every time a feature is added or logic changes, the full test suite proves nothing that already worked broke.

### What must be tested
| Change | Required tests |
|---|---|
| New Cubit | Every public method: success path + failure path |
| Changed Cubit logic | Tests for the changed behavior; if the Cubit had no tests, first add tests for its **current** behavior, then change it |
| Bug fix | A test that fails before the fix and passes after |
| Entity with `fromJson`/`toJson` | Full JSON + JSON with optional fields missing |
| Helper in `core/helper/` or `ui/helper/` | Plain unit tests of inputs → outputs |
| Reusable dumb widget | Widget test for its main states/callbacks (optional for screens) |

### How
- **Cubits:** build them directly with a mocked repository — never through `getIt`. The repository interface exists exactly so it can be mocked.
- **Repository impls:** keep them thin (see Repositories) and don't mock Supabase query-builder chains — it's brittle and tests nothing real. Test the mapping in the entity instead. Auth calls (`_supabase.auth`) can be mocked with `mocktail` if needed.
- **States have no `==`**, so assert on fields with `isA<X>().having(...)`, never `equals(XState(...))`.
- Tests live in `test/`, mirroring `lib/`: `lib/features/auth/.../auth_method_cubit.dart` → `test/features/auth/.../auth_method_cubit_test.dart`.
- Shared fakes/helpers go in `test/helpers/`.

### Example: Cubit with no dependencies
```dart
void main() {
  blocTest<AuthMethodCubit, AuthMethodState>(
    'toggleLoginMethod switches phone to email',
    build: AuthMethodCubit.new,
    act: (cubit) => cubit.toggleLoginMethod(),
    expect: () => [
      isA<AuthMethodState>().having((s) => s.loginMethod, 'loginMethod', AuthMethod.email),
    ],
  );
}
```

### Example: Cubit with a repository
```dart
class MockXRepository extends Mock implements XRepository {}

void main() {
  late MockXRepository repo;

  setUp(() => repo = MockXRepository());

  blocTest<XCubit, XState>(
    'load emits items on success',
    build: () {
      when(() => repo.fetchItems()).thenAnswer((_) async => [Item(id: '1')]);
      return XCubit(repo);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<XState>().having((s) => s.items.length, 'items', 1),
    ],
  );

  blocTest<XCubit, XState>(
    'load emits error on failure',
    build: () {
      when(() => repo.fetchItems()).thenThrow(Exception('network'));
      return XCubit(repo);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<XState>().having((s) => s.error, 'error', isNotNull),
    ],
  );
}
```
Stream-based repositories (OTP-style) are mocked with `thenAnswer((_) => Stream.fromIterable([const OTPSending(), const OTPReceived()]))`.

### Widget tests
Screens read `extension<AppTextTheme>()!` and use `.w`/`.h`, so they crash without the app's theme and `ScreenUtilInit`. Wrap them with a shared helper in `test/helpers/pump_app.dart` that uses the same `designSize` and `ThemeData` as `e_chat_app.dart`, rather than repeating the setup per test.

### Commands
```bash
flutter analyze
flutter test
```
Both must pass with zero failures before any feature or change is considered done.

## Definition of Done

Before reporting a task as finished:
- [ ] `flutter analyze` clean, `flutter test` fully passing.
- [ ] New/changed logic has tests (see Testing table).
- [ ] No secrets added anywhere; new tables/buckets have RLS policies.
- [ ] `StatelessWidget` + `const` where possible; `BlocBuilder`/`BlocSelector` scoped to the smallest subtree.
- [ ] Existing widgets reused/extended instead of duplicated.
- [ ] Simplest working solution; comments only where they explain *why*.
- [ ] Any new dependency listed in the summary.