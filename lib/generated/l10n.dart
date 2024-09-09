// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `🇬🇧`
  String get language {
    return Intl.message(
      '🇬🇧',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Password Recovery`
  String get passwordRecoveryPageTitle {
    return Intl.message(
      'Password Recovery',
      name: 'passwordRecoveryPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `You will receive an email with a link to reset your password. `
  String get passwordRecoveryPageDescription {
    return Intl.message(
      'You will receive an email with a link to reset your password. ',
      name: 'passwordRecoveryPageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Password recovery instructions have been sent to your email address. Please check your inbox and follow the link to reset your password.`
  String get passwordRecoveryMessage {
    return Intl.message(
      'Password recovery instructions have been sent to your email address. Please check your inbox and follow the link to reset your password.',
      name: 'passwordRecoveryMessage',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get PasswordResetPageTitle {
    return Intl.message(
      'Reset Password',
      name: 'PasswordResetPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Change your email address`
  String get changeEmailPageTitle {
    return Intl.message(
      'Change your email address',
      name: 'changeEmailPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmailFormat {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmailFormat',
      desc: '',
      args: [],
    );
  }

  /// `new email`
  String get newEmail {
    return Intl.message(
      'new email',
      name: 'newEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get newPassword {
    return Intl.message(
      'Enter new password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Min 8 characters.`
  String get passwordTooShort {
    return Intl.message(
      'Min 8 characters.',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `One uppercase letter (A-Z).`
  String get passwordNeedsUppercase {
    return Intl.message(
      'One uppercase letter (A-Z).',
      name: 'passwordNeedsUppercase',
      desc: '',
      args: [],
    );
  }

  /// `One lowercase letter (a-z).`
  String get passwordNeedsLowercase {
    return Intl.message(
      'One lowercase letter (a-z).',
      name: 'passwordNeedsLowercase',
      desc: '',
      args: [],
    );
  }

  /// `One number (0-9).`
  String get passwordNeedsNumber {
    return Intl.message(
      'One number (0-9).',
      name: 'passwordNeedsNumber',
      desc: '',
      args: [],
    );
  }

  /// `One special character (!@#$%^&*(),.?":{}|<>).`
  String get passwordNeedsSpecialCharacter {
    return Intl.message(
      'One special character (!@#\$%^&*(),.?":{}|<>).',
      name: 'passwordNeedsSpecialCharacter',
      desc: '',
      args: [],
    );
  }

  /// `Change Email`
  String get changeEmail {
    return Intl.message(
      'Change Email',
      name: 'changeEmail',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been successfully updated.`
  String get successChangePassword {
    return Intl.message(
      'Your password has been successfully updated.',
      name: 'successChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Your email address has been successfully updated.`
  String get successChangeEmail {
    return Intl.message(
      'Your email address has been successfully updated.',
      name: 'successChangeEmail',
      desc: '',
      args: [],
    );
  }

  /// `username`
  String get username {
    return Intl.message(
      'username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get enterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a username`
  String get enterUsername {
    return Intl.message(
      'Please enter a username',
      name: 'enterUsername',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your email address. A confirmation link has been sent to the email provided.`
  String get verifyEmail {
    return Intl.message(
      'Please verify your email address. A confirmation link has been sent to the email provided.',
      name: 'verifyEmail',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred. Please try again.`
  String get unknownError {
    return Intl.message(
      'An unknown error occurred. Please try again.',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get btnResetPassword {
    return Intl.message(
      'Reset password',
      name: 'btnResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `editTradingAccount`
  String get editTradingAccount {
    return Intl.message(
      'editTradingAccount',
      name: 'editTradingAccount',
      desc: '',
      args: [],
    );
  }

  /// `accountNumber`
  String get accountNumber {
    return Intl.message(
      'accountNumber',
      name: 'accountNumber',
      desc: '',
      args: [],
    );
  }

  /// `savingData`
  String get fieldCannotBeEmpty {
    return Intl.message(
      'savingData',
      name: 'fieldCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `savingData`
  String get save {
    return Intl.message(
      'savingData',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Type a message`
  String get typeAMessage {
    return Intl.message(
      'Type a message',
      name: 'typeAMessage',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Bank Name`
  String get bankName {
    return Intl.message(
      'Bank Name',
      name: 'bankName',
      desc: '',
      args: [],
    );
  }

  /// `Bank Code`
  String get bankCode {
    return Intl.message(
      'Bank Code',
      name: 'bankCode',
      desc: '',
      args: [],
    );
  }

  /// `Branch Name`
  String get branchName {
    return Intl.message(
      'Branch Name',
      name: 'branchName',
      desc: '',
      args: [],
    );
  }

  /// `Branch Code`
  String get branchCode {
    return Intl.message(
      'Branch Code',
      name: 'branchCode',
      desc: '',
      args: [],
    );
  }

  /// `Account Number`
  String get bankAccountNumber {
    return Intl.message(
      'Account Number',
      name: 'bankAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Account Holder Name`
  String get accountHolderName {
    return Intl.message(
      'Account Holder Name',
      name: 'accountHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully.`
  String get successChangeProfile {
    return Intl.message(
      'Profile updated successfully.',
      name: 'successChangeProfile',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Support chat`
  String get supportPageName {
    return Intl.message(
      'Support chat',
      name: 'supportPageName',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Payment setting`
  String get bankDetail {
    return Intl.message(
      'Payment setting',
      name: 'bankDetail',
      desc: '',
      args: [],
    );
  }

  /// `Account Email Address`
  String get tradingAccountEmail {
    return Intl.message(
      'Account Email Address',
      name: 'tradingAccountEmail',
      desc: '',
      args: [],
    );
  }

  /// `Account Holder Name`
  String get tradingAccountHolderName {
    return Intl.message(
      'Account Holder Name',
      name: 'tradingAccountHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Trading Account NUmber`
  String get tradingAccountNumber {
    return Intl.message(
      'Trading Account NUmber',
      name: 'tradingAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Additional info`
  String get additionalInfo {
    return Intl.message(
      'Additional info',
      name: 'additionalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Enter a Account Holder Name`
  String get enterTradingAccountHolderName {
    return Intl.message(
      'Enter a Account Holder Name',
      name: 'enterTradingAccountHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Enter a Trading Account Number`
  String get enterTradingAccountNumber {
    return Intl.message(
      'Enter a Trading Account Number',
      name: 'enterTradingAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Trading account successfully added`
  String get successInsertTradingAccount {
    return Intl.message(
      'Trading account successfully added',
      name: 'successInsertTradingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Add Trading Account`
  String get TradingAccountRegistrationTitle {
    return Intl.message(
      'Add Trading Account',
      name: 'TradingAccountRegistrationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get btnTitleTradingAccountRegistration {
    return Intl.message(
      'Submit',
      name: 'btnTitleTradingAccountRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Changes have been successfully completed.`
  String get successfullyCompleted {
    return Intl.message(
      'Changes have been successfully completed.',
      name: 'successfullyCompleted',
      desc: '',
      args: [],
    );
  }

  /// `This Week`
  String get thisWeek {
    return Intl.message(
      'This Week',
      name: 'thisWeek',
      desc: '',
      args: [],
    );
  }

  /// `Last Week`
  String get lastWeek {
    return Intl.message(
      'Last Week',
      name: 'lastWeek',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get noDataFound {
    return Intl.message(
      'No data found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Clear the Quest and get the Treasure!`
  String get loginPageTitle {
    return Intl.message(
      'Clear the Quest and get the Treasure!',
      name: 'loginPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get email {
    return Intl.message(
      'email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get password {
    return Intl.message(
      'password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get signUp {
    return Intl.message(
      'Create New Account',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Do you forget your password?`
  String get forgotPassword {
    return Intl.message(
      'Do you forget your password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Authentication failed. Please check your email and password.`
  String get loginErrorMessage {
    return Intl.message(
      'Authentication failed. Please check your email and password.',
      name: 'loginErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Resend Verification Email`
  String get resendVerificationEmail {
    return Intl.message(
      'Resend Verification Email',
      name: 'resendVerificationEmail',
      desc: '',
      args: [],
    );
  }

  /// `Verification Email Resent`
  String get verificationEmailResent {
    return Intl.message(
      'Verification Email Resent',
      name: 'verificationEmailResent',
      desc: '',
      args: [],
    );
  }

  /// `Error Resending Email`
  String get resendEmailError {
    return Intl.message(
      'Error Resending Email',
      name: 'resendEmailError',
      desc: '',
      args: [],
    );
  }

  /// `Haven't received the verification email?`
  String get verificationEmailNotReceived {
    return Intl.message(
      'Haven\'t received the verification email?',
      name: 'verificationEmailNotReceived',
      desc: '',
      args: [],
    );
  }

  /// `Would you like us to resend it?`
  String get wouldYouLikeToResendEmail {
    return Intl.message(
      'Would you like us to resend it?',
      name: 'wouldYouLikeToResendEmail',
      desc: '',
      args: [],
    );
  }

  /// `No worries, just try one more time, yeah?`
  String get error {
    return Intl.message(
      'No worries, just try one more time, yeah?',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a email`
  String get enterEmail {
    return Intl.message(
      'Please enter a email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password.`
  String get enterPassword {
    return Intl.message(
      'Please enter a password.',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get weekly {
    return Intl.message(
      'Weekly',
      name: 'weekly',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message(
      'Monthly',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }

  /// `Register Trading Account`
  String get registerTradingAccount {
    return Intl.message(
      'Register Trading Account',
      name: 'registerTradingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Verify Account`
  String get verifyAccount {
    return Intl.message(
      'Verify Account',
      name: 'verifyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create an account via the cashback site.`
  String get registerTradingAccountSub {
    return Intl.message(
      'Create an account via the cashback site.',
      name: 'registerTradingAccountSub',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Open support chat`
  String get openSupportChat {
    return Intl.message(
      'Open support chat',
      name: 'openSupportChat',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get darkMode {
    return Intl.message(
      'Dark mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Language Settings`
  String get languageMode {
    return Intl.message(
      'Language Settings',
      name: 'languageMode',
      desc: '',
      args: [],
    );
  }

  /// `Switch between dark and light mode.`
  String get darkModeDescription {
    return Intl.message(
      'Switch between dark and light mode.',
      name: 'darkModeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Change the app's language.`
  String get languageDescription {
    return Intl.message(
      'Change the app\'s language.',
      name: 'languageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Change profile.`
  String get profileDescription {
    return Intl.message(
      'Change profile.',
      name: 'profileDescription',
      desc: '',
      args: [],
    );
  }

  /// `Change payment detail.`
  String get paymentDescription {
    return Intl.message(
      'Change payment detail.',
      name: 'paymentDescription',
      desc: '',
      args: [],
    );
  }

  /// `End current session`
  String get logoutDescription {
    return Intl.message(
      'End current session',
      name: 'logoutDescription',
      desc: '',
      args: [],
    );
  }

  /// `Change email`
  String get emailChange {
    return Intl.message(
      'Change email',
      name: 'emailChange',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get passwordChange {
    return Intl.message(
      'Change password',
      name: 'passwordChange',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `New Version Available`
  String get versionCheckTitle {
    return Intl.message(
      'New Version Available',
      name: 'versionCheckTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please update the app to enjoy the latest features.`
  String get versionCheckContent {
    return Intl.message(
      'Please update the app to enjoy the latest features.',
      name: 'versionCheckContent',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get laterButton {
    return Intl.message(
      'Later',
      name: 'laterButton',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get updateButton {
    return Intl.message(
      'Update',
      name: 'updateButton',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: `
  String get errorMessage {
    return Intl.message(
      'An error occurred: ',
      name: 'errorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Could not launch Url`
  String get couldNotLaunch {
    return Intl.message(
      'Could not launch Url',
      name: 'couldNotLaunch',
      desc: '',
      args: [],
    );
  }

  /// `Your Trading Accounts`
  String get accountListPageTitle {
    return Intl.message(
      'Your Trading Accounts',
      name: 'accountListPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Payments`
  String get paymentsPageTitle {
    return Intl.message(
      'Your Payments',
      name: 'paymentsPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Trades`
  String get tradesPageTitle {
    return Intl.message(
      'Your Trades',
      name: 'tradesPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `pending`
  String get pending {
    return Intl.message(
      'pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `approved`
  String get approved {
    return Intl.message(
      'approved',
      name: 'approved',
      desc: '',
      args: [],
    );
  }

  /// `rejected`
  String get rejected {
    return Intl.message(
      'rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `on_hold`
  String get onHold {
    return Intl.message(
      'on_hold',
      name: 'onHold',
      desc: '',
      args: [],
    );
  }

  /// `The current password is incorrect.`
  String get currentPasswordInvalid {
    return Intl.message(
      'The current password is incorrect.',
      name: 'currentPasswordInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a current password`
  String get enterCurrentPassword {
    return Intl.message(
      'Please enter a current password',
      name: 'enterCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password should be different from the old password.`
  String get newPasswordMustBeDifferent {
    return Intl.message(
      'New password should be different from the old password.',
      name: 'newPasswordMustBeDifferent',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get fieldRequired {
    return Intl.message(
      'This field is required',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Username must be at least 2 characters long`
  String get usernameTooShort {
    return Intl.message(
      'Username must be at least 2 characters long',
      name: 'usernameTooShort',
      desc: '',
      args: [],
    );
  }

  /// `This username is already taken`
  String get usernameAlreadyTaken {
    return Intl.message(
      'This username is already taken',
      name: 'usernameAlreadyTaken',
      desc: '',
      args: [],
    );
  }

  /// `Step 1: Open your first trading account now!`
  String get stepOne {
    return Intl.message(
      'Step 1: Open your first trading account now!',
      name: 'stepOne',
      desc: '',
      args: [],
    );
  }

  /// `User successfully deleted.`
  String get successDeleteUser {
    return Intl.message(
      'User successfully deleted.',
      name: 'successDeleteUser',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account `
  String get delete {
    return Intl.message(
      'Delete Account ',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete your Account`
  String get deleteUser {
    return Intl.message(
      'Delete your Account',
      name: 'deleteUser',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your registration.`
  String get firstChatMessage {
    return Intl.message(
      'Thank you for your registration.',
      name: 'firstChatMessage',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get newChatList {
    return Intl.message(
      'Chat',
      name: 'newChatList',
      desc: '',
      args: [],
    );
  }

  /// `Email link is invalid or has expired`
  String get invalidOrExpiredErrorMessage {
    return Intl.message(
      'Email link is invalid or has expired',
      name: 'invalidOrExpiredErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred, please try again`
  String get defaultErrorMessage {
    return Intl.message(
      'An error occurred, please try again',
      name: 'defaultErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `close`
  String get close {
    return Intl.message(
      'close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `A verification email has been sent to your new email address. Please check your inbox and follow the instructions to confirm your email change.`
  String get emailChangeVerificationMessage {
    return Intl.message(
      'A verification email has been sent to your new email address. Please check your inbox and follow the instructions to confirm your email change.',
      name: 'emailChangeVerificationMessage',
      desc: '',
      args: [],
    );
  }

  /// `The text is too long`
  String get lengthExceededMessage {
    return Intl.message(
      'The text is too long',
      name: 'lengthExceededMessage',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get successLabel {
    return Intl.message(
      'Success',
      name: 'successLabel',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get errorLabel {
    return Intl.message(
      'Error',
      name: 'errorLabel',
      desc: '',
      args: [],
    );
  }

  /// `A user with this email address has already been registered`
  String get userAlreadyRegisteredMessage {
    return Intl.message(
      'A user with this email address has already been registered',
      name: 'userAlreadyRegisteredMessage',
      desc: '',
      args: [],
    );
  }

  /// `Oops! There seems to be a network issue. Please check your connection and try again.`
  String get networkErrorMessage {
    return Intl.message(
      'Oops! There seems to be a network issue. Please check your connection and try again.',
      name: 'networkErrorMessage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
