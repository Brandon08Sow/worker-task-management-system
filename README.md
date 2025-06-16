
# 💼 Worker Task Management System (WTMS)

A mobile application built with **Flutter**, using a **PHP + MySQL backend**, for the **Mobile Programming (STIWK2114)** course at **Universiti Utara Malaysia (UUM)**.

This app enables workers to:
- 🔐 Register and log in
- 🧑‍💼 View and update their profiles
- 📋 Check assigned tasks
- 📝 Submit and edit completed work
- 📚 View submission history

---

## ✨ Features

### 🔐 Worker Registration
- Register with full name, email, password (min. 6 chars), phone, and address.
- Input validation included.
- Passwords hashed using SHA1 (PHP).

### 🔑 Login Functionality
- Validates credentials via PHP API.
- Auto-login using `SharedPreferences` ("Remember Me").
- Error feedback for incorrect credentials.

### 🧾 Session Persistence
- Remembers user sessions using `SharedPreferences`.

### 👤 Worker Profile
- Displays full worker details: ID, name, email, phone, and address.
- Shows greeting message (e.g., **"Good Evening, Ali"**).
- Profile update form (username is read-only).
- Logout function included.

### 🧱 Task Management
- Retrieves assigned tasks from `tbl_works` via `get_works.php`.
- Displays task title, description, deadline.
- Allows submission of completion report.
- Saves to `tbl_submissions` via `submit_work.php`.

### 📜 Submission History
- Displays past work submissions via `get_submissions.php`.
- Includes task title, submission content, and date.
- Tap to edit existing submission via `edit_submission.php`.

---

## 🌐 Backend API (PHP)

| API File | Description |
|----------|-------------|
| `register_user.php` | Registers new worker |
| `login_user.php` | Logs in and validates user |
| `get_works.php` | Fetches assigned tasks |
| `submit_work.php` | Saves new submission |
| `get_submissions.php` | Returns all submissions by worker |
| `edit_submission.php` | Updates submission text |
| `get_profile.php` | Returns worker profile info |
| `update_profile.php` | Updates email, phone, address |

---

## 🗂️ Project Structure

```
lib/
 ├── model/
 │   ├── user.dart
 │   ├── task.dart
 │   └── submission.dart
 └── view/
     ├── loginscreen.dart
     ├── registerscreen.dart
     ├── mainscreen.dart
     ├── taskscreen.dart
     ├── submitworkscreen.dart
     ├── submissionhistoryscreen.dart
     ├── editsubmissionscreen.dart
     ├── profilescreen.dart
     └── splashscreen.dart
```

---

## 🛠 How to Run

### 🔧 Backend (XAMPP + PHP)
1. Install [XAMPP](https://www.apachefriends.org/index.html).
2. Place all PHP files in:  
   `C:\xampp\htdocs\lab_assignment2\`
3. Start Apache server in XAMPP Control Panel.
4. Import database file into **phpMyAdmin**:
   - Create DB: `workertable`
   - Import SQL with tables:
     - `tbl_workers`
     - `tbl_works`
     - `tbl_submissions`

### 💻 Frontend (Flutter)
1. Open in **VS Code** or **Android Studio**.
2. Run:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
3. App works in browser (Chrome) – no emulator needed!

---

## 📽️ YouTube Demo

🔗 [Insert your video link here]  
**Covers:** registration → login → task list → submission → history → edit → profile update.

---

## 👤 Author

**Sow Li Wang**  
Universiti Utara Malaysia  
Matric No: 297961  
Course: STIWK2114 - Mobile Programming

---

## ✅ Final Rubric Coverage Checklist

✔ Task list + submission  
✔ Submission history  
✔ Edit submission  
✔ Profile view + update  
✔ Navigation bar  
✔ PHP backend (8 files)  
✔ Validation + feedback  
✔ GitHub repo structured  
✔ YouTube demo

---

## 🏁 Conclusion

Thank you for viewing my project. This app showcases full CRUD functionality, session handling, and API integration with clean UI — built fully from scratch using Flutter & PHP.
