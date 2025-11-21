# Requirements Document

## Introduction

The Bali Calendar application is a comprehensive mobile calendar system that integrates traditional Balinese Hindu calendar systems (Saka and Pawukon) with modern mobile technology. The application serves as both a calendar tool and a cultural assistant, providing users with complete information about Balinese holy days, weton calculations, and AI-powered recommendations for auspicious days based on traditional Balinese spiritual and cultural practices.

## Glossary

- **Bali Calendar App**: The mobile application system that displays and calculates Balinese calendar information
- **Saka Calendar**: The lunar-based Balinese Hindu calendar system with 12 sasih (months)
- **Pawukon Calendar**: The 210-day cyclical Balinese calendar system
- **Wuku**: One of 30 weeks in the Pawukon cycle, each lasting 7 days
- **Weton**: A person's birth day calculated using the Pawukon system
- **Wewaran**: Complete cycle system in Pawukon calendar from Eka Wara to Dasa Wara
- **Eka Wara**: 1-day cycle (Luang/Not Luang)
- **Dwi Wara**: 2-day cycle (Menga/Pepet)
- **Tri Wara**: 3-day cycle (Pasah/Beteng/Kajeng)
- **Catur Wara**: 4-day cycle (Sri/Laba/Jaya/Menala)
- **Panca Wara**: 5-day cycle (Umanis/Paing/Pon/Wage/Kliwon)
- **Sad Wara**: 6-day cycle (Tungleh/Aryang/Urukung/Paniron/Was/Maulu)
- **Sapta Wara**: 7-day cycle (Redite/Soma/Anggara/Buda/Wraspati/Sukra/Saniscara)
- **Asta Wara**: 8-day cycle (Sri/Indra/Guru/Yama/Ludra/Brahma/Kala/Uma)
- **Sanga Wara**: 9-day cycle (Dangu/Jangur/Gigis/Nohan/Ogan/Erangan/Urungan/Tulus/Dadi)
- **Dasa Wara**: 10-day cycle (Pandita/Pati/Suka/Duka/Sri/Manuh/Manusa/Raja/Dewa/Raksasa)
- **Urip/Neptu**: Spiritual energy value associated with each wewaran component
- **Hari Raya**: Hindu Balinese holy days and religious celebrations
- **Dewasa Ayu**: Auspicious days suitable for specific activities
- **Otonan**: Balinese birthday celebration occurring every 210 days
- **Calendar Engine**: The calculation system that generates Saka and Pawukon dates
- **Notification Service**: The system component that sends reminders for holy days
- **Weton Calculator**: The component that calculates and classifies user weton
- **AI Recommender**: The system that suggests auspicious days based on user goals

## Requirements

### Requirement 1: Saka Calendar Display

**User Story:** As a Balinese Hindu practitioner, I want to view the Saka calendar dates, so that I can track lunar months and religious observances according to traditional timekeeping.

#### Acceptance Criteria

1. WHEN the user opens the Bali Calendar App, THE Bali Calendar App SHALL display the current Saka year, sasih name, and penanggal or panglong number
2. WHEN the user selects any Gregorian date, THE Bali Calendar App SHALL convert and display the corresponding Saka calendar date
3. THE Bali Calendar App SHALL calculate Saka dates using astronomical rules without requiring external API calls
4. WHEN the Saka month transitions from penanggal 15 to panglong 1, THE Bali Calendar App SHALL display the correct phase indicator
5. THE Bali Calendar App SHALL display all 12 sasih names (Kasa, Karo, Katiga, Kapat, Kalima, Kanem, Kapitu, Kawolu, Kasanga, Kadasa, Jyesta, Sadha) accurately

### Requirement 2: Pawukon Calendar Display with Complete Wewaran

**User Story:** As a user interested in Balinese culture, I want to see the complete Pawukon calendar information including all wewaran cycles for any date, so that I can understand the cyclical patterns and their cultural significance.

#### Acceptance Criteria

1. WHEN the user views any date, THE Bali Calendar App SHALL display the corresponding wuku name (1 of 30 wuku)
2. WHEN the user views any date, THE Bali Calendar App SHALL display all 10 wewaran values (Eka Wara through Dasa Wara) for that date
3. THE Bali Calendar App SHALL calculate Pawukon dates using the 210-day cycle algorithm without hardcoded date mappings
4. WHEN the Pawukon cycle completes 210 days, THE Bali Calendar App SHALL reset to the first wuku (Sinta) and continue the cycle
5. THE Bali Calendar App SHALL display all cycle components simultaneously for each date
6. THE Bali Calendar App SHALL calculate and display the urip/neptu value for each wewaran component
7. WHEN special rules apply (Jaya Tiga, Kala Tiga, Dangu Pat), THE Bali Calendar App SHALL correctly apply these exceptions in wewaran calculations

### Requirement 3: Holy Days Database

**User Story:** As a Balinese Hindu practitioner, I want to see all Hindu Balinese holy days marked on the calendar, so that I can prepare for religious ceremonies and observances.

#### Acceptance Criteria

1. THE Bali Calendar App SHALL display Purnama (full moon) and Tilem (new moon) dates for each month
2. THE Bali Calendar App SHALL display Kajeng Kliwon dates (occurring every 15 days)
3. THE Bali Calendar App SHALL display major Hari Raya including Galungan, Kuningan, Nyepi, Saraswati, Pagerwesi, and Siwaratri
4. THE Bali Calendar App SHALL display all six Tumpek celebrations (Landep, Wariga, Kandang, Wayang, Krulut, Uduh)
5. THE Bali Calendar App SHALL display Anggara Kasih and Buda Cemeng dates
6. WHEN the user selects a holy day, THE Bali Calendar App SHALL display the name, description, and cultural significance
7. THE Bali Calendar App SHALL store holy day data in editable JSON format for dates spanning 2025 through 2035

### Requirement 4: Calendar Visualization

**User Story:** As a mobile app user, I want to see a modern, intuitive calendar interface, so that I can easily navigate dates and identify important days at a glance.

#### Acceptance Criteria

1. THE Bali Calendar App SHALL display a monthly calendar view with Gregorian dates as the primary display
2. WHEN a date contains a holy day, THE Bali Calendar App SHALL display a colored indicator dot on that date
3. THE Bali Calendar App SHALL use gold color indicators for Hari Suci (holy days)
4. THE Bali Calendar App SHALL use blue color indicators for Purnama and Tilem
5. THE Bali Calendar App SHALL use red color indicators for Kajeng Kliwon
6. WHEN the user taps on any date, THE Bali Calendar App SHALL display a bottom sheet with complete Saka, Pawukon, and holy day information
7. THE Bali Calendar App SHALL support smooth transitions and animations with frame rates above 30 frames per second

### Requirement 5: Weton Calculator with Complete Wewaran

**User Story:** As a user, I want to calculate my weton based on my birth date with complete wewaran information, so that I can understand my Balinese astrological profile and otonan schedule.

#### Acceptance Criteria

1. WHEN the user enters a birth date, THE Bali Calendar App SHALL calculate the corresponding weton including wuku and all 10 wewaran cycles
2. WHEN the weton is calculated, THE Bali Calendar App SHALL display the otonan classification and characteristics based on total urip/neptu value
3. THE Bali Calendar App SHALL calculate the next otonan date (210 days from the last otonan)
4. WHEN the user saves their birth date, THE Bali Calendar App SHALL store the complete weton information locally
5. THE Bali Calendar App SHALL display the weton calculation results in a visually appealing format with cultural context
6. THE Bali Calendar App SHALL display the total urip/neptu value calculated from all wewaran components
7. WHEN displaying weton, THE Bali Calendar App SHALL show all 10 wewaran values with their respective urip values

### Requirement 6: Smart Notifications

**User Story:** As a busy practitioner, I want to receive notifications for upcoming holy days, so that I don't miss important religious observances.

#### Acceptance Criteria

1. THE Bali Calendar App SHALL send local notifications for all major Hari Raya at 8:00 AM on the day of the event
2. WHEN the user enables advance notifications, THE Bali Calendar App SHALL send reminders 3 days before major holy days
3. THE Bali Calendar App SHALL allow users to enable or disable notifications for each holy day category (Purnama/Tilem, Kajeng Kliwon, Tumpek, major holidays)
4. WHEN a notification is sent, THE Bali Calendar App SHALL include the holy day name and a brief description
5. THE Bali Calendar App SHALL function without requiring internet connectivity for notification delivery

### Requirement 7: Offline-First Architecture

**User Story:** As a user in areas with limited connectivity, I want the app to work completely offline, so that I can access calendar information anytime without internet access.

#### Acceptance Criteria

1. THE Bali Calendar App SHALL store all calendar calculation algorithms locally within the application
2. THE Bali Calendar App SHALL store all holy day data in local JSON files
3. WHEN the device has no internet connection, THE Bali Calendar App SHALL display all calendar information without degradation
4. THE Bali Calendar App SHALL perform all Saka and Pawukon calculations locally without external API dependencies
5. WHEN the user opens the app for the first time, THE Bali Calendar App SHALL function immediately without requiring data downloads

### Requirement 8: Modern User Interface

**User Story:** As a mobile user, I want a beautiful and modern interface with Balinese cultural aesthetics, so that the app is both functional and culturally authentic.

#### Acceptance Criteria

1. THE Bali Calendar App SHALL implement Material 3 design principles with rounded cards using 24-pixel corner radius
2. THE Bali Calendar App SHALL support both light and dark display modes
3. THE Bali Calendar App SHALL use gold accent colors (#FFD700 or similar) for highlighting important elements
4. THE Bali Calendar App SHALL incorporate subtle Balinese pattern elements in the background design
5. THE Bali Calendar App SHALL use gradient colors inspired by Balinese sunrise and sunset (warm orange to purple tones)
6. WHEN the user navigates between screens, THE Bali Calendar App SHALL display smooth transitions with duration between 200 and 400 milliseconds

### Requirement 9: AI-Powered Day Recommendations

**User Story:** As a user planning important activities, I want AI-powered recommendations for auspicious days, so that I can choose the best dates according to Balinese spiritual and cultural traditions.

#### Acceptance Criteria

1. WHEN the user enters an activity goal, THE Bali Calendar App SHALL analyze Dewasa Ayu principles to identify suitable dates
2. WHEN generating recommendations, THE Bali Calendar App SHALL consider the user's weton if provided
3. WHEN generating recommendations, THE Bali Calendar App SHALL consider Saka calendar phases (penanggal vs panglong)
4. WHEN generating recommendations, THE Bali Calendar App SHALL consider Pawukon cycle combinations
5. WHEN generating recommendations, THE Bali Calendar App SHALL avoid dates that conflict with major holy days
6. THE Bali Calendar App SHALL display 3 recommended dates with explanations of spiritual and cultural reasoning
7. WHEN no suitable dates exist within 90 days, THE Bali Calendar App SHALL inform the user and suggest the next available period

### Requirement 10: Data Management

**User Story:** As a developer or cultural expert, I want to easily update holy day data and calendar rules, so that the app remains accurate and culturally relevant over time.

#### Acceptance Criteria

1. THE Bali Calendar App SHALL store Saka calendar data in JSON format with human-readable field names
2. THE Bali Calendar App SHALL store Pawukon calendar data in JSON format with human-readable field names
3. THE Bali Calendar App SHALL store holy day data in JSON format with fields for name, description, type, and dates
4. WHEN the JSON data files are modified, THE Bali Calendar App SHALL load the updated data on next application launch
5. THE Bali Calendar App SHALL validate JSON data structure on load and display error messages for malformed data
