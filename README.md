# Worker Task Management System (WTMS)

This is a mobile app built with **Flutter** that allows workers to **register, log in, and manage their profile**. The app uses a **PHP backend API** and **MySQL database**, designed for the "Mobile Programming" course lab assignment.

---

## 📱 Features

- 🔐 **Worker Registration**
  - Full name, email, password (min. 6 chars), phone, and address.
  - Input validation.
  - SHA1 password hashing.
- 🔑 **Login Functionality**
  - Validates credentials with PHP API.
  - Displays error for incorrect login.
- 🔁 **Session Persistence**
  - Auto login with SharedPreferences ("Remember Me").
- 👤 **Profile Management**
  - Displays full worker info (ID, name, email, phone, address).
  - Shows greeting (e.g., "Welcome, Abu Bakar").
  - Allows logout.
- 🌐 **PHP + MySQL Backend**
  - `register_user.php`
  - `login_user.php`
  - `dbconnect.php`

---

## 📂 Project Structure

- `lib/` – Flutter frontend code
- `assets/` – Logo image and other assets
- `htdocs/lab_assignment2/` – PHP backend folder (for XAMPP)

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
Course: Mobile Programming 

