class HomeStrings {
  HomeStrings._();

  static const appTitle = 'Firebase Auth';
  static const appBarTitle = 'Home';
  static const sectionNotes = 'Notes';
  static const sectionProtectedScreens = 'Protected Screens';
  static const sectionAccountActions = 'Account Actions';

  static const sessionTitle = 'You are logged in!';
  static const sessionSubtitle = 'Your session is active and secure.';

  static const greeting = 'Hello';
  static const defaultUserName = 'User';
  static const noEmail = 'No email';

  static const emailVerified = 'Email verified';
  static const emailNotVerified = 'Email not verified';

  static const logoutButton = 'Logout';
  static const logoutDialogTitle = 'Logout';
  static const logoutDialogContent = 'Are you sure you want to sign out?';

  static const updateNameTitle = 'Update Name';
  static const updateNameSubtitle = 'Change your display name';
  static const updateButton = 'Update';
  static const nameUpdated = 'Name updated successfully!';

  static const verifyEmailTitle = 'Verify Email';
  static const verifyEmailSubtitle = 'Send verification email';

  static const deleteAccountTitle = 'Delete Account';
  static const deleteAccountSubtitle = 'Permanently delete your account';
  static const deleteAccountDialogContent =
      'This action is permanent and cannot be undone. '
      'All your data will be lost. Are you sure?';
  static const deleteForeverButton = 'Delete Forever';
  static const confirmPasswordTitle = 'Confirm Your Password';
  static const confirmPasswordSubtitle =
      'Enter your password to confirm account deletion.';
  static const confirmButton = 'Confirm';

  static const viewProfileTitle = 'View Profile';
  static const viewProfileSubtitle = 'Open protected profile screen';
  static const settingsTitle = 'Settings';
  static const settingsSubtitle = 'Open protected settings screen';

  static const profileAppBar = 'Profile';
  static const displayNameTile = 'Display name';
  static const emailTile = 'Email';
  static const emailStatusTile = 'Email status';
  static const verified = 'Verified';
  static const notVerified = 'Not verified';
  static const unverified = 'Unverified';
  static const defaultAvatarLetter = 'U';

  static const protectedRouteTile = 'Protected route';
  static const protectedRouteSubtitle =
      'Only authenticated users can open this screen';
  static const protectedRouteActive = 'Active';
  static const authPersistenceTile = 'Auth state persistence';
  static const authPersistenceSubtitle =
      'Firebase keeps the user session between app launches';
  static const signedIn = 'Signed in';
  static const signedOut = 'Signed out';
  static const currentAccountTile = 'Current account';

  static const protectedAccessDenied = 'Please login to view this screen';

  static String greetingText(String? name) =>
      '$greeting, ${name ?? defaultUserName}!';
}
