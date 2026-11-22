# PupMatch
### COP4655 - Group 13

## App Overview

PupMatch is a mobile application designed to help dog owners connect with other owners who are looking for compatible breeding matches for their dogs.

Inspired by Tinder's swipe-based interface, PupMatch allows users to create detailed profiles for their dogs, browse nearby dogs, and express interest by swiping right or left. When two owners mutually express interest, a match is created, allowing them to communicate through an in-app messaging system.

Our goal is to create a simple, engaging, and user-friendly platform that makes finding compatible matches for dogs more convenient and organized.

## App Evaluation

### Category
Social / Lifestyle (Pets)

### Mobile
PupMatch is designed specifically for smartphones. Users can take and upload photos of their dogs, discover nearby profiles using location services, and communicate with other dog owners directly through their mobile devices.

The swipe-based interface provides an interactive experience that is well suited for touchscreen devices.

### Story
Finding compatible breeding partners for dogs can be difficult and time-consuming. Dog owners often rely on social media groups, online forums, or personal connections to locate potential matches.

PupMatch simplifies this process by offering a centralized platform where owners can create dog profiles, discover potential matches, and communicate after expressing mutual interest.

### Market
Our target audience includes dog owners and small breeders who want to find compatible breeding partners for their dogs.

The application focuses on a specific audience within the pet community, with potential opportunities to expand its features in the future.

### Habit
Users may return to PupMatch regularly to discover new dog profiles, review their matches, and respond to messages.

New profiles, mutual matches, and ongoing conversations provide reasons for users to continue engaging with the application.

### Scope
Our initial development will focus on the application's core functionality:

- User authentication
- Dog profile creation and editing
- Swipe-based browsing
- Mutual matching
- In-app messaging
- Navigation between application screens

These features provide a manageable foundation for the project.

Additional functionality, including advanced filters, push notifications, breeder verification, and health documentation, may be implemented after the core features are completed.

Firebase is being considered as a backend solution for authentication, data storage, and messaging.

## App Specifications

### Required User Features (MVP)

#### 1. User Authentication
- Users can create an account.
- Users can log in to their existing account.
- Users can securely log out.

#### 2. Dog Profile Management
- Users can create a profile for their dog.
- Users can upload a profile photo.
- Users can enter their dog's information:
  - Name
  - Breed
  - Age
  - Sex
  - Size
- Users can edit and update their dog's profile.

#### 3. Swipe-Based Discovery
- Users can browse profiles of other dogs.
- Each profile displays the dog's photo and basic information.
- Swiping right indicates interest.
- Swiping left passes on the profile.

#### 4. Mutual Matching
- A match occurs when two owners swipe right on each other's dogs.
- Users receive an in-app indication when a mutual match occurs.
- Users can view their existing matches.

#### 5. Messaging
- Matched owners can exchange messages.
- Users can open conversations from their match list.
- Messaging is restricted to mutually matched users.

### Optional Features (Stretch Goals)

The following features may be implemented if time permits:

- Filter profiles by breed, age, and distance.
- Push notifications for new matches and messages.
- Multiple photos per dog profile.
- Undo the previous swipe.
- Breeder verification badges.
- Optional health and vaccination records.
- Unmatch, block, or report a user.
- Advanced profile customization.

## Application Screens

### 1. Login / Sign Up Screen
Allows new users to create an account and returning users to log in.

Main elements:
- Email input
- Password input
- Sign Up button
- Login button

### 2. Create / Edit Profile Screen
Allows users to create or update their dog's profile.

Main elements:
- Dog profile photo
- Dog name
- Breed
- Age
- Sex
- Size
- Save Profile button

### 3. Swipe (Home) Screen
The main screen where users discover other dogs.

Main elements:
- Swipeable dog profile cards
- Dog photo and information
- Like button
- Pass button
- Bottom navigation bar

Users swipe right to like a dog or left to pass.

### 4. Matches Screen
Displays a list of dogs that have mutually matched with the user's dog.

Main elements:
- Matched dog photos
- Dog names
- List of existing matches
- Option to open a conversation

### 5. Chat Screen
Allows owners of matched dogs to communicate.

Main elements:
- Match name and profile photo
- Conversation history
- Message input field
- Send button
- Back navigation

### 6. Profile Screen
Displays the user's dog profile and account options.

Main elements:
- Dog profile photo
- Dog information
- Edit Profile button
- Logout button

## Navigation

PupMatch will use a bottom navigation bar with three primary tabs:

1. Swipe
2. Matches
3. Profile

### Navigation Flow

#### New User Flow
Sign Up -> Create Dog Profile -> Swipe Screen

New users register, create their dog's profile, and begin browsing potential matches.

#### Returning User Flow
Login -> Swipe Screen

Returning users log in and are directed to the main discovery screen.

#### Matching Flow
Swipe Right -> Mutual Match -> Match Notification -> Chat

When two owners express mutual interest, the application displays a match notification and provides an option to start a conversation.

#### Messaging Flow
Matches -> Select Match -> Chat -> Back to Matches

Users can select a match, exchange messages, and return to their match list.

#### Profile Management Flow
Profile -> Edit Profile -> Save Changes -> Profile

Users can view and update their dog's information.

#### Logout Flow
Profile -> Logout -> Login Screen

Users can securely log out from the Profile screen.

## Privacy and Safety Considerations

Since PupMatch involves user profiles, location information, and direct messaging, privacy and safety are important considerations.

- Users should grant permission before location information is accessed.
- Exact home addresses should not be publicly displayed.
- Communication should be limited to mutually matched users.
- Account information should be stored securely.
- Blocking and reporting functionality may be added in future updates.
- Breeder verification and health documentation, if implemented, should not be treated as guarantees of breeding suitability.

## Wireframes

Low-fidelity wireframes will illustrate the application's main screens and navigation.

### 1. Login / Sign Up
Wireframe to be added.

### 2. Create / Edit Profile
Wireframe to be added.

### 3. Swipe Screen
Wireframe to be added.

### 4. Matches Screen
Wireframe to be added.

### 5. Chat Screen
Wireframe to be added.

### 6. Profile Screen
Wireframe to be added.

## User Stories & Sprint Breakdown

### Summary by Assignee
- **Christopher Campbell:** #5 (Sprint 1), #8 (Sprint 2), #15 (Sprint 2), #17 (Sprint 2), #19 (Sprint 3)
- **lenynmur13:** #1 (Sprint 1), #10 (Sprint 2), #13 (Sprint 2), #23 (Sprint 3)
- **menna-akl:** #4 (Sprint 1), #6 (Sprint 1), #7 (Sprint 2), #9 (Sprint 2), #16 (Sprint 2), #18 (Sprint 3), #21 (Sprint 3)
- **AlianRodriguez1998:** #2 (Sprint 1), #11 (Sprint 2), #12 (Sprint 2), #22 (Sprint 3), #24 (Sprint 3)
- **lauracasilla16-create:** #3 (Sprint 1), #14 (Sprint 2), #20 (Sprint 3)

---

### Sprint 1

#### Story #1 - Wire Authentication and Log In to Firebase
- **Assigned To:** lenynmur13
- **Story:** As a dog owner, I want to authenticate and log in with Firebase so that my account and pup profile stay securely associated with me.
- **Acceptance Criteria:**
  - Users can sign up and log in using Firebase Authentication.
  - Authentication session state is handled reliably across app launches.
  - Invalid credentials display clear feedback without crashing the app.
- **Description of Work:** Configured Firebase Authentication integration and connected user sign-in/session handling to the app backend.
- **Hours Worked:** 4 hrs

#### Story #2 - Dog Data Readability in Code
- **Assigned To:** AlianRodriguez1998
- **Story:** As a developer, I want dog profile data to be cleanly parsed and readable in code so that screens can display accurate pup details.
- **Acceptance Criteria:**
  - Dog attributes (such as name, breed, age, sex, and size) map cleanly to Swift properties.
  - Missing or optional fields are handled safely without runtime errors.
  - Sample or retrieved dog records render accurately in views.
- **Description of Work:** Verified and structured dog data reading and decoding logic so Swift views can consume dog attributes cleanly.
- **Hours Worked:** 3 hrs

#### Story #3 - Align UI with Wireframes and Prototypes
- **Assigned To:** lauracasilla16-create
- **Story:** As a user, I want the app screens to reflect the planned wireframes and prototypes so that navigation and layout feel consistent.
- **Acceptance Criteria:**
  - Core screens match the planned layout structure and visual hierarchy from wireframes.
  - Primary interactive controls and labels are clearly positioned.
  - Screen layouts adapt cleanly across standard iOS screen sizes.
- **Description of Work:** Built initial interface layouts aligned with the team's approved wireframes and screen prototypes.
- **Hours Worked:** 4 hrs

#### Story #4 - Repository Organization and Setup
- **Assigned To:** menna-akl
- **Story:** As a team member, I want the GitHub repository and project board organized so that everyone can collaborate smoothly.
- **Acceptance Criteria:**
  - Repository structure, documentation, and issue tracking are clearly organized.
  - Team members have access and clear issue assignments.
  - Project board columns and milestones reflect sprint planning.
- **Description of Work:** Set up and organized the GitHub repository structure, project board, and sprint tracking workflow for Group 13.
- **Hours Worked:** 3 hrs

#### Story #5 - Project Documentation in README
- **Assigned To:** Christopher Campbell
- **Story:** As a team member and reviewer, I want changes and milestone progress documented in `readme.md` so that the project stays accurate and up to date.
- **Acceptance Criteria:**
  - `readme.md` reflects current features, architecture notes, and progress updates.
  - Formatting is clear, readable, and consistent across sections.
  - Changes are committed cleanly to the repository.
- **Description of Work:** Documented project updates, user stories, and sprint progress in `readme.md` in alignment with milestone requirements.
- **Hours Worked:** 3 hrs

#### Story #6 - Create Shared Xcode Project
- **Assigned To:** menna-akl
- **Story:** As a team member, I want a shared Xcode project initialized in the repository so that the team can build and run the iOS app together.
- **Acceptance Criteria:**
  - `PupMatch.xcodeproj` is present in the repository with a valid iOS app target.
  - Project builds cleanly in Xcode without missing core target files.
  - Team members can pull the project and add Swift source files.
- **Description of Work:** Initialized the `PupMatch` Xcode project and committed the project setup to the shared repository.
- **Hours Worked:** 3 hrs

---

### Sprint 2

#### Story #7 - Define and Complete Data Models
- **Assigned To:** menna-akl
- **Story:** As a developer, I want complete Swift data models for users, dogs, swipes, matches, and messages so that Firestore reads and writes are strongly typed.
- **Acceptance Criteria:**
  - Data models accurately represent required fields for dogs, matches, and chat messages.
  - Models conform to `Codable` / `Identifiable` as needed for SwiftUI and Firestore.
  - Type mismatches between client models and database documents are prevented.
- **Description of Work:** Defined and completed the core Swift data models used across profile setup, matching, and messaging workflows.
- **Hours Worked:** 4 hrs

#### Story #8 - Set Up App Navigation
- **Assigned To:** Christopher Campbell
- **Story:** As a user, I want intuitive navigation across authentication, profile setup, discovery, matches, and profile tabs so that I can move through the app seamlessly.
- **Acceptance Criteria:**
  - Users transition cleanly between authentication, profile creation, and main app navigation.
  - Bottom tab navigation switches between main app views without breaking navigation stacks.
  - Detail views (such as chat or profile editing) push and pop predictably.
- **Description of Work:** Implemented the application's navigation structure and tab/stack routing to connect core screens smoothly.
- **Hours Worked:** 4 hrs

#### Story #9 - Build Login and Sign-Up Screens (UI)
- **Assigned To:** menna-akl
- **Story:** As a user, I want clean login and sign-up screens so that I can register a new account or sign into an existing one.
- **Acceptance Criteria:**
  - Login and sign-up screens include email and password inputs plus primary action buttons.
  - Users can toggle or navigate between logging in and creating a new account.
  - Form layout is clear, accessible, and ready for authentication wiring.
- **Description of Work:** Created the SwiftUI user interface for the login and sign-up flows.
- **Hours Worked:** 3 hrs

#### Story #10 - Update README Documentation
- **Assigned To:** lenynmur13
- **Story:** As a team member, I want the `readme.md` updated with current sprint progress and specifications so that documentation stays current.
- **Acceptance Criteria:**
  - Completed features and sprint updates are reflected in `readme.md`.
  - Previous milestone sections remain preserved.
  - Changes are pushed to the repository branch/main cleanly.
- **Description of Work:** Updated `readme.md` with current project progress and milestone details.
- **Hours Worked:** 2 hrs

#### Story #11 - Build Dog Profile Creation Form
- **Assigned To:** AlianRodriguez1998
- **Story:** As a dog owner, I want a form to enter my dog's details and match preferences so that I can set up a complete profile.
- **Acceptance Criteria:**
  - Form captures dog name, breed, age, sex, and size (plus desired match preferences).
  - Required fields are validated before saving.
  - Form state updates smoothly and triggers profile submission.
- **Description of Work:** Built the dog profile creation form UI and input state handling for registering a pup's details.
- **Hours Worked:** 4 hrs

#### Story #12 - Photo Upload with PhotosPicker and Firebase Storage
- **Assigned To:** AlianRodriguez1998
- **Story:** As a dog owner, I want to pick a photo from my library and upload it to Firebase Storage so that my dog's profile displays a real picture.
- **Acceptance Criteria:**
  - Users can select an image from their photo library using `PhotosPicker`.
  - Selected images upload to Firebase Storage and return a valid download URL.
  - Upload progress and errors are handled gracefully.
- **Description of Work:** Integrated `PhotosPicker` and Firebase Storage upload logic to store dog profile photos and retrieve their URLs.
- **Hours Worked:** 5 hrs

#### Story #13 - Save and Fetch Dog Profiles in Firestore
- **Assigned To:** lenynmur13
- **Story:** As a dog owner, I want my dog's profile saved to and fetched from Firestore so that profile data persists across sessions and devices.
- **Acceptance Criteria:**
  - Creating or updating a dog profile writes structured documents to Cloud Firestore.
  - Existing dog profiles can be queried and loaded back into the app.
  - Write/read errors are caught and surfaced cleanly.
- **Description of Work:** Implemented Firestore create, save, and fetch operations for dog profile documents.
- **Hours Worked:** 4 hrs

#### Story #14 - Build Swipe Card View with Gestures and Animations
- **Assigned To:** lauracasilla16-create
- **Story:** As a user, I want interactive swipeable cards with drag, rotation, and like/pass animations so that browsing dogs feels responsive and engaging.
- **Acceptance Criteria:**
  - Cards drag horizontally with smooth rotation and visual feedback.
  - Swiping right or left (or tapping like/pass controls) triggers clear card exit animations.
  - Card stack updates smoothly to reveal the next dog profile.
- **Description of Work:** Built the swipeable dog card component with drag gestures, rotation physics, and like/pass animations.
- **Hours Worked:** 5 hrs

#### Story #15 - Load Swipe Deck Excluding Own Dog and Swiped Dogs
- **Assigned To:** Christopher Campbell
- **Story:** As a user, I want the swipe deck to load eligible dogs from Firestore while skipping my own dog and dogs I have already swiped on so that I don't see duplicates.
- **Acceptance Criteria:**
  - Queries Cloud Firestore for candidate dog profiles.
  - Excludes the current user's own dog profile from the deck.
  - Filters out any dogs already swiped left or right by the current user.
- **Description of Work:** Implemented Firestore swipe-deck loading and client/query filtering to exclude the user's own dog and previously swiped profiles.
- **Hours Worked:** 4 hrs

#### Story #16 - Mutual Like Detection and Match Document Creation
- **Assigned To:** menna-akl
- **Story:** As a dog owner, I want a Match record created when two owners swipe right on each other so that we can connect and message.
- **Acceptance Criteria:**
  - Recording a right swipe checks whether the other dog has already liked the current dog.
  - When mutual interest exists, a new `Match` document is created in Firestore.
  - Duplicate match documents are avoided for the same pair.
- **Description of Work:** Implemented mutual right-swipe detection logic and Firestore `Match` document creation upon a match.
- **Hours Worked:** 4 hrs

#### Story #17 - Build Matches List Screen
- **Assigned To:** Christopher Campbell
- **Story:** As a matched user, I want to view a list of all my dog's matches so that I can see who we matched with and open a conversation.
- **Acceptance Criteria:**
  - Displays matched dogs with their names and photos/avatars.
  - Updates dynamically when new matches are created.
  - Tapping a match navigates to the corresponding chat view.
- **Description of Work:** Built the Matches list screen displaying mutual matches and wiring navigation into individual chat threads.
- **Hours Worked:** 4 hrs

---

### Sprint 3

#### Story #18 - Build Chat Screen UI
- **Assigned To:** menna-akl
- **Story:** As a matched user, I want a chat interface with message bubbles and a text input bar so that I can read and compose messages easily.
- **Acceptance Criteria:**
  - Displays incoming and outgoing messages distinctly in a scrollable list.
  - Includes a message input field and send button anchored cleanly at the bottom.
  - Empty messages cannot be sent accidentally.
- **Description of Work:** Created the SwiftUI chat screen layout with message bubbles, scroll behavior, and message input bar.
- **Hours Worked:** 4 hrs

#### Story #19 - Add Real-Time Messaging with Firestore Listeners
- **Assigned To:** Christopher Campbell
- **Story:** As a matched user, I want messages to send and appear in real time using Firestore listeners so that conversations feel live and immediate.
- **Acceptance Criteria:**
  - Sending a message writes the message document to Firestore under the match conversation.
  - Firestore snapshot listeners stream new messages in real time to active participants.
  - Listeners are properly cleaned up when leaving the chat view.
- **Description of Work:** Implemented real-time message sending and Firestore snapshot listeners for live chat updates.
- **Hours Worked:** 5 hrs

#### Story #20 - Add Filters for Breed, Age Range, and Distance
- **Assigned To:** lauracasilla16-create
- **Story:** As a user, I want to filter potential matches by breed, age range, and distance so that I can find compatible dogs faster.
- **Acceptance Criteria:**
  - Users can select or adjust filter options for breed, age range, and distance.
  - Discovery results update according to active filter criteria.
  - Users can reset or clear applied filters.
- **Description of Work:** Implemented filter controls and filtering logic for breed, age range, and distance.
- **Hours Worked:** 4 hrs

#### Story #21 - Add Profile Editing and Dog Profile Deletion
- **Assigned To:** menna-akl
- **Story:** As a dog owner, I want to edit my dog's profile information or delete a dog profile so that my account stays accurate.
- **Acceptance Criteria:**
  - Users can edit existing dog profile fields and save updates to Firestore.
  - Users can delete a dog profile with confirmation handling.
  - Changes reflect immediately across profile and discovery views.
- **Description of Work:** Added profile editing and dog profile deletion functionality backed by Firestore updates.
- **Hours Worked:** 4 hrs

#### Story #22 - UI Polish (App Icon, Colors, Fonts, Empty & Loading States)
- **Assigned To:** AlianRodriguez1998
- **Story:** As a user, I want polished branding, typography, colors, and loading/empty states so that the app feels complete and reliable.
- **Acceptance Criteria:**
  - App icon, color palette, and typography are consistently applied.
  - Loading indicators appear during network/Firestore operations.
  - Helpful empty states display when there are no cards or matches yet.
- **Description of Work:** Applied visual polish across the app including app icon, cohesive colors/fonts, loading indicators, and empty states.
- **Hours Worked:** 4 hrs

#### Story #23 - Physical iPhone Testing and Bug Fixes
- **Assigned To:** lenynmur13
- **Story:** As a team member, I want to test PupMatch on a physical iPhone and fix bugs found so that real-device behavior is verified before demo day.
- **Acceptance Criteria:**
  - App installs and runs on a physical iPhone device.
  - Bugs discovered during device testing (layout, auth, Firestore, or navigation issues) are resolved.
  - Core user flows complete without crashes.
- **Description of Work:** Tested the build on a physical iPhone and resolved device-specific bugs and UI/runtime issues.
- **Hours Worked:** 4 hrs

#### Story #24 - Finalize README and Create Demo Screenshots/Video
- **Assigned To:** AlianRodriguez1998
- **Story:** As a team, we want a finalized `readme.md` with demo screenshots/video so that our capstone submission and Demo Day presentation are ready.
- **Acceptance Criteria:**
  - `readme.md` is complete, accurate, and preserves prior milestone documentation.
  - Demo screenshots, GIFs, or video links are included and viewable.
  - All deliverables for the milestone are verified in the repository.
- **Description of Work:** Finalized `readme.md` documentation and prepared demo screenshots/video assets for submission and Demo Day.
- **Hours Worked:** 3 hrs

## Future Improvements

After completing the minimum viable product, our group may explore additional features such as:

- Advanced matching filters
- Push notifications
- Breeder verification
- Additional profile customization
- Health and vaccination documentation
- Improved location-based discovery

Our priority is to develop a functional, reliable application that demonstrates the core concepts of mobile app development.

## Project Goal

Our goal is to develop a simple and interactive mobile application that helps dog owners connect through profile discovery, mutual matching, and messaging.

By focusing on an intuitive user experience and manageable core features, PupMatch will demonstrate important mobile development concepts while providing a foundation for future improvements.
```[cite: 20]
