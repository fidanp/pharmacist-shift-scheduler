# Pharmacist Shift Scheduler

## Overview
The Pharmacist Shift Scheduler is an application designed to assign pharmacists to different shifts (Morning, Afternoon, Evening) for a specified month. The app ensures an even distribution of shifts among pharmacists, including weekend shifts.

## Tech Stack
- Flutter
- Dart
- GetX for state management, routing, and dependency injection
- Hive for local db

## Installation
1. Clone the repository:
    git clone https://github.com/fidanp/pharmacist-shift-scheduler.git

    or unzip the zip file shared and open terminal in the folder

2. Install dependencies:
 
    flutter pub get

3. Run the app:

    flutter run


## Usage
1. Open the app and input the list of pharmacists or import from excel with names of pharmacist on a column.
2. Select the year and month for which you want to generate the shift schedule.
3. View the shift assignments by selecting any day from the calendar.

## Features
- **Shift Assignment**: Fair distribution of Morning, Afternoon, and Evening shifts.
- **Weekend Shift Handling**: Special consideration for weekend shifts.
- **Dynamic Scheduling**: The app supports any number of pharmacists.
- **Language & Theme Switching**: Toggle between English/Arabic and light/dark themes via the Settings icon in the AppBar.

## Code Quality
The code is structured in a modular fashion, with separate files for shift scheduling logic, UI, and controllers. Error handling is implemented to ensure smooth scheduling.

## Scalability
The app supports any number of pharmacists and dynamically adjusts the schedule to handle larger datasets efficiently.

## Known Issues
- No automated optimization for pharmacist preferences (ie, preferred shifts).
- Weekends are assigned based on availability rather than preference.

## Scheduling Algorithm
The shift scheduling algorithm aims to distribute shifts fairly among pharmacists, balancing both daily shift coverage and overall shift distribution throughout the month.

1.  **Initialization:**
    * The algorithm takes as input the list of pharmacists, the target month and year.
    * It initializes a data structure to track the number of Morning, Afternoon, Evening, and Weekend shifts assigned to each pharmacist.

2.  **Daily Shift Assignment:**
    * For each day of the month, the algorithm performs the following:
        * **Determine Daily Targets:** Calculates the ideal number of pharmacists for each shift (Morning, Afternoon, Evening) for that day, aiming for an even distribution.
        * **Prioritize Pharmacists:** Creates a list of pharmacists, sorted by the number of shifts they have worked the least.
        * **Assign Shifts:** Iterates through the pharmacists and assigns them to shifts based on the following criteria:
            * Prioritizes assigning a pharmacist to a shift that still needs coverage for that day.
            * Among the available shifts for a given day, the algorithm attempts to assign the pharmacist to the shift type they have worked the least during the month.
        * **Weekend Handling:** If the day is a Saturday or Sunday, the assigned shift is also counted as a 'Weekend' shift for that pharmacist to ensure fair weekend shift distribution.

3.  **Output:**
    * The algorithm generates a shift schedule for the entire month, aiming to balance daily shift coverage with a fair distribution of shift types (including weekend shifts) across all pharmacists.  The schedule is designed to prevent pharmacists from being consistently assigned to the same shift type.

## Screen recording
https://drive.google.com/drive/folders/1wo-A59u0vYEGYOmtfpvUVmeU4jUWAuhF

## APK
release/app-release.apk
https://drive.google.com/file/d/1CZcelbNzWN7xevYHRZirIVd1QgK_LgbV/view?usp=drive_link

## Tested
Tested in both Android and iOS
