PawPal: Pet Adoption & Donation Application
PawPal is a full-stack mobile application designed to bridge the gap between pet owners, adopters, and donors. The platform facilitates pet adoption, donations for pets in need, and community rescue efforts through a centralized mobile interface.

🛠️ Technical Stack
Frontend: Flutter (Dart)

Backend: PHP

Database: MySQL (XAMPP)

Communication: RESTful APIs via JSON

🚀 Features
Public Pet Listing: Browse pets with real-time search and category filtering.

Adoption System: View detailed pet profiles and submit requests to owners.

Donation Module: Support pets through Money, Food, or Medical aid.

User Profile: Manage personal data, upload profile pictures, and track donation history.

💻 Setup Instructions
Follow these steps to get the project running on your local machine.

1. Prerequisites
Install Flutter SDK

Install XAMPP

An Android Emulator or Physical Device

2. Backend Setup (XAMPP)
Start Services: Open XAMPP Control Panel and start Apache and MySQL.

Database Creation:

Open your browser and go to http://localhost/phpmyadmin.

Create a new database named pawpal_db.

Import the pawpal_db.sql file located in the /server folder of this repository.

Deploy API Files:

Copy the folder inside /server/api to your XAMPP directory: C:/xampp/htdocs/pawpal/api/.

Ensure the uploads folder exists in htdocs/pawpal/ to store pet and profile images.

3. Frontend Setup (Flutter)
Configure API URL:

Open lib/myconfig.dart.

Replace the baseUrl with your local IP address (e.g., http://192.168.1.5).

Note: Do not use localhost if testing on a physical device.

Install Dependencies:

Open your terminal in the project root.

Run: flutter pub get

Run the App:

Connect your device or start an emulator.

Run: flutter run

🔧 Key Implementations
Image Processing: Images are converted to Base64 strings for upload and stored as physical files on the server to optimize database performance.

Location Services: Uses the geolocator package to capture coordinates during pet submission.

Persistence: Uses SharedPreferences to keep users logged in across app restarts.

📝 Author
Name: Dwi L.Hidayat Bin Lasumardi

Matric No: 300974

Course: STTGK3013 Mobile Web Programming

