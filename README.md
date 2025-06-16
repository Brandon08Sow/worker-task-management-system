# Worker Task Management System (WTMS)

A mobile application developed using Flutter, with a PHP + MySQL backend, built for the Mobile Programming (STIWK2114) course at Universiti Utara Malaysia (UUM).
This app enables workers to register, log in, view, and update their profiles, check assigned tasks, submit completed work, and view their submission history.

---

## 📱 Features

- 🔐 **Worker Registration**
  - Full name, email, password (min. 6 chars), phone, and address.
  - Input validation.
  - SHA1 password hashing.
- 🔑 **Login Functionality**
  - Validates credentials with PHP API.
  - Auto-login via "Remember Me" with `SharedPreferences`
  - Displays error for incorrect login.
- 🔁 **Session Persistence**
  - Auto login with SharedPreferences ("Remember Me").
- 👤 **Worker Profile**
  - Displays full worker info (ID, name, email, phone, address).
  - Shows greeting (e.g., "Welcome, Abu Bakar").
  - Profile update functionality.
  - Allows logout.
- 📝 **Task Management**
  -Retrieves task list from tbl_works via get_works.php
  -Each task shows title, description, and deadline
  -Workers can submit completion reports for any task
  -Reports saved to tbl_submissions via submit_work.php
-📋 **Submission History**
  -View submitted work reports from tbl_submissions using get_submissions.php
  -Displays submitted task title, report content, and timestamp
  -Useful for tracking past submissions and preventing duplicate reports

- 🌐 **PHP + MySQL Backend**
  - `register_user.php`
  - `login_user.php`
  - `dbconnect.php`
  - `get_works.php`
  - `submit_work.php`
  - `edit_submission.php`
  - `get_profile.php`
  - `get_submissions.php`
  - `update_profile.php`
---

## 📂 Project Structure

![image](https://github.com/user-attachments/assets/5d8c786a-b645-4a6e-821f-56fbbbad4f6a)

---

## 🛠 How to Run

1. **Backend Setup (PHP)**
   - Install [XAMPP](https://www.apachefriends.org/index.html).
   - Place PHP files in: `C:\xampp\htdocs\lab_assignment2\`
   - Import `workertable` DB in **phpMyAdmin**.

2. **Frontend (Flutter)**
   - Open in VS Code or Android Studio.
   - Run: `flutter pub get`
   - Launch app (e.g., on Chrome or Android Emulator)


---

## 👨‍💻 Author

Sow Li Wang – Universiti Utara Malaysia
No.Matrik:297961
Course: STIWK2114 - Mobile Programming 

