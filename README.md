# Firebase Authentication

## LR17 + LR18: Firebase Notes App

Проєкт розширено після LR16 і перетворено на захищений Notes App з Firestore Database та Firebase Storage.

### LR17: Firestore Database

- [x] Додано `cloud_firestore`.
- [x] Створено модель `Note` з `fromJson`, `toJson` і `copyWith`.
- [x] Реалізовано CRUD для нотаток: create, read, update, delete.
- [x] Read працює через `StreamBuilder` і Firestore `snapshots()`, тому UI оновлюється real-time.
- [x] Дані ізольовано за користувачем у структурі `users/{userId}/notes/{noteId}`.
- [x] Для часу створення й оновлення використовується `FieldValue.serverTimestamp()`.
- [x] Додано offline persistence у `main.dart`.
- [x] Додано pagination-поведінку: `getNotesPage()` у service шарі та `Load more` на екрані нотаток.
- [x] Додано пошук нотаток по title/content.

### LR18: Firebase Storage

- [x] Додано `firebase_storage` та `image_picker`.
- [x] Реалізовано вибір фото з галереї.
- [x] Реалізовано upload зображення у Storage.
- [x] Storage path використовує реальний Firestore `noteId`: `users/{userId}/notes/{noteId}/image_<timestamp>.<ext>`.
- [x] Після upload download URL зберігається у Firestore полі `imageUrl`.
- [x] Фото показується у картці нотатки та на екрані редагування.
- [x] Додано progress indicator через `UploadTask.snapshotEvents`.
- [x] Додано видалення фото зі Storage разом із нотаткою.
- [x] Додано перевірку розміру файлу до 5MB.
- [x] Додано metadata: `contentType`, `sizeBytes`, `userId`, `noteId`, `uploadedAt`.
- [x] Image flow побудований на `XFile + putData`, тому краще підходить і для mobile, і для web.

### Security Rules

У проєкті є локальні правила Firebase:

- `firestore.rules` дозволяє користувачу читати й змінювати тільки власні нотатки.
- `storage.rules` дозволяє користувачу працювати тільки з власними файлами нотаток, приймає лише image-файли до 5MB.
- `firebase.json` підключає обидва rules-файли для deploy.

Deploy правил:

```bash
firebase deploy --only firestore:rules,storage
```

### Додатково для якості

- [x] Додано unit tests для `NotesController`.
- [x] Перевіряється, що нове фото вантажиться саме під реальним `noteId`, а не під тимчасовим id.
- [x] Додано rollback: якщо upload або Firestore update падає, зайві файли/документи прибираються.
- [x] Widget test оновлено так, щоб він використовував shared string constants, а не застарілий текст кнопки.
- [x] Валідація title/content узгоджена з Firestore rules.

### Основні файли LR17/LR18

| Файл | Призначення |
| :--- | :--- |
| `lib/models/note.dart` | Firestore model для нотатки |
| `lib/services/firestore_service.dart` | Facade для читання/запису нотаток |
| `lib/services/firestore_notes_reader.dart` | Stream, pagination, Firestore read queries |
| `lib/services/firestore_notes_writer.dart` | Create/update/delete Firestore operations |
| `lib/services/storage_service.dart` | Upload/delete image, metadata, progress |
| `lib/controllers/notes_controller.dart` | Координація Firestore + Storage, rollback |
| `lib/screens/notes_screen.dart` | Notes list, search, Load more, real-time UI |
| `lib/screens/note_editor_screen.dart` | Create/edit note with image attachment |
| `test/notes_controller_test.dart` | Unit tests для критичної логіки LR17/LR18 |
| `firestore.rules` | Firestore security rules |
| `storage.rules` | Firebase Storage security rules |

---

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
|-- constants/
|-- controllers/
|-- dialogs/
|-- models/
|-- repositories/
|-- screens/
|-- services/
|-- theme/
|-- utils/
|-- widgets/
|   |-- auth/
|   |-- home/
|   `-- notes/
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
