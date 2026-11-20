# PupMatch Team Guide (Group 13)

PupMatch is a Tinder-style iPhone app for dog owners looking for a breeding match. An owner signs up, creates a profile for their dog, and swipes through other dogs. If two owners both swipe right on each other's dog, it's a match and they can message each other. The app is built in SwiftUI with Firebase as the backend: Firebase Auth for accounts and Firestore for all data. There is no Firebase Storage, because it requires a paid plan, so dog photos are stored inside Firestore as text (see the rules below).

## Setup

Accept the Firebase and GitHub invites, clone the repo, open `PupMatch.xcodeproj`, and wait for the Swift packages to resolve (several minutes the first time). If resolving fails, run File > Packages > Reset Package Caches, then File > Packages > Resolve Package Versions. Always run on an **iPhone simulator**, leave the Team set to None, and never change the bundle ID (`com.g13.PupMatch`). `GoogleService-Info.plist` is committed on purpose so everyone connects to the same Firebase project. Sign up in the app with your own test email to confirm everything works.

## How the files connect

The code is split into three groups, and data flows in one direction: Views talk to Managers, Managers talk to Firestore, and Models describe the data.

```
PupMatch/
  PupMatchApp.swift     entry point
  Models/               plain data structs (Owner, Dog, Swipe, Match, Message)
  Managers/             all Firebase logic (AuthManager so far)
  Views/                all screens (ContentView, AuthView, HomeView so far)
```

`PupMatchApp.swift` configures Firebase once, creates a single `AuthManager`, and injects it into the whole app with `.environment(auth)`. `ContentView` is the router: if `auth.user` is nil it shows `AuthView` (login and sign up), otherwise it shows `HomeView`, which is a placeholder that will become the real app. Any view that needs the logged-in user reads it with `@Environment(AuthManager.self)`. `auth.user` is the Firebase Auth account, and `auth.owner` is that person's profile document loaded from Firestore. The Auth user's `uid` is also the document ID of the owner in the `users` collection, so you can always find an owner from their uid without a query.

Models are `Codable` structs that map one-to-one onto Firestore documents. `@DocumentID` holds the document's ID and `@ServerTimestamp` is filled in by the server, so leave both as nil when creating a new object. Managers are `@Observable` classes. Each feature gets its own manager (planned: dogs, swipes and matches, chat), the manager does the Firestore reads and writes, and the view just displays whatever the manager exposes.

## The Firestore data

There are four collections. `users` holds owners, with the doc ID equal to the Auth uid. `dogs` holds dog profiles, each with an `ownerId` pointing back to its owner, and the photo lives in the `photoData` field. `swipes` holds one document per swipe with the ID `fromDog_toDog`, so a swipe can never be duplicated, and each swipe stores `fromOwner` and `toOwner` so incoming likes can be queried directly. `matches` holds one document per mutual like, with the ID being the two dog IDs sorted and joined by an underscore, so each pair has exactly one match. It stores `participants` (the two owner uids), the two dog IDs, and `lastMessage` and `lastMessageTime` for the matches list. Chat messages live in a `messages` subcollection under each match.

## The main logic

When an owner swipes right, the app writes a swipe document with direction `like`. It then looks for the reverse swipe (the other dog's owner liking this owner's dog). If that exists, the app creates the match document and shows an "It's a match!" popup with a button to send a message. Until a match document exists, there is no chat. Owners also get a Likes tab that lists swipes where someone liked their dog, so they can see who wants to match and swipe back. Sending a message adds a document to the match's `messages` subcollection and updates `lastMessage` and `lastMessageTime` on the match. The chat screen listens to that subcollection in real time.

## Things to do

Make one branch per GitHub issue, open a pull request into `main`, and pull `main` before you start new work. Put Firestore logic in a Manager, not in a View. Keep your work inside your own feature's files and folders so merges stay clean. Use the Firebase console to inspect your data while testing. Follow the existing style of `@Observable` managers, environment injection, and short inline comments. When a Firestore query throws an error containing a link about an index, click the link, press Create, and wait a minute or two.

## Things not to do

Don't change the five model files or `PupMatchApp.swift` without telling the group, because a change there breaks everyone's code, so those go through a PR all four of us review. Don't call `FirebaseApp.configure()` anywhere else, and don't create a second `AuthManager`. Don't change the bundle ID or the Team, and don't commit `xcuserdata` or `.DS_Store`. Don't add Firebase Storage or any other paid Firebase feature. Photos must be resized to about 600 pixels on the long side and compressed as JPEG (roughly 100 to 200 KB) before being saved as Base64 in `photoData`, since a Firestore document can't exceed 1 MB. Don't push straight to `main`. Don't delete or rename Firestore fields without telling the group, since everyone's models and data depend on them.

## Security rules

The Firestore rules are currently open to any signed-in user, which keeps development simple. They will be tightened in the final sprint so only match participants can read a match's messages, so don't build anything that relies on reading other users' private data without going through the match.
