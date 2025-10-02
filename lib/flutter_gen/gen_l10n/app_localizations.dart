import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'A la carte'**
  String get appTitle;

  /// Main welcome message on home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to A la carte'**
  String get welcomeTitle;

  /// Subtitle describing the app's purpose
  ///
  /// In en, this message translates to:
  /// **'Your personal rating and preference hub'**
  String get welcomeSubtitle;

  /// Header for the item type cards section
  ///
  /// In en, this message translates to:
  /// **'Your Preference Lists'**
  String get yourPreferenceLists;

  /// Title for upcoming categories card
  ///
  /// In en, this message translates to:
  /// **'More Categories'**
  String get moreCategoriesTitle;

  /// Subtitle for upcoming categories
  ///
  /// In en, this message translates to:
  /// **'Additional categories coming soon'**
  String get moreCategoriesSubtitle;

  /// Shows number of items available in a category
  ///
  /// In en, this message translates to:
  /// **'{count} items available'**
  String itemsAvailable(int count);

  /// Shows number of items in user's personal list
  ///
  /// In en, this message translates to:
  /// **'{count} in your list'**
  String inYourList(int count);

  /// Cheese category name
  ///
  /// In en, this message translates to:
  /// **'Cheese'**
  String get cheese;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Profile settings page title
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// Tooltip for theme toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get toggleTheme;

  /// Online connectivity status
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Offline connectivity status
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Checking connectivity status
  ///
  /// In en, this message translates to:
  /// **'Checking connection'**
  String get checkingConnection;

  /// Message shown when offline
  ///
  /// In en, this message translates to:
  /// **'Offline - Your reference lists may not be up to date'**
  String get offlineMessage;

  /// Toast notification when connection is restored
  ///
  /// In en, this message translates to:
  /// **'Connected to A la carte'**
  String get connectedToAlacarte;

  /// Toast notification when connection is lost
  ///
  /// In en, this message translates to:
  /// **'Connection lost - Working offline'**
  String get noInternetConnection;

  /// User selection screen title
  ///
  /// In en, this message translates to:
  /// **'User Selection'**
  String get userSelection;

  /// Create user button/screen
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// Edit user button/screen
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// User name field label
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// Generic name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Type field label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Origin field label
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// Producer field label
  ///
  /// In en, this message translates to:
  /// **'Producer'**
  String get producer;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Create button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Filter button/action
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Clear all filters button
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// Tab title for all items of a type
  ///
  /// In en, this message translates to:
  /// **'All {itemType}s'**
  String allItems(String itemType);

  /// Tab for user's personal rated items
  ///
  /// In en, this message translates to:
  /// **'My List'**
  String get myList;

  /// Rating field/section
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// My rating section label
  ///
  /// In en, this message translates to:
  /// **'My Rating'**
  String get myRating;

  /// Shared ratings section title
  ///
  /// In en, this message translates to:
  /// **'Shared Ratings'**
  String get sharedRatings;

  /// Rate item button/screen title
  ///
  /// In en, this message translates to:
  /// **'Rate Item'**
  String get rateItem;

  /// Add rating button/action
  ///
  /// In en, this message translates to:
  /// **'Add Rating'**
  String get addRating;

  /// Edit rating screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Rating'**
  String get editRating;

  /// Personal notes field
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Rating score field
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Back navigation button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Home navigation
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Generic error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Message when no data is found
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Refresh button/action
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Subtitle on user selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose your profile to access your ratings and preferences'**
  String get chooseProfileSubtitle;

  /// Search field placeholder for profiles
  ///
  /// In en, this message translates to:
  /// **'Search profiles...'**
  String get searchProfiles;

  /// Create new profile button
  ///
  /// In en, this message translates to:
  /// **'Create New Profile'**
  String get createNewProfile;

  /// Delete profile dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// Delete profile confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the profile \"{profileName}\"?'**
  String deleteProfileConfirmation(String profileName);

  /// Message when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No profiles found'**
  String get noProfilesFound;

  /// Help text for empty search results
  ///
  /// In en, this message translates to:
  /// **'Try searching with a different name'**
  String get tryDifferentSearch;

  /// Instruction message when user is already selected
  ///
  /// In en, this message translates to:
  /// **'Currently using: {userName}. Tap a different profile to switch or tap the selected one to continue.'**
  String currentlyUsing(String userName);

  /// Offline message for profile screens
  ///
  /// In en, this message translates to:
  /// **'Offline - Profile changes may not be saved until reconnected'**
  String get offlineProfileChanges;

  /// Create profile form title
  ///
  /// In en, this message translates to:
  /// **'Create Your Profile'**
  String get createYourProfile;

  /// Edit profile form title
  ///
  /// In en, this message translates to:
  /// **'Edit Your Profile'**
  String get editYourProfile;

  /// Placeholder text for name field
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameHint;

  /// Helper text for create profile
  ///
  /// In en, this message translates to:
  /// **'Your profile helps you track your cheese ratings and preferences.'**
  String get profileHelpCreate;

  /// Helper text for edit profile
  ///
  /// In en, this message translates to:
  /// **'Update your profile information.'**
  String get profileHelpEdit;

  /// Current profile section title
  ///
  /// In en, this message translates to:
  /// **'Current Profile'**
  String get currentProfile;

  /// Profile management section title
  ///
  /// In en, this message translates to:
  /// **'Profile Management'**
  String get profileManagement;

  /// Edit profile action
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Edit profile subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your profile information'**
  String get editProfileSubtitle;

  /// Switch profile action
  ///
  /// In en, this message translates to:
  /// **'Switch Profile'**
  String get switchProfile;

  /// Switch profile subtitle
  ///
  /// In en, this message translates to:
  /// **'Change to a different profile'**
  String get switchProfileSubtitle;

  /// Delete profile subtitle
  ///
  /// In en, this message translates to:
  /// **'Permanently delete this profile'**
  String get deleteProfileSubtitle;

  /// Warning message for profile deletion
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All data associated with this profile will be permanently deleted.'**
  String get deleteWarning;

  /// Message when no profile is selected
  ///
  /// In en, this message translates to:
  /// **'No profile selected. Please select a profile first.'**
  String get noProfileSelected;

  /// Back to app button
  ///
  /// In en, this message translates to:
  /// **'Back to App'**
  String get backToApp;

  /// Empty state title
  ///
  /// In en, this message translates to:
  /// **'No Profiles Yet'**
  String get noProfilesYet;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'No profiles found. Create your first profile to get started!'**
  String get noProfilesMessage;

  /// Validation message for required name
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Validation message for name minimum length
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// Validation message for name maximum length
  ///
  /// In en, this message translates to:
  /// **'Name must be less than 50 characters'**
  String get nameMaxLength;

  /// Validation message for invalid name characters
  ///
  /// In en, this message translates to:
  /// **'Name can only contain letters, spaces, hyphens, and apostrophes'**
  String get nameInvalidCharacters;

  /// Tooltip for back to hub button
  ///
  /// In en, this message translates to:
  /// **'Back to Hub'**
  String get backToHub;

  /// Tab title for user's personal list
  ///
  /// In en, this message translates to:
  /// **'My {itemType} List'**
  String myItemList(String itemType);

  /// Add item floating action button
  ///
  /// In en, this message translates to:
  /// **'Add {itemType}'**
  String addItem(String itemType);

  /// Coming soon menu item
  ///
  /// In en, this message translates to:
  /// **'More Categories Coming Soon'**
  String get moreCategoriesComingSoon;

  /// Shared ratings indicator
  ///
  /// In en, this message translates to:
  /// **'Shared ({count})'**
  String shared(int count);

  /// Additional ratings indicator
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String moreRatings(int count);

  /// Rate this item button
  ///
  /// In en, this message translates to:
  /// **'Rate this {itemType}'**
  String rateThisItem(String itemType);

  /// Coming soon message for item types
  ///
  /// In en, this message translates to:
  /// **'{itemType} Coming Soon'**
  String comingSoon(String itemType);

  /// Empty state when no items exist
  ///
  /// In en, this message translates to:
  /// **'No {itemType}s Available'**
  String noItemsAvailable(String itemType);

  /// Instructions for empty state
  ///
  /// In en, this message translates to:
  /// **'Add the first {itemType} to start building your reference list'**
  String addFirstItem(String itemType);

  /// Add first item button
  ///
  /// In en, this message translates to:
  /// **'Add First {itemType}'**
  String addFirstItemButton(String itemType);

  /// Reference list header
  ///
  /// In en, this message translates to:
  /// **'Your {itemType} Reference List'**
  String yourReferenceList(String itemType);

  /// Reference list subtitle
  ///
  /// In en, this message translates to:
  /// **'{count} items with your ratings and recommendations'**
  String itemsWithRatings(int count);

  /// Empty personal list title
  ///
  /// In en, this message translates to:
  /// **'Your {itemType} List is Empty'**
  String yourListEmpty(String itemType);

  /// Empty list instructions
  ///
  /// In en, this message translates to:
  /// **'Rate {itemType}s to build your reference list'**
  String rateItemsToBuild(String itemType);

  /// Explore items button
  ///
  /// In en, this message translates to:
  /// **'Explore {itemType}s'**
  String exploreItems(String itemType);

  /// Item not found error title
  ///
  /// In en, this message translates to:
  /// **'Item Not Found'**
  String get itemNotFound;

  /// Go back button
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Offline message for rating screens
  ///
  /// In en, this message translates to:
  /// **'Offline - Rating data may not be up to date'**
  String get offlineRatingData;

  /// Rate specific item title
  ///
  /// In en, this message translates to:
  /// **'Rate {itemName}'**
  String rateItemName(String itemName);

  /// Offline message for loading screens
  ///
  /// In en, this message translates to:
  /// **'Loading... Connection required for full functionality'**
  String get offlineLoadingMessage;

  /// Connection error message
  ///
  /// In en, this message translates to:
  /// **'Connection error - Please check your network'**
  String get connectionError;

  /// Default offline message
  ///
  /// In en, this message translates to:
  /// **'Offline mode - Showing cached data'**
  String get offlineCachedData;

  /// Label for personal notes section
  ///
  /// In en, this message translates to:
  /// **'My Notes:'**
  String get myNotes;

  /// Message when user hasn't rated an item
  ///
  /// In en, this message translates to:
  /// **'You haven\'t rated {itemName} yet'**
  String haventRatedYet(String itemName);

  /// Instruction to add rating
  ///
  /// In en, this message translates to:
  /// **'Add your rating to build your personal reference list'**
  String get addRatingToBuild;

  /// Title when no ratings exist
  ///
  /// In en, this message translates to:
  /// **'No Ratings Yet'**
  String get noRatingsYet;

  /// Encouragement to rate first
  ///
  /// In en, this message translates to:
  /// **'Be the first to rate {itemName}'**
  String beFirstToRate(String itemName);

  /// Community ratings section title
  ///
  /// In en, this message translates to:
  /// **'Community Ratings'**
  String get communityRatings;

  /// Count of ratings with proper pluralization
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{rating} other{ratings}}'**
  String ratingsCount(int count);

  /// Average rating display
  ///
  /// In en, this message translates to:
  /// **'Average: {rating} / 5.0'**
  String averageRating(String rating);

  /// Most common rating statistic
  ///
  /// In en, this message translates to:
  /// **'Most common: {stars} stars ({count} {count, plural, =1{rating} other{ratings}})'**
  String mostCommonRating(int stars, int count);

  /// Title when no shared ratings exist
  ///
  /// In en, this message translates to:
  /// **'No Recommendations'**
  String get noSharedRatings;

  /// Message when no shared ratings exist
  ///
  /// In en, this message translates to:
  /// **'No one has shared their recommendations for {itemName} with you yet'**
  String noSharedRatingsMessage(String itemName);

  /// Profile ID display
  ///
  /// In en, this message translates to:
  /// **'Profile ID: {id}'**
  String profileIdLabel(String id);

  /// Tooltip for edit profile button
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTooltip;

  /// Tooltip for delete profile button
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfileTooltip;

  /// Label for new profile (no ID yet)
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newProfile;

  /// Origin field label
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get originLabel;

  /// Producer field label
  ///
  /// In en, this message translates to:
  /// **'Producer'**
  String get producerLabel;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// Loading message during app initialization
  ///
  /// In en, this message translates to:
  /// **'Initializing A la carte...'**
  String get initializingApp;

  /// Extended loading message when initialization is slow
  ///
  /// In en, this message translates to:
  /// **'This is taking longer than expected...'**
  String get initializationTakingLonger;

  /// Error message when saved profile data is invalid
  ///
  /// In en, this message translates to:
  /// **'Profile data corrupted. Please select your profile again.'**
  String get profileDataCorrupted;

  /// Error message when saved profile doesn't exist on server
  ///
  /// In en, this message translates to:
  /// **'Your profile was not found. Please select a valid profile.'**
  String get profileNotFoundOnServer;

  /// Your rating section label
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRating;

  /// Helper text for rating selection
  ///
  /// In en, this message translates to:
  /// **'Tap to select rating'**
  String get selectRating;

  /// Validation message for required rating
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get ratingRequired;

  /// Notes section label
  ///
  /// In en, this message translates to:
  /// **'Add your notes'**
  String get addNotes;

  /// Helper text for notes field
  ///
  /// In en, this message translates to:
  /// **'Add your personal notes (optional)'**
  String get notesHelper;

  /// Save rating button text
  ///
  /// In en, this message translates to:
  /// **'Save Rating'**
  String get saveRating;

  /// Success message after creating rating
  ///
  /// In en, this message translates to:
  /// **'Rating saved successfully!'**
  String get ratingCreated;

  /// Error message when rating creation fails
  ///
  /// In en, this message translates to:
  /// **'Could not save rating. Please try again.'**
  String get couldNotSaveRating;

  /// Offline message for rating creation
  ///
  /// In en, this message translates to:
  /// **'Offline - Changes may not be saved until reconnected'**
  String get offlineRatingCreation;

  /// Error when no user is selected
  ///
  /// In en, this message translates to:
  /// **'No user selected'**
  String get noUserSelected;

  /// Dismiss action for snackbars
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// Message when switching users while offline
  ///
  /// In en, this message translates to:
  /// **'Offline - Rating data not available for this user'**
  String get offlineUserSwitch;

  /// Edit rating for specific item title
  ///
  /// In en, this message translates to:
  /// **'Edit Rating for {itemName}'**
  String editRatingForItem(String itemName);

  /// Save changes button text
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Success message after updating rating
  ///
  /// In en, this message translates to:
  /// **'Rating updated successfully!'**
  String get ratingUpdated;

  /// Error message when rating update fails
  ///
  /// In en, this message translates to:
  /// **'Could not update rating. Please try again.'**
  String get couldNotUpdateRating;

  /// Offline message for rating edit
  ///
  /// In en, this message translates to:
  /// **'Offline - Changes may not be saved until reconnected'**
  String get offlineRatingEdit;

  /// Error when rating to edit is not found
  ///
  /// In en, this message translates to:
  /// **'Rating not found'**
  String get ratingNotFound;

  /// Label showing what item is being rated
  ///
  /// In en, this message translates to:
  /// **'Editing rating for'**
  String get editingRatingFor;

  /// Shows the original rating value
  ///
  /// In en, this message translates to:
  /// **'Original rating: {rating} stars'**
  String originalRating(int rating);

  /// Indicator that there are unsaved changes
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes'**
  String get unsavedChanges;

  /// Share rating button text
  ///
  /// In en, this message translates to:
  /// **'Share Rating'**
  String get shareRating;

  /// Share with users action
  ///
  /// In en, this message translates to:
  /// **'Share with...'**
  String get shareWith;

  /// Share rating dialog title
  ///
  /// In en, this message translates to:
  /// **'Share Rating With'**
  String get shareRatingWith;

  /// Instructions for sharing dialog
  ///
  /// In en, this message translates to:
  /// **'Select users to share this rating with'**
  String get selectUsersToShare;

  /// Success message when sharing rating
  ///
  /// In en, this message translates to:
  /// **'Rating shared successfully!'**
  String get shareRatingSuccess;

  /// Error message when sharing fails
  ///
  /// In en, this message translates to:
  /// **'Could not share rating. Please try again.'**
  String get shareRatingError;

  /// Shows number of people rating is shared with
  ///
  /// In en, this message translates to:
  /// **'Shared with {count} {count, plural, =1{person} other{people}}'**
  String sharedWith(int count);

  /// Share button in dialog
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButtonText;

  /// Message when no other users exist
  ///
  /// In en, this message translates to:
  /// **'No users available to share with'**
  String get noUsersAvailable;

  /// Loading message for user list
  ///
  /// In en, this message translates to:
  /// **'Loading users...'**
  String get loadingUsers;

  /// Recommendations section title
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// Shows count of recommendations from friends
  ///
  /// In en, this message translates to:
  /// **'{count} recommendations from friends'**
  String recommendationsFromFriends(int count);

  /// Error when item type is not implemented
  ///
  /// In en, this message translates to:
  /// **'Item type not supported yet'**
  String get itemTypeNotSupported;

  /// Error when rating cannot be edited due to missing or permissions
  ///
  /// In en, this message translates to:
  /// **'Rating not found or you do not have permission to edit it'**
  String get ratingNotFoundOrNoPermission;

  /// Error when user lacks permission to edit a rating
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to edit this rating'**
  String get noPermissionToEdit;

  /// Placeholder when rating has no notes
  ///
  /// In en, this message translates to:
  /// **'No notes added'**
  String get noNotesAdded;

  /// Fallback text when username is not available
  ///
  /// In en, this message translates to:
  /// **'User {userId}'**
  String userFallback(int userId);

  /// Delete rating button text
  ///
  /// In en, this message translates to:
  /// **'Delete Rating'**
  String get deleteRating;

  /// Delete rating dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete this rating?'**
  String get deleteRatingConfirmation;

  /// Warning about permanent deletion
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteRatingWarning;

  /// Warning about sharing impact when deleting
  ///
  /// In en, this message translates to:
  /// **'This will also remove it from {count} {count, plural, =1{person} other{people}} who have access to your recommendation.'**
  String deleteRatingWithSharing(int count);

  /// Generic warning about potential sharing impact
  ///
  /// In en, this message translates to:
  /// **'If this rating has been shared, it will also be removed from other users\' recommendations.'**
  String get deleteRatingGenericSharing;

  /// Success message after deleting rating
  ///
  /// In en, this message translates to:
  /// **'Rating deleted successfully'**
  String get ratingDeleted;

  /// Error message when rating deletion fails
  ///
  /// In en, this message translates to:
  /// **'Could not delete rating. Please try again.'**
  String get couldNotDeleteRating;

  /// Button to make rating private (unshare from all)
  ///
  /// In en, this message translates to:
  /// **'Make Private'**
  String get makePrivate;

  /// Button text when there are no changes to save
  ///
  /// In en, this message translates to:
  /// **'No Changes'**
  String get noChanges;

  /// Add new item button/screen title
  ///
  /// In en, this message translates to:
  /// **'Add New {itemType}'**
  String addNewItem(String itemType);

  /// Edit item screen title
  ///
  /// In en, this message translates to:
  /// **'Edit {itemName}'**
  String editItem(String itemName);

  /// Create item screen title
  ///
  /// In en, this message translates to:
  /// **'Create {itemType}'**
  String createItem(String itemType);

  /// Success message after creating item
  ///
  /// In en, this message translates to:
  /// **'{itemType} created successfully!'**
  String itemCreated(String itemType);

  /// Success message after updating item
  ///
  /// In en, this message translates to:
  /// **'{itemType} updated successfully!'**
  String itemUpdated(String itemType);

  /// Error message when item creation fails
  ///
  /// In en, this message translates to:
  /// **'Could not create {itemType}. Please try again.'**
  String couldNotCreateItem(String itemType);

  /// Error message when item update fails
  ///
  /// In en, this message translates to:
  /// **'Could not update {itemType}. Please try again.'**
  String couldNotUpdateItem(String itemType);

  /// Validation message for required item name
  ///
  /// In en, this message translates to:
  /// **'{itemType} name is required'**
  String itemNameRequired(String itemType);

  /// Validation message for item name minimum length
  ///
  /// In en, this message translates to:
  /// **'{itemType} name must be at least 2 characters'**
  String itemNameTooShort(String itemType);

  /// Validation message for item name maximum length
  ///
  /// In en, this message translates to:
  /// **'{itemType} name must be less than 100 characters'**
  String itemNameTooLong(String itemType);

  /// Validation message for required type field
  ///
  /// In en, this message translates to:
  /// **'Type is required'**
  String get typeRequired;

  /// Validation message for required origin field
  ///
  /// In en, this message translates to:
  /// **'Origin is required'**
  String get originRequired;

  /// Validation message for required producer field
  ///
  /// In en, this message translates to:
  /// **'Producer is required'**
  String get producerRequired;

  /// Dropdown placeholder for type selection
  ///
  /// In en, this message translates to:
  /// **'Select type...'**
  String get selectType;

  /// Placeholder for origin field
  ///
  /// In en, this message translates to:
  /// **'Enter origin'**
  String get enterOrigin;

  /// Placeholder for producer field
  ///
  /// In en, this message translates to:
  /// **'Enter producer'**
  String get enterProducer;

  /// Placeholder for description field
  ///
  /// In en, this message translates to:
  /// **'Enter description (optional)'**
  String get enterDescription;

  /// Validation message for description maximum length
  ///
  /// In en, this message translates to:
  /// **'Description must be less than 500 characters'**
  String get descriptionTooLong;

  /// Offline message for item creation
  ///
  /// In en, this message translates to:
  /// **'Offline - Item may not be saved until reconnected'**
  String get offlineItemCreation;

  /// Offline message for item editing
  ///
  /// In en, this message translates to:
  /// **'Offline - Changes may not be saved until reconnected'**
  String get offlineItemEdit;

  /// Warning message for unsaved changes dialog
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to go back?'**
  String get unsavedChangesMessage;

  /// Discard unsaved changes button
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// Subtitle for edit forms
  ///
  /// In en, this message translates to:
  /// **'Update the information below'**
  String get updateInfoBelow;

  /// Subtitle for create forms
  ///
  /// In en, this message translates to:
  /// **'Fill in the details to add to your collection'**
  String get fillDetailsToAdd;

  /// Loading message when saving
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Hint text for cheese type field
  ///
  /// In en, this message translates to:
  /// **'e.g. Soft, Hard, Semi-soft, Blue'**
  String get cheeseTypeHint;

  /// Hint text for item name field
  ///
  /// In en, this message translates to:
  /// **'Enter {itemType} name'**
  String enterItemName(String itemType);

  /// Helper text for optional fields with character limit
  ///
  /// In en, this message translates to:
  /// **'Optional - up to {maxLength} characters'**
  String optionalFieldHelper(int maxLength);

  /// Title for editing item type
  ///
  /// In en, this message translates to:
  /// **'Edit {itemType}'**
  String editItemType(String itemType);

  /// Title for adding new item type
  ///
  /// In en, this message translates to:
  /// **'Add New {itemType}'**
  String addNewItemType(String itemType);

  /// Label for optional fields
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Hint text for cheese search field
  ///
  /// In en, this message translates to:
  /// **'Search cheeses by name, type, origin...'**
  String get searchCheeseHint;

  /// Title when search/filter returns no results
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get noResultsFound;

  /// Help text for empty search results
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get adjustSearchFilters;

  /// Button to remove all active filters
  ///
  /// In en, this message translates to:
  /// **'Clear All Filters'**
  String get clearAllFilters;

  /// Filter dialog title
  ///
  /// In en, this message translates to:
  /// **'Filter by {category}'**
  String filterBy(String category);

  /// Search results summary
  ///
  /// In en, this message translates to:
  /// **'Showing {filtered} of {total} items'**
  String showingResults(int filtered, int total);

  /// Parameterized search hint for any item type
  ///
  /// In en, this message translates to:
  /// **'Search {itemType}s by name...'**
  String searchItemsByName(String itemType);

  /// Generic search hint for any item type
  ///
  /// In en, this message translates to:
  /// **'Search by name...'**
  String get searchByName;

  /// Hint text for name-only cheese search field
  ///
  /// In en, this message translates to:
  /// **'Search cheeses by name...'**
  String get searchCheeseByNameHint;

  /// Filter chip for user's personal ratings
  ///
  /// In en, this message translates to:
  /// **'My Ratings'**
  String get myRatingsFilter;

  /// Filter chip for items recommended by others
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendationsFilter;

  /// Filter chip for items that have been rated
  ///
  /// In en, this message translates to:
  /// **'Rated'**
  String get ratedFilter;

  /// Filter chip for items that haven't been rated
  ///
  /// In en, this message translates to:
  /// **'Unrated'**
  String get unratedFilter;

  /// Option to show all items in filter dialogs
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilterOption;

  /// Tooltip to expand filter interface
  ///
  /// In en, this message translates to:
  /// **'Show Filters'**
  String get showFilters;

  /// Tooltip to collapse filter interface
  ///
  /// In en, this message translates to:
  /// **'Hide Filters'**
  String get hideFilters;

  /// User profile tooltip
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// Sign out button text
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Sign out confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out? You will need to sign in again to access your ratings.'**
  String get signOutConfirmation;

  /// App preferences section title
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// Dark mode setting title
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Dark mode setting description
  ///
  /// In en, this message translates to:
  /// **'Use dark theme throughout the app'**
  String get darkModeDescription;

  /// Language setting title
  ///
  /// In en, this message translates to:
  /// **'Display Language'**
  String get displayLanguage;

  /// Language setting description
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get displayLanguageDescription;

  /// Profile and account section title
  ///
  /// In en, this message translates to:
  /// **'Profile & Account'**
  String get profileAndAccount;

  /// Display name field title
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// Placeholder for empty display name
  ///
  /// In en, this message translates to:
  /// **'Tap to set display name'**
  String get tapToSetDisplayName;

  /// Edit display name dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Display Name'**
  String get editDisplayName;

  /// Display name field helper text
  ///
  /// In en, this message translates to:
  /// **'This is how other users will see you'**
  String get displayNameHelper;

  /// Success message for display name update
  ///
  /// In en, this message translates to:
  /// **'Display name updated successfully'**
  String get displayNameUpdated;

  /// Error message for display name update
  ///
  /// In en, this message translates to:
  /// **'Error updating display name'**
  String get errorUpdatingDisplayName;

  /// Discoverable setting title
  ///
  /// In en, this message translates to:
  /// **'Discoverable for Sharing'**
  String get discoverableForSharing;

  /// Discoverable setting description
  ///
  /// In en, this message translates to:
  /// **'Allow other users to find you when sharing ratings'**
  String get discoverableDescription;

  /// Message when discoverability is enabled
  ///
  /// In en, this message translates to:
  /// **'You are now discoverable for sharing'**
  String get discoverabilityEnabled;

  /// Message when discoverability is disabled
  ///
  /// In en, this message translates to:
  /// **'You are no longer discoverable for sharing'**
  String get discoverabilityDisabled;

  /// Generic error message for settings update
  ///
  /// In en, this message translates to:
  /// **'Error updating settings'**
  String get errorUpdatingSettings;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App version setting title
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// Privacy policy setting title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Privacy policy setting description
  ///
  /// In en, this message translates to:
  /// **'Learn about your data and privacy'**
  String get learnAboutPrivacy;

  /// Privacy policy content
  ///
  /// In en, this message translates to:
  /// **'A la carte is designed with privacy first. All your ratings are private by default. You choose exactly which ratings to share and with whom. Your email and full name are never shown to other users.'**
  String get privacyPolicyContent;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Danger zone section title
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// Delete account setting title
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Delete account setting description
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get deleteAccountDescription;

  /// Delete account warning message
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all your data. This action cannot be undone.'**
  String get deleteAccountWarning;

  /// Delete account consequences description
  ///
  /// In en, this message translates to:
  /// **'All your ratings, shared content, and profile information will be permanently removed from A la carte.'**
  String get deleteAccountConsequences;

  /// Account deletion success message
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeleted;

  /// Error message for account deletion
  ///
  /// In en, this message translates to:
  /// **'Error deleting account'**
  String get errorDeletingAccount;

  /// Privacy-safe fallback for unknown users
  ///
  /// In en, this message translates to:
  /// **'Anonymous User'**
  String get anonymousUser;

  /// Privacy settings screen title
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// Error when user is not logged in
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get userNotAuthenticated;

  /// Privacy overview section title
  ///
  /// In en, this message translates to:
  /// **'Privacy Overview'**
  String get privacyOverview;

  /// Sharing activity summary title
  ///
  /// In en, this message translates to:
  /// **'Your Sharing Activity'**
  String get yourSharingActivity;

  /// Count of shared ratings
  ///
  /// In en, this message translates to:
  /// **'{count} shared {count, plural, =1{rating} other{ratings}}'**
  String sharedRatingsCount(int count);

  /// Count of unique recipients
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{recipient} other{recipients}}'**
  String recipientsCount(int count);

  /// Discovery settings section title
  ///
  /// In en, this message translates to:
  /// **'Discovery Settings'**
  String get discoverySettings;

  /// Explanation of discoverability setting
  ///
  /// In en, this message translates to:
  /// **'Controls who can find you when sharing new ratings'**
  String get discoverabilityExplanation;

  /// Message when discoverability is disabled with context
  ///
  /// In en, this message translates to:
  /// **'You are no longer discoverable. Existing shared ratings remain accessible.'**
  String get discoverabilityDisabledWithExplanation;

  /// Bulk actions section title
  ///
  /// In en, this message translates to:
  /// **'Bulk Privacy Actions'**
  String get bulkPrivacyActions;

  /// Bulk action to make all ratings private
  ///
  /// In en, this message translates to:
  /// **'Make All Ratings Private'**
  String get makeAllRatingsPrivate;

  /// Description of make all private action
  ///
  /// In en, this message translates to:
  /// **'Remove sharing from all your ratings at once'**
  String get makeAllRatingsPrivateDescription;

  /// Bulk action to remove specific person from all shares
  ///
  /// In en, this message translates to:
  /// **'Remove Person from All Shares'**
  String get removePersonFromAllShares;

  /// Description of remove person action
  ///
  /// In en, this message translates to:
  /// **'Remove a specific person from all your shared ratings'**
  String get removePersonFromAllSharesDescription;

  /// Label for features not yet implemented
  ///
  /// In en, this message translates to:
  /// **'(Coming Soon)'**
  String get comingSoonLabel;

  /// Individual rating management section title
  ///
  /// In en, this message translates to:
  /// **'Manage Individual Shares'**
  String get manageIndividualShares;

  /// Empty state for no shared ratings
  ///
  /// In en, this message translates to:
  /// **'No Shared Ratings Yet'**
  String get noSharedRatingsYet;

  /// Explanation when user has no shared ratings
  ///
  /// In en, this message translates to:
  /// **'All your ratings are currently private. Share ratings to help others discover great items!'**
  String get noSharedRatingsExplanation;

  /// Count of people rating is shared with
  ///
  /// In en, this message translates to:
  /// **'Shared with {count} {count, plural, =1{person} other{people}}'**
  String sharedWithCount(int count);

  /// Tooltip for manage sharing button
  ///
  /// In en, this message translates to:
  /// **'Manage sharing for this rating'**
  String get manageSharingForRating;

  /// Button to view all shared ratings
  ///
  /// In en, this message translates to:
  /// **'View All {count} Shared Ratings'**
  String viewAllSharedRatings(int count);

  /// Warning for bulk make private action
  ///
  /// In en, this message translates to:
  /// **'This will remove sharing from all {count} of your shared ratings. Recipients will no longer see your recommendations.'**
  String makeAllPrivateWarning(int count);

  /// Consequences of bulk make private action
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. You will need to re-share each rating individually if you change your mind.'**
  String get makeAllPrivateConsequences;

  /// Loading message for bulk privacy action
  ///
  /// In en, this message translates to:
  /// **'Making ratings private...'**
  String get makingRatingsPrivate;

  /// Success message for bulk privacy action
  ///
  /// In en, this message translates to:
  /// **'All ratings are now private'**
  String get allRatingsMadePrivate;

  /// Error message for bulk privacy action
  ///
  /// In en, this message translates to:
  /// **'Error making ratings private'**
  String get errorMakingRatingsPrivate;

  /// Generic coming soon message
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get featureComingSoon;

  /// Instruction to use existing share functionality
  ///
  /// In en, this message translates to:
  /// **'Use the share button on the rating to manage sharing'**
  String get useExistingShareDialog;

  /// Description for privacy settings navigation
  ///
  /// In en, this message translates to:
  /// **'Manage your data sharing and privacy controls'**
  String get manageDataSharing;

  /// Message when no recipients exist for removal
  ///
  /// In en, this message translates to:
  /// **'No recipients to remove'**
  String get noRecipientsToRemove;

  /// Instruction for person removal dialog
  ///
  /// In en, this message translates to:
  /// **'Select a person to remove from all your shared ratings:'**
  String get selectPersonToRemove;

  /// Count of ratings shared with specific user
  ///
  /// In en, this message translates to:
  /// **'{count} shared {count, plural, =1{rating} other{ratings}}'**
  String sharedRatingsWithUser(int count);

  /// Remove user from shares dialog title
  ///
  /// In en, this message translates to:
  /// **'Remove User from Shares'**
  String get removeUserFromShares;

  /// Warning for removing user from all shares
  ///
  /// In en, this message translates to:
  /// **'This will remove {userName} from all your shared ratings. They will no longer see your recommendations.'**
  String removeUserWarning(String userName);

  /// Remove user button text
  ///
  /// In en, this message translates to:
  /// **'Remove User'**
  String get removeUser;

  /// Loading message for user removal
  ///
  /// In en, this message translates to:
  /// **'Removing {userName} from shares...'**
  String removingUserFromShares(String userName);

  /// Success message for user removal
  ///
  /// In en, this message translates to:
  /// **'{userName} removed from {count} {count, plural, =1{rating} other{ratings}}'**
  String userRemovedFromShares(String userName, int count);

  /// Error message for user removal
  ///
  /// In en, this message translates to:
  /// **'Error removing user from shares'**
  String get errorRemovingUserFromShares;

  /// Success message when sharing preferences are updated
  ///
  /// In en, this message translates to:
  /// **'Sharing preferences updated successfully'**
  String get sharingPreferencesUpdated;

  /// Success message when rating is unshared from users
  ///
  /// In en, this message translates to:
  /// **'Rating unshared from {count} {count, plural, =1{user} other{users}}'**
  String ratingUnsharedFromUsers(int count);

  /// Description for comprehensive privacy settings navigation
  ///
  /// In en, this message translates to:
  /// **'Manage your privacy and discovery controls'**
  String get managePrivacyAndDiscovery;

  /// Message shown when loading missing item data
  ///
  /// In en, this message translates to:
  /// **'Loading item details...'**
  String get loadingItemDetails;

  /// Message for bulk privacy features not yet implemented
  ///
  /// In en, this message translates to:
  /// **'Bulk privacy actions coming soon'**
  String get bulkPrivacyActionsComingSoon;

  /// Message for remove person feature not yet implemented
  ///
  /// In en, this message translates to:
  /// **'Remove person feature coming soon'**
  String get removePersonFeatureComingSoon;

  /// Error message when rating sharing cannot be managed
  ///
  /// In en, this message translates to:
  /// **'Cannot manage sharing for this rating'**
  String get cannotManageSharing;

  /// Generic error message for sharing update failures
  ///
  /// In en, this message translates to:
  /// **'Error updating sharing'**
  String get errorUpdatingSharing;

  /// Error message when server feature is not available
  ///
  /// In en, this message translates to:
  /// **'Feature not yet implemented on server'**
  String get featureNotImplementedOnServer;

  /// Error message for invalid display name input
  ///
  /// In en, this message translates to:
  /// **'Invalid display name'**
  String get invalidDisplayName;

  /// Instruction for typing display name confirmation
  ///
  /// In en, this message translates to:
  /// **'To confirm deletion, type your display name \"{displayName}\" below:'**
  String typeDisplayNameToConfirm(String displayName);

  /// Loading message during account deletion
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get deletingAccount;

  /// Subtitle for deletion loading dialog
  ///
  /// In en, this message translates to:
  /// **'This may take a moment'**
  String get deletionMayTakeTime;

  /// Warning about irreversible deletion
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Title for operations that require internet
  ///
  /// In en, this message translates to:
  /// **'Connection Required'**
  String get connectionRequired;

  /// Generic message for blocked offline operations
  ///
  /// In en, this message translates to:
  /// **'This operation requires an internet connection'**
  String get offlineOperationBlocked;

  /// No description provided for @connectAndRetry.
  ///
  /// In en, this message translates to:
  /// **'Please connect to the internet and try again'**
  String get connectAndRetry;

  /// Title for no internet connection screen
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnectionTitle;

  /// Title for server unavailable screen
  ///
  /// In en, this message translates to:
  /// **'Server Unavailable'**
  String get serverUnavailableTitle;

  /// Title for connection restored screen
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connectedTitle;

  /// Description for no internet connection screen
  ///
  /// In en, this message translates to:
  /// **'A la carte needs an internet connection to sync your ratings and preferences. Please check your network settings and try again.'**
  String get noInternetConnectionDescription;

  /// Description for server unavailable screen
  ///
  /// In en, this message translates to:
  /// **'A la carte server is temporarily unavailable. This might be due to maintenance or a temporary issue. We\'ll keep trying to reconnect.'**
  String get serverUnavailableDescription;

  /// Description for connection restored screen
  ///
  /// In en, this message translates to:
  /// **'Connection restored! You can now use all features of A la carte.'**
  String get connectionRestoredDescription;

  /// Error message when trying to sign in while offline
  ///
  /// In en, this message translates to:
  /// **'Sign in requires an internet connection'**
  String get signInRequiresConnection;

  /// Error message for server 500 errors
  ///
  /// In en, this message translates to:
  /// **'Server temporarily unavailable. Please try again.'**
  String get serverTemporarilyUnavailable;

  /// Generic connection failure message
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Please check your network and try again.'**
  String get connectionFailedCheckNetwork;

  /// Loading message for preference hub setup
  ///
  /// In en, this message translates to:
  /// **'Setting up your preference hub...'**
  String get settingUpPreferenceHub;

  /// Loading message during account verification
  ///
  /// In en, this message translates to:
  /// **'Verifying account...'**
  String get verifyingAccount;

  /// Loading message when working offline
  ///
  /// In en, this message translates to:
  /// **'Working offline...'**
  String get workingOffline;

  /// Loading message when profile setup is needed
  ///
  /// In en, this message translates to:
  /// **'Profile setup required...'**
  String get profileSetupRequired;

  /// Loading message when initialization is complete
  ///
  /// In en, this message translates to:
  /// **'Ready! Welcome back.'**
  String get readyWelcomeBack;

  /// Loading message when sign in is needed
  ///
  /// In en, this message translates to:
  /// **'Sign in required...'**
  String get signInRequired;

  /// Loading message when preparing user data
  ///
  /// In en, this message translates to:
  /// **'Preparing your preferences...'**
  String get preparingPreferences;

  /// Title for profile completion screen
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeYourProfile;

  /// Welcome message on profile setup screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to A la carte!'**
  String get welcomeToAlacarte;

  /// Personalized setup greeting
  ///
  /// In en, this message translates to:
  /// **'Hi {firstName}! Let\'s set up your profile.'**
  String hiUserSetupProfile(String firstName);

  /// Helper text for display name field
  ///
  /// In en, this message translates to:
  /// **'This is how other users will see you when you share ratings'**
  String get displayNameFieldHelper;

  /// Validation error for empty display name
  ///
  /// In en, this message translates to:
  /// **'Display name is required'**
  String get displayNameRequired;

  /// Validation error for short display name
  ///
  /// In en, this message translates to:
  /// **'Display name must be at least 2 characters'**
  String get displayNameTooShort;

  /// Validation error for long display name
  ///
  /// In en, this message translates to:
  /// **'Display name must be less than 50 characters'**
  String get displayNameTooLong;

  /// Success message when display name is available
  ///
  /// In en, this message translates to:
  /// **'✓ Display name is available'**
  String get displayNameAvailable;

  /// Error message when display name is unavailable
  ///
  /// In en, this message translates to:
  /// **'✗ Display name is already taken'**
  String get displayNameTaken;

  /// Error message when availability check fails
  ///
  /// In en, this message translates to:
  /// **'⚠ Could not check availability'**
  String get couldNotCheckAvailability;

  /// Title for privacy settings section
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettingsTitle;

  /// Label for discoverability toggle
  ///
  /// In en, this message translates to:
  /// **'Discoverable by Others'**
  String get discoverableByOthers;

  /// Helper text for discoverability setting
  ///
  /// In en, this message translates to:
  /// **'Allow other users to find you when sharing ratings. You can change this later in settings.'**
  String get discoverabilityHelper;

  /// Loading message during profile completion
  ///
  /// In en, this message translates to:
  /// **'Setting up profile...'**
  String get settingUpProfile;

  /// Button text to complete profile setup
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeProfile;

  /// Title for privacy information section
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters'**
  String get yourPrivacyMatters;

  /// Explanation of privacy model on setup screen
  ///
  /// In en, this message translates to:
  /// **'All your ratings are private by default. You choose exactly which ratings to share and with whom. Your email and full name are never shown to other users - only your display name.'**
  String get privacyExplanation;

  /// Automatic language option showing detected language
  ///
  /// In en, this message translates to:
  /// **'Auto ({detectedLanguage})'**
  String automaticLanguage(String detectedLanguage);

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Description for automatic language setting
  ///
  /// In en, this message translates to:
  /// **'Follows device language'**
  String get followsDeviceLanguage;

  /// Gin category name
  ///
  /// In en, this message translates to:
  /// **'Gin'**
  String get gin;

  /// Plural gin category name
  ///
  /// In en, this message translates to:
  /// **'Gins'**
  String get gins;

  /// Flavor profile field label for gin
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileLabel;

  /// Placeholder for gin name field
  ///
  /// In en, this message translates to:
  /// **'Enter gin name'**
  String get enterGinName;

  /// Placeholder for profile field
  ///
  /// In en, this message translates to:
  /// **'Enter flavor profile'**
  String get enterProfile;

  /// Hint text for profile field
  ///
  /// In en, this message translates to:
  /// **'e.g., Forestier / boréal, Floral, Épicé'**
  String get profileHint;

  /// Helper text for profile field
  ///
  /// In en, this message translates to:
  /// **'Optional - flavor category'**
  String get profileHelperText;

  /// Success message after creating gin
  ///
  /// In en, this message translates to:
  /// **'Gin created successfully!'**
  String get ginCreated;

  /// Success message after updating gin
  ///
  /// In en, this message translates to:
  /// **'Gin updated successfully!'**
  String get ginUpdated;

  /// Success message after deleting gin
  ///
  /// In en, this message translates to:
  /// **'Gin deleted successfully!'**
  String get ginDeleted;

  /// Create gin screen title
  ///
  /// In en, this message translates to:
  /// **'Create Gin'**
  String get createGin;

  /// Edit gin screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Gin'**
  String get editGin;

  /// Add gin button text
  ///
  /// In en, this message translates to:
  /// **'Add Gin'**
  String get addGin;

  /// All gins tab title
  ///
  /// In en, this message translates to:
  /// **'All Gins'**
  String get allGins;

  /// My gin list tab title
  ///
  /// In en, this message translates to:
  /// **'My Gin List'**
  String get myGinList;

  /// Filter by producer option
  ///
  /// In en, this message translates to:
  /// **'Filter by producer'**
  String get filterByProducer;

  /// Filter by origin option
  ///
  /// In en, this message translates to:
  /// **'Filter by origin'**
  String get filterByOrigin;

  /// Filter by flavor profile option for gin
  ///
  /// In en, this message translates to:
  /// **'Filter by flavor profile'**
  String get filterByProfile;

  /// Message when no gins match search/filter
  ///
  /// In en, this message translates to:
  /// **'No gins found'**
  String get noGinsFound;

  /// Loading message for gins
  ///
  /// In en, this message translates to:
  /// **'Loading gins...'**
  String get loadingGins;

  /// Validation message for required profile field
  ///
  /// In en, this message translates to:
  /// **'Profile is required'**
  String get profileRequired;

  /// Tooltip for edit item button
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editItemTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
