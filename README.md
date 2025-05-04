# Pharmacist Shift Scheduler

## Overview
The Pharmacist Shift Scheduler is an application designed to assign pharmacists to different shifts (Morning, Afternoon, Evening) for a specified month. The app ensures an even distribution of shifts among pharmacists, including weekend shifts.

## Tech Stack
- Flutter
- Dart
- GetX for state management

## Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/fidanp/pharmacist-shift-scheduler.git
    ```
2. Install dependencies:
    ```bash
    flutter pub get
    ```
3. Run the app:
    ```bash
    flutter run
    ```

## Usage
1. Open the app and input the list of pharmacists or import from excel with names of pharmacist on a column.
2. Select the year and month for which you want to generate the shift schedule.
3. View the shift assignments by selecting any day from the calendar.

## Features
- **Shift Assignment**: Fair distribution of Morning, Afternoon, and Evening shifts.
- **Weekend Shift Handling**: Special consideration for weekend shifts.
- **Dynamic Scheduling**: The app supports any number of pharmacists.

## Code Quality
The code is structured in a modular fashion, with separate files for shift scheduling logic, UI, and controllers. Error handling is implemented to ensure smooth scheduling.

## Scalability
The app supports any number of pharmacists and dynamically adjusts the schedule to handle larger datasets efficiently.

## Known Issues
- No automated optimization for pharmacist preferences (ie, preferred shifts).
- Weekends are assigned based on availability rather than preference.

### Scheduling Algorithm
The goal of this scheduling algorithm is to fairly assign pharmacists to shifts, ensuring that each one works an equal number of shifts throughout the month. The algorithm uses a round-robin approach, ie it rotates through the list of pharmacists to assign them to different shifts each day.

Initialization:

The list of pharmacists is provided, along with the month and year for scheduling.

Each pharmacist’s shift counts are tracked (morning, afternoon, evening, and weekend shifts).

Shift Distribution:

For each day, need to assign pharmacists to morning, afternoon, and evening shifts.

calculated how many shifts each pharmacist should work for a fair distribution.

Round-Robin Assignment:

The algorithm assigns shifts by going through the list of pharmacists one by one. It starts with the first pharmacist for the morning shift, then the next for the afternoon shift, and so on. Once all pharmacists have assigned a shift then loops back to the first pharmacist.

This process helps ensure that the shifts are distributed as evenly as possible across all pharmacists.

Weekend Shifts:

If the day is a weekend (Saturday or Sunday), the algorithm ensures that weekend shifts are assigned fairly as well, without overloading any particular pharmacist.

Handling Unassigned Pharmacists:

After assigning pharmacists to the main shifts, if any pharmacist remains unassigned for the day, the algorithm checks the available shifts and assigns them accordingly, making sure to maintain fairness.

Final Schedule:

The final schedule for the entire month is generated, ensuring that each pharmacist works a similar number of shifts, including weekend shifts, while keeping the distribution as fair as possible.

