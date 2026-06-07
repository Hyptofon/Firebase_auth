# Firebase Authentication

Цей проєкт є виконанням лабораторної роботи **LR16: Firebase Authentication** з курсу розробки мобільних застосунків на Flutter.

У застосунку реалізовано повний базовий сценарій автентифікації через Firebase: реєстрація користувача, вхід, вихід, відновлення пароля, збереження стану сесії, захищені екрани та обробка помилок. Проєкт налаштований для Android, iOS та Web, а web-версія розгорнута через Firebase Hosting.

**Live Demo:** [https://fir-116ef.web.app](https://fir-116ef.web.app)

---

## Мета роботи

Навчитися інтегрувати Firebase Authentication у Flutter-застосунок та реалізувати базові auth-сценарії для користувача.

Ключові навички:

- налаштування Firebase-проєкту;
- підключення `firebase_core` та `firebase_auth`;
- Email/Password authentication;
- робота з `authStateChanges`;
- валідація форм;
- обробка Firebase Auth помилок;
- protected routes;
- підготовка web-версії та деплой на Firebase Hosting.

---

## Виконані обов'язкові завдання

### 1. Firebase setup

- Створено Firebase-проєкт `fir-116ef`.
- Додано Android app з package name `com.example.lr16_firebase_auth`.
- Додано iOS app з bundle ID `com.example.lr16FirebaseAuth`.
- Додано Web app для запуску у браузері.
- Підключено конфігураційні файли:
  - `android/app/google-services.json`;
  - `ios/Runner/GoogleService-Info.plist`;
  - `lib/firebase_options.dart`.
- У Firebase Console увімкнено Email/Password provider.

### 2. FlutterFire та ініціалізація Firebase

- Додано залежності `firebase_core` та `firebase_auth`.
- У `main.dart` виконується `WidgetsFlutterBinding.ensureInitialized()`.
- Firebase ініціалізується через `Firebase.initializeApp(...)`.
- Для вибору платформи використовується `DefaultFirebaseOptions.currentPlatform`.

### 3. Sign Up

- Реалізовано екран реєстрації.
- Форма містить поля:
  - full name;
  - email;
  - password;
  - confirm password.
- Додано валідацію:
  - обов'язкові поля;
  - коректний email;
  - пароль мінімум 6 символів;
  - підтвердження пароля має збігатися з паролем.
- Кнопка створення акаунта неактивна, поки обов'язкові поля порожні.
- Помилки валідації показуються після натискання submit, а не одразу під час першого вводу.
- Після успішної реєстрації користувач створюється у Firebase Authentication.

### 4. Login

- Реалізовано екран входу через email/password.
- Додано валідацію email та password.
- Кнопка login неактивна, поки поля порожні.
- Повідомлення про помилки входу зроблено безпечним: застосунок не розкриває, чи конкретний email існує у Firebase.

### 5. Logout

- Реалізовано вихід з акаунта.
- Перед виходом показується діалог підтвердження.
- Після logout `AuthWrapper` автоматично повертає користувача на Login screen.

### 6. Password Reset

- Реалізовано екран відновлення пароля.
- Користувач вводить email та отримує reset link на пошту.
- Після успішної відправки показується success state.
- Помилки Firebase Auth обробляються через централізований mapper.

### 7. Auth State Listener

- Створено `AuthWrapper`.
- Використовується `StreamBuilder` над `authStateChanges`.
- Якщо користувач авторизований, відкривається `HomeScreen`.
- Якщо користувач не авторизований, відкривається `LoginScreen`.
- Firebase зберігає сесію між перезапусками застосунку або браузера.

### 8. Protected Routes

- Реалізовано захищені екрани:
  - `ProfileScreen`;
  - `SettingsScreen`.
- Додано `ProtectedRoute`, який перевіряє auth state перед показом екрана.
- Якщо користувач не авторизований, показується `ProtectedAccessDenied`.

### 9. Error Handling

- Створено `FirebaseErrorMapper`.
- Обробляються основні Firebase Auth помилки:
  - `weak-password`;
  - `email-already-in-use`;
  - `invalid-email`;
  - `user-not-found`;
  - `wrong-password`;
  - `invalid-credential`;
  - `user-disabled`;
  - `too-many-requests`;
  - `operation-not-allowed`;
  - `network-request-failed`;
  - `requires-recent-login`.
- Для login використовується нейтральне повідомлення, щоб не допустити email enumeration.

---

## Додатково реалізовано

- Web-версія застосунку.
- Firebase Hosting.
- Responsive layout для auth-екранів: на desktop форма не розтягується на всю ширину, а показується акуратним центральним блоком.
- Email verification.
- Update display name.
- Delete account з повторною автентифікацією.
- Profile screen з інформацією про користувача.
- Settings screen для демонстрації protected route та auth persistence.
- Розділення auth-логіки за принципами SOLID:
  - `AuthStateRepository`;
  - `AuthCredentialsRepository`;
  - `AccountRepository`;
  - `FirebaseAuthService`;
  - `HomeActionsController`.

---

## Структура проєкту

```text
lib/
|-- controllers/
|   `-- home_actions_controller.dart
|-- dialogs/
|   |-- delete_account_dialog.dart
|   |-- logout_dialog.dart
|   `-- update_name_dialog.dart
|-- models/
|   `-- auth_result.dart
|-- repositories/
|   `-- auth_repository.dart
|-- screens/
|   |-- forgot_password_screen.dart
|   |-- home_screen.dart
|   |-- login_screen.dart
|   |-- profile_screen.dart
|   |-- settings_screen.dart
|   `-- sign_up_screen.dart
|-- services/
|   `-- firebase_auth_service.dart
|-- utils/
|   |-- firebase_error_mapper.dart
|   |-- snack_bar_helper.dart
|   `-- validators.dart
|-- widgets/
|   |-- auth/
|   |   |-- auth_screen_layout.dart
|   |   |-- forgot_password_form.dart
|   |   |-- login_form.dart
|   |   `-- sign_up_form.dart
|   |-- home/
|   |   |-- account_actions_section.dart
|   |   |-- email_verification_badge.dart
|   |   |-- home_header.dart
|   |   |-- logout_button.dart
|   |   |-- protected_routes_section.dart
|   |   |-- session_card.dart
|   |   `-- user_avatar.dart
|   |-- action_tile.dart
|   |-- app_button.dart
|   |-- app_text_field.dart
|   |-- auth_wrapper.dart
|   |-- protected_access_denied.dart
|   `-- protected_route.dart
|-- firebase_options.dart
`-- main.dart
```

---

## Основні файли

| Файл | Призначення |
| :--- | :--- |
| `lib/main.dart` | Entry point, ініціалізація Firebase, тема застосунку |
| `lib/firebase_options.dart` | Firebase config для Web, Android та iOS |
| `lib/services/firebase_auth_service.dart` | Реальна робота з Firebase Auth |
| `lib/repositories/auth_repository.dart` | Абстракції для auth state, credentials та account actions |
| `lib/widgets/auth_wrapper.dart` | Перемикання між Login/Home залежно від auth state |
| `lib/widgets/protected_route.dart` | Захист екранів від неавторизованого доступу |
| `lib/utils/firebase_error_mapper.dart` | Мапінг Firebase Auth помилок у user-friendly повідомлення |
| `firebase.json` | Конфіг Firebase Hosting |
| `.firebaserc` | Firebase project alias для deploy |

---

## Як запустити локально

1. Встановити залежності:

```bash
flutter pub get
```

2. Запустити на Android або емуляторі:

```bash
flutter run
```

3. Запустити web-версію:

```bash
flutter run -d chrome
```

---


## Перевірка

Ручна перевірка основних сценаріїв:

- [x] Sign Up створює нового користувача у Firebase Authentication.
- [x] Login працює для зареєстрованого користувача.
- [x] Logout повертає користувача на Login screen.
- [x] Password Reset відправляє лист для скидання пароля.
- [x] Auth state зберігається між перезапусками.
- [x] Profile та Settings доступні тільки авторизованому користувачу.
- [x] Firebase errors показуються як зрозумілі повідомлення.
- [x] Web-версія задеплоєна на Firebase Hosting.

Команди для фінальної перевірки перед здачею:

```bash
dart format .
flutter analyze
flutter test
```

---

## Автор

| Поле | Деталі |
| :--- | :--- |
| Студент | Войтюк Назарій |
| Група | КН-311 |
| Live Demo | [fir-116ef.web.app](https://fir-116ef.web.app) |
