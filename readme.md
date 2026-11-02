
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
