📱 Thirty Green Events: Cross-Platform Task & Event Management App
=======================================================

> 🚀 A polished, **cross-platform mobile application** for managing personal events and tasks, built with **Flutter**. Developed in a **2-person team** over 3 months during a university course in **mobile development**, the app focuses on **usability**, **data handling**, and **responsive design**, while offering local storage and personalized statistics.

* * *

📌 Overview
-----------

**Thirty Green Events** is a Flutter-powered mobile app designed to help users organize and manage their daily **tasks and events** across devices. The app integrates a **local SQLite database** for persistent data storage and presents **personalized statistics** to offer actionable insights. A complete wireframe guides user interaction, with special attention given to **responsive UI/UX** and **user-centered navigation**.

### 📁 Project Highlights

* 🧭 **Full Wireframe Mapping**: Pre-development wireframes shaped an intuitive and accessible UX.

* 🗓️ **Task & Event Management**: Create, edit, and delete personal events or to-do items.

* 🧑‍💻 **Focus on Usability**: Clean layout with adaptive components for different screen sizes.
    
* 📊 **Personalized Statistics**: View analytics based on task completion and scheduling behavior.
    
* 🗂️ **SQLite Integration**: Lightweight, offline-capable storage for user profiles and task data.
        
* 📱 **Cross-Platform Support**: Runs smoothly on both Android and iOS thanks to Flutter.    

* * *

🌍 Language Note
----------------

All **code comments and documentation** are in **Italian**, as the project was developed for a university course at the **University of Salerno (Italy)**.

However, the **codebase follows standard Flutter/Dart best practices**, with consistent naming and modular organization for global readability.

* * *

🛠️ Technologies Used
---------------------

* **Framework**: Flutter
    
* **Language**: Dart
    
* **Database**: SQLite (via `sqflite` package)
    
* **Design Tools**: Figma / Draw.io / Pen-and-paper wireframes
    
* **Version Control**: Git
    

* * *

💡 Features
-----------

### 👥 User Interaction

* Add, modify, and delete tasks and events
    
* Daily, weekly, and monthly views of tasks
    
* Visual indicators for priority or overdue items
    
* Profile-based data persistence with SQLite
    
* View statistics based on activity and behavior
    

### 📊 Statistics Dashboard

* Completed vs. pending task ratio
    
* Time spent on categories (e.g., work, personal, study)
    
* Weekly productivity graphs
    

### 🎨 UI/UX Highlights

* Fully responsive layout on all screen sizes
    
* Page transitions and smooth navigation
    
* Consistent color palette and component design
    
* Touch-friendly controls and intuitive icons
    

* * *

🧠 Development Process
----------------------

> 👨‍💻 A collaborative, iterative project developed over 3 months by 2 students in a university mobile development course.

* 📋 Wireframe design and UI planning
    
* 🔄 Agile-style development using Git
    
* 🗃️ Data modeling for events, tasks, and profiles
    
* ⚙️ Integration of SQLite and local state management
    
* 📱 Manual testing across Android and iOS emulators
    

* * *

📋 Documentation
----------------

Project documentation is available in the `docs/` folder and includes:

* 📜 Wireframe Diagrams (PDF)
    
* 🧾 Technical Report (PDF, Italian)

* * *

🧱 **Detailed Project Structure**
---------------------------------

```
📦 event_manager_app
│
├── 📁 assets                # Static assets like images, icons, etc.
│
├── 📁 lib                   # Main Dart codebase for the Flutter app
│   ├── database_helper.dart     # SQLite database helper for local storage
│   ├── event.dart               # Model class for event objects
│   ├── event_detail_page.dart  # UI for viewing event details
│   ├── home_page.dart          # Main homepage with event list
│   ├── main.dart               # Entry point of the application
│   ├── new_event.dart          # UI for creating a new event
│   └── person.dart             # Model class for person/user data
│
├── 📁 docs                  # Project documentation and assets
│   ├── Relazione tecnica Thirty Green Events.pdf # Technical report
│   └── Wireframe Thirty Green Events.png    # Wireframe design
│
├── LICENSE                 # Project license
└── README.md               # Project overview and setup instructions
```
    

* * *

📸 Interface Preview
--------------------

Here are some screenshots of the app in action:

![thirty green events screenshots](https://github.com/user-attachments/assets/b4f924ab-b93a-4e98-8aa5-53b0a2051eca)

* * *

👥 Team Collaboration
---------------------

Developed by a **team of 2**, the project was a deep dive into collaborative, cross-platform app development. Responsibilities were divided across:

* 📱 UI/UX Design and Frontend Flutter Work
    
* 🧠 Database Structure and Backend Logic
    
* 🧪 Testing and Debugging
    
* 🔄 Continuous Integration via Git
    

* * *

🚀 How to Run Locally
---------------------

1. Clone the repository:
    

```bash
git clone https://github.com/francescopiocirillo/event-manager-flutter-app.git
```

2. Open the project in your preferred IDE (e.g., VS Code, Android Studio)
    
3. Install dependencies:
    

```bash
flutter pub get
```

4. Run the app on a connected device or emulator:
    

```bash
flutter run
```

* * *

📬 Contacts
-----------

✉️ Got feedback or want to contribute? Feel free to open an **Issue** or submit a **Pull Request**!

* * *

📈 SEO Tags
-----------

```

Flutter task management app, cross-platform mobile app, SQLite Flutter app, Flutter event planner, task statistics app, mobile task organizer, event tracking app, productivity tracker Flutter, university mobile app project, personal task scheduler, full-stack mobile development, mobile app with local database, Flutter UI/UX design, Android iOS compatible Flutter app.

```

* * *

📄 License
----------

This project is licensed under the **MIT License**; free for use, modification, and distribution with credit.

> ⭐ If you found this project helpful, please consider giving it a star!
