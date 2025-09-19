import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Tawasul'**
  String get appTitle;

  /// Greets the user by name
  ///
  /// In en, this message translates to:
  /// **'Hi {name}!'**
  String greeting(String name);

  /// Pluralized task count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No tasks} =1{One task} other{{count} tasks}}'**
  String tasksCount(int count);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get chooseLanguage;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search Products'**
  String get searchProducts;

  /// No description provided for @summerSale.
  ///
  /// In en, this message translates to:
  /// **'Summer Sale'**
  String get summerSale;

  /// No description provided for @upTo50Off.
  ///
  /// In en, this message translates to:
  /// **'Up to 50% off on selected items'**
  String get upTo50Off;

  /// No description provided for @techWeek.
  ///
  /// In en, this message translates to:
  /// **'Tech Week'**
  String get techWeek;

  /// No description provided for @latestGadgets.
  ///
  /// In en, this message translates to:
  /// **'Latest gadgets at special prices'**
  String get latestGadgets;

  /// No description provided for @newCollection.
  ///
  /// In en, this message translates to:
  /// **'New Collection'**
  String get newCollection;

  /// No description provided for @discount30.
  ///
  /// In en, this message translates to:
  /// **'Discount 30% for the first transaction'**
  String get discount30;

  /// No description provided for @shop.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shop;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @shops.
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get shops;

  /// No description provided for @bundles.
  ///
  /// In en, this message translates to:
  /// **'Bundles'**
  String get bundles;

  /// No description provided for @promo.
  ///
  /// In en, this message translates to:
  /// **'Promo'**
  String get promo;

  /// No description provided for @warranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get warranty;

  /// No description provided for @flashSale.
  ///
  /// In en, this message translates to:
  /// **'Flash Sale'**
  String get flashSale;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brands;

  /// No description provided for @lyd.
  ///
  /// In en, this message translates to:
  /// **'LYD'**
  String get lyd;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @highTech.
  ///
  /// In en, this message translates to:
  /// **'HighTech'**
  String get highTech;

  /// No description provided for @smartHome.
  ///
  /// In en, this message translates to:
  /// **'Smart Home'**
  String get smartHome;

  /// No description provided for @smartOffice.
  ///
  /// In en, this message translates to:
  /// **'Smart Office'**
  String get smartOffice;

  /// No description provided for @lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get lifestyle;

  /// No description provided for @findTawasul.
  ///
  /// In en, this message translates to:
  /// **'Find Tawasul'**
  String get findTawasul;

  /// No description provided for @tawasulAll.
  ///
  /// In en, this message translates to:
  /// **'Tawasul All'**
  String get tawasulAll;

  /// No description provided for @tawasulApple.
  ///
  /// In en, this message translates to:
  /// **'Tawasul Apple'**
  String get tawasulApple;

  /// No description provided for @tawasulXiaomi.
  ///
  /// In en, this message translates to:
  /// **'Tawasul Xiaomi'**
  String get tawasulXiaomi;

  /// No description provided for @tawasulSamsung.
  ///
  /// In en, this message translates to:
  /// **'Tawasul Samsung'**
  String get tawasulSamsung;

  /// No description provided for @tawasulHuawei.
  ///
  /// In en, this message translates to:
  /// **'Tawasul Huawei'**
  String get tawasulHuawei;

  /// No description provided for @streetAlKhototAlBaidaLibya.
  ///
  /// In en, this message translates to:
  /// **'Street Al Khotot, Al Baida, Libya'**
  String get streetAlKhototAlBaidaLibya;

  /// No description provided for @veniceBenghaziLibya.
  ///
  /// In en, this message translates to:
  /// **'Venice, Benghazi, Libya'**
  String get veniceBenghaziLibya;

  /// No description provided for @benghaziLibya.
  ///
  /// In en, this message translates to:
  /// **'Benghazi, Libya'**
  String get benghaziLibya;

  /// No description provided for @shariAlQayrawanBenghaziLibya.
  ///
  /// In en, this message translates to:
  /// **'Shari Al Qayrawan, Benghazi, Libya'**
  String get shariAlQayrawanBenghaziLibya;

  /// No description provided for @almadarStreetSertLibya.
  ///
  /// In en, this message translates to:
  /// **'Almadar Street, in front of the city Square, Sert, Libya'**
  String get almadarStreetSertLibya;

  /// No description provided for @qadisiyahSquareTripoliLibya.
  ///
  /// In en, this message translates to:
  /// **'Qadisiyah Square, Tripoli, Libya'**
  String get qadisiyahSquareTripoliLibya;

  /// No description provided for @binAshourStreetTripoliLibya.
  ///
  /// In en, this message translates to:
  /// **'Bin Ashour Street, Tripoli, Libya'**
  String get binAshourStreetTripoliLibya;

  /// No description provided for @awladBinAlHajStreetTripoliLibya.
  ///
  /// In en, this message translates to:
  /// **'Awlad Bin al Haj Street, Tripoli, Libya'**
  String get awladBinAlHajStreetTripoliLibya;

  /// No description provided for @alJarabaMallTripoliLibya.
  ///
  /// In en, this message translates to:
  /// **'Al Jaraba Mall, Tripoli, Libya'**
  String get alJarabaMallTripoliLibya;

  /// No description provided for @grandMallTripoliLibya.
  ///
  /// In en, this message translates to:
  /// **'Grand Mall, Tripoli, Libya'**
  String get grandMallTripoliLibya;

  /// No description provided for @regataVillageTripoliLibya.
  ///
  /// In en, this message translates to:
  /// **'Regata Village, Tripoli, Libya'**
  String get regataVillageTripoliLibya;

  /// No description provided for @tripoliStreetTripoliLibya.
  ///
  /// In en, this message translates to:
  /// **'Tripoli Street, Tripoli, Libya'**
  String get tripoliStreetTripoliLibya;

  /// No description provided for @investmentMarketMisurataLibya.
  ///
  /// In en, this message translates to:
  /// **'Investment market, Sana Street, near The High Mosque, Misurata, Libya'**
  String get investmentMarketMisurataLibya;

  /// No description provided for @alMurqubDistrictMisurataLibya.
  ///
  /// In en, this message translates to:
  /// **'Al Murqub District, Misurata, Libya'**
  String get alMurqubDistrictMisurataLibya;

  /// No description provided for @aldisStreetMisurataLibya.
  ///
  /// In en, this message translates to:
  /// **'Aldis Street, Misurata, Libya'**
  String get aldisStreetMisurataLibya;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @bestOffer.
  ///
  /// In en, this message translates to:
  /// **'Best Offer'**
  String get bestOffer;

  /// No description provided for @topRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// No description provided for @priceLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Price Low-High'**
  String get priceLowHigh;

  /// No description provided for @priceHighLow.
  ///
  /// In en, this message translates to:
  /// **'Price High-Low'**
  String get priceHighLow;

  /// No description provided for @shoppingCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCart;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @enterDiscountCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Discount Code'**
  String get enterDiscountCode;

  /// No description provided for @subTotal.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get subTotal;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @addYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Add Your Details'**
  String get addYourDetails;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @setYourLocalization.
  ///
  /// In en, this message translates to:
  /// **'Set your localization'**
  String get setYourLocalization;

  /// No description provided for @chooseYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Set your Location'**
  String get chooseYourLocation;

  /// No description provided for @orSetAllYourInformationBelow.
  ///
  /// In en, this message translates to:
  /// **'Or set all your information below'**
  String get orSetAllYourInformationBelow;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @additionalAddress.
  ///
  /// In en, this message translates to:
  /// **'Additional address'**
  String get additionalAddress;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @myBillingAddress.
  ///
  /// In en, this message translates to:
  /// **'My Billing Address'**
  String get myBillingAddress;

  /// No description provided for @isTheSameAsMyDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Is The Same As My Delivery Address'**
  String get isTheSameAsMyDeliveryAddress;

  /// No description provided for @validateAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Validate and continue'**
  String get validateAndContinue;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @connexion.
  ///
  /// In en, this message translates to:
  /// **'Connexion'**
  String get connexion;

  /// No description provided for @pleaseEnterYourInformation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your information to connect to your account'**
  String get pleaseEnterYourInformation;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password ?'**
  String get forgotPassword;

  /// No description provided for @newClient.
  ///
  /// In en, this message translates to:
  /// **'New client ?'**
  String get newClient;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @pleaseEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number associated with your account'**
  String get pleaseEnterYourPhoneNumber;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @useEmailInstead.
  ///
  /// In en, this message translates to:
  /// **'Use Email Instead'**
  String get useEmailInstead;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email associated with your account'**
  String get pleaseEnterYourEmail;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @usePhoneNumberInstead.
  ///
  /// In en, this message translates to:
  /// **'Use phone number instead'**
  String get usePhoneNumberInstead;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @iAcceptTheTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the terms and conditions and privacy policy'**
  String get iAcceptTheTerms;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @firstNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameIsRequired;

  /// No description provided for @lastNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameIsRequired;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @phoneNumberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberIsRequired;

  /// No description provided for @accountValidation.
  ///
  /// In en, this message translates to:
  /// **'Account Validation'**
  String get accountValidation;

  /// No description provided for @pleaseEnterTheCodeNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter the code number'**
  String get pleaseEnterTheCodeNumber;

  /// No description provided for @pleaseEnterUsernameAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter username and password'**
  String get pleaseEnterUsernameAndPassword;

  /// No description provided for @pleaseEnterYourInformationsToConnectToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Please enter your informations to connect \nto your account'**
  String get pleaseEnterYourInformationsToConnectToYourAccount;

  /// No description provided for @codeNumber.
  ///
  /// In en, this message translates to:
  /// **'Code number'**
  String get codeNumber;

  /// No description provided for @resendTheCode.
  ///
  /// In en, this message translates to:
  /// **'Resend the code'**
  String get resendTheCode;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @yourEmail.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get yourEmail;

  /// No description provided for @yourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Your phone number'**
  String get yourPhoneNumber;

  /// No description provided for @yourPassword.
  ///
  /// In en, this message translates to:
  /// **'Your Password'**
  String get yourPassword;

  /// No description provided for @saveModification.
  ///
  /// In en, this message translates to:
  /// **'Save modification'**
  String get saveModification;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @pleaseSetYourNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please set your new password'**
  String get pleaseSetYourNewPassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noProductsFoundFor.
  ///
  /// In en, this message translates to:
  /// **'No products found for'**
  String get noProductsFoundFor;

  /// No description provided for @typeToSearch.
  ///
  /// In en, this message translates to:
  /// **'Type to search'**
  String get typeToSearch;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @errorFetchingProduct.
  ///
  /// In en, this message translates to:
  /// **'Error Fetching Product'**
  String get errorFetchingProduct;

  /// No description provided for @noTokenFound.
  ///
  /// In en, this message translates to:
  /// **'No token found. Please log in.'**
  String get noTokenFound;

  /// No description provided for @appliedFilters.
  ///
  /// In en, this message translates to:
  /// **'Applied Filters'**
  String get appliedFilters;

  /// No description provided for @apiError.
  ///
  /// In en, this message translates to:
  /// **'API Error'**
  String get apiError;

  /// No description provided for @failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get failedToLoad;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error: Please check your internet connection and try again.'**
  String get networkError;

  /// No description provided for @requestTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout: Please check your internet connection.'**
  String get requestTimeout;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @tripoli.
  ///
  /// In en, this message translates to:
  /// **'tripoli'**
  String get tripoli;

  /// No description provided for @benghazi.
  ///
  /// In en, this message translates to:
  /// **'Benghazi'**
  String get benghazi;

  /// No description provided for @misrata.
  ///
  /// In en, this message translates to:
  /// **'Misrata'**
  String get misrata;

  /// No description provided for @bayda.
  ///
  /// In en, this message translates to:
  /// **'Bayda'**
  String get bayda;

  /// No description provided for @zawiya.
  ///
  /// In en, this message translates to:
  /// **'Zawiya'**
  String get zawiya;

  /// No description provided for @gharyan.
  ///
  /// In en, this message translates to:
  /// **'Gharyan'**
  String get gharyan;

  /// No description provided for @tobruk.
  ///
  /// In en, this message translates to:
  /// **'Tobruk'**
  String get tobruk;

  /// No description provided for @ajdabiya.
  ///
  /// In en, this message translates to:
  /// **'Ajdabiya'**
  String get ajdabiya;

  /// No description provided for @zleiten.
  ///
  /// In en, this message translates to:
  /// **'Zleiten'**
  String get zleiten;

  /// No description provided for @derna.
  ///
  /// In en, this message translates to:
  /// **'Derna'**
  String get derna;

  /// No description provided for @sirte.
  ///
  /// In en, this message translates to:
  /// **'Sirte'**
  String get sirte;

  /// No description provided for @sabha.
  ///
  /// In en, this message translates to:
  /// **'Sabha'**
  String get sabha;

  /// No description provided for @khoms.
  ///
  /// In en, this message translates to:
  /// **'Khoms'**
  String get khoms;

  /// No description provided for @bani_walid.
  ///
  /// In en, this message translates to:
  /// **'Bani Walid'**
  String get bani_walid;

  /// No description provided for @sabratha.
  ///
  /// In en, this message translates to:
  /// **'Sabratha'**
  String get sabratha;

  /// No description provided for @zuwara.
  ///
  /// In en, this message translates to:
  /// **'Zuwara'**
  String get zuwara;

  /// No description provided for @kufra.
  ///
  /// In en, this message translates to:
  /// **'Kufra'**
  String get kufra;

  /// No description provided for @marj.
  ///
  /// In en, this message translates to:
  /// **'Marj'**
  String get marj;

  /// No description provided for @tocra.
  ///
  /// In en, this message translates to:
  /// **'Tocra'**
  String get tocra;

  /// No description provided for @tarhuna.
  ///
  /// In en, this message translates to:
  /// **'Tarhuna'**
  String get tarhuna;

  /// No description provided for @msallata.
  ///
  /// In en, this message translates to:
  /// **'Msallata'**
  String get msallata;

  /// No description provided for @jumayl.
  ///
  /// In en, this message translates to:
  /// **'Jumayl'**
  String get jumayl;

  /// No description provided for @sorman.
  ///
  /// In en, this message translates to:
  /// **'Sorman'**
  String get sorman;

  /// No description provided for @al_gseibat.
  ///
  /// In en, this message translates to:
  /// **'Al Gseibat'**
  String get al_gseibat;

  /// No description provided for @shahat.
  ///
  /// In en, this message translates to:
  /// **'Shahat'**
  String get shahat;

  /// No description provided for @ubari.
  ///
  /// In en, this message translates to:
  /// **'Ubari'**
  String get ubari;

  /// No description provided for @asbia.
  ///
  /// In en, this message translates to:
  /// **'Asbi\'a'**
  String get asbia;

  /// No description provided for @jadid.
  ///
  /// In en, this message translates to:
  /// **'Jadid'**
  String get jadid;

  /// No description provided for @waddan.
  ///
  /// In en, this message translates to:
  /// **'Waddan'**
  String get waddan;

  /// No description provided for @el_agheila.
  ///
  /// In en, this message translates to:
  /// **'El Agheila'**
  String get el_agheila;

  /// No description provided for @abyar.
  ///
  /// In en, this message translates to:
  /// **'Abyar'**
  String get abyar;

  /// No description provided for @nofaliya.
  ///
  /// In en, this message translates to:
  /// **'Nofaliya'**
  String get nofaliya;

  /// No description provided for @regdalin.
  ///
  /// In en, this message translates to:
  /// **'Regdalin'**
  String get regdalin;

  /// No description provided for @gasr_akhyar.
  ///
  /// In en, this message translates to:
  /// **'Gasr Akhyar'**
  String get gasr_akhyar;

  /// No description provided for @al_qubah.
  ///
  /// In en, this message translates to:
  /// **'Al Qubah'**
  String get al_qubah;

  /// No description provided for @tawergha.
  ///
  /// In en, this message translates to:
  /// **'Tawergha'**
  String get tawergha;

  /// No description provided for @al_maya.
  ///
  /// In en, this message translates to:
  /// **'Al Maya'**
  String get al_maya;

  /// No description provided for @murzuk.
  ///
  /// In en, this message translates to:
  /// **'Murzuk'**
  String get murzuk;

  /// No description provided for @brega.
  ///
  /// In en, this message translates to:
  /// **'Brega'**
  String get brega;

  /// No description provided for @teghsat.
  ///
  /// In en, this message translates to:
  /// **'Teghsat'**
  String get teghsat;

  /// No description provided for @hun.
  ///
  /// In en, this message translates to:
  /// **'Hun'**
  String get hun;

  /// No description provided for @jalu.
  ///
  /// In en, this message translates to:
  /// **'Jalu'**
  String get jalu;

  /// No description provided for @ajaylat.
  ///
  /// In en, this message translates to:
  /// **'Ajaylat'**
  String get ajaylat;

  /// No description provided for @nalut.
  ///
  /// In en, this message translates to:
  /// **'Nalut'**
  String get nalut;

  /// No description provided for @suluq.
  ///
  /// In en, this message translates to:
  /// **'Suluq'**
  String get suluq;

  /// No description provided for @shuhada_al_buerat.
  ///
  /// In en, this message translates to:
  /// **'Shuhada Al Buerat'**
  String get shuhada_al_buerat;

  /// No description provided for @zaltan.
  ///
  /// In en, this message translates to:
  /// **'Zaltan'**
  String get zaltan;

  /// No description provided for @mizda.
  ///
  /// In en, this message translates to:
  /// **'Mizda'**
  String get mizda;

  /// No description provided for @ras_lanuf.
  ///
  /// In en, this message translates to:
  /// **'Ras Lanuf'**
  String get ras_lanuf;

  /// No description provided for @al_urban.
  ///
  /// In en, this message translates to:
  /// **'Al Urban'**
  String get al_urban;

  /// No description provided for @yafran.
  ///
  /// In en, this message translates to:
  /// **'Yafran'**
  String get yafran;

  /// No description provided for @ar_rayaniya.
  ///
  /// In en, this message translates to:
  /// **'Ar Rayaniya'**
  String get ar_rayaniya;

  /// No description provided for @umm_al_rizam.
  ///
  /// In en, this message translates to:
  /// **'Umm Al Rizam'**
  String get umm_al_rizam;

  /// No description provided for @taucheira.
  ///
  /// In en, this message translates to:
  /// **'Taucheira'**
  String get taucheira;

  /// No description provided for @brak.
  ///
  /// In en, this message translates to:
  /// **'Brak'**
  String get brak;

  /// No description provided for @abu_ghlasha.
  ///
  /// In en, this message translates to:
  /// **'Abu Ghlasha'**
  String get abu_ghlasha;

  /// No description provided for @ad_dawoon.
  ///
  /// In en, this message translates to:
  /// **'Ad Dawoon'**
  String get ad_dawoon;

  /// No description provided for @teji.
  ///
  /// In en, this message translates to:
  /// **'Teji'**
  String get teji;

  /// No description provided for @qaminis.
  ///
  /// In en, this message translates to:
  /// **'Qaminis'**
  String get qaminis;

  /// No description provided for @qatrun.
  ///
  /// In en, this message translates to:
  /// **'Qatrun'**
  String get qatrun;

  /// No description provided for @benina.
  ///
  /// In en, this message translates to:
  /// **'Benina'**
  String get benina;

  /// No description provided for @kikla.
  ///
  /// In en, this message translates to:
  /// **'Kikla'**
  String get kikla;

  /// No description provided for @al_rheibat.
  ///
  /// In en, this message translates to:
  /// **'Al Rheibat'**
  String get al_rheibat;

  /// No description provided for @sokna.
  ///
  /// In en, this message translates to:
  /// **'Sokna'**
  String get sokna;

  /// No description provided for @massa.
  ///
  /// In en, this message translates to:
  /// **'Massa'**
  String get massa;

  /// No description provided for @bin_jawad.
  ///
  /// In en, this message translates to:
  /// **'Bin Jawad'**
  String get bin_jawad;

  /// No description provided for @umm_al_aranib.
  ///
  /// In en, this message translates to:
  /// **'Umm Al Aranib'**
  String get umm_al_aranib;

  /// No description provided for @jadu.
  ///
  /// In en, this message translates to:
  /// **'Jadu'**
  String get jadu;

  /// No description provided for @ghadames.
  ///
  /// In en, this message translates to:
  /// **'Ghadames'**
  String get ghadames;

  /// No description provided for @ar_rabta.
  ///
  /// In en, this message translates to:
  /// **'Ar Rabta'**
  String get ar_rabta;

  /// No description provided for @ghat.
  ///
  /// In en, this message translates to:
  /// **'Ghat'**
  String get ghat;

  /// No description provided for @al_abraq.
  ///
  /// In en, this message translates to:
  /// **'Al Abraq'**
  String get al_abraq;

  /// No description provided for @sidi_as_said.
  ///
  /// In en, this message translates to:
  /// **'Sidi As Said'**
  String get sidi_as_said;

  /// No description provided for @ar_rajban.
  ///
  /// In en, this message translates to:
  /// **'Ar Rajban'**
  String get ar_rajban;

  /// No description provided for @awjila.
  ///
  /// In en, this message translates to:
  /// **'Awjila'**
  String get awjila;

  /// No description provided for @ras_al_hamam.
  ///
  /// In en, this message translates to:
  /// **'Ras Al Hamam'**
  String get ras_al_hamam;

  /// No description provided for @tolmeita.
  ///
  /// In en, this message translates to:
  /// **'Tolmeita'**
  String get tolmeita;

  /// No description provided for @zella.
  ///
  /// In en, this message translates to:
  /// **'Zella'**
  String get zella;

  /// No description provided for @wadi_utba.
  ///
  /// In en, this message translates to:
  /// **'Wadi Utba'**
  String get wadi_utba;

  /// No description provided for @al_barkat.
  ///
  /// In en, this message translates to:
  /// **'Al Barkat'**
  String get al_barkat;

  /// No description provided for @martuba.
  ///
  /// In en, this message translates to:
  /// **'Martuba'**
  String get martuba;

  /// No description provided for @traghan.
  ///
  /// In en, this message translates to:
  /// **'Traghan'**
  String get traghan;

  /// No description provided for @al_hashan.
  ///
  /// In en, this message translates to:
  /// **'Al Hashan'**
  String get al_hashan;

  /// No description provided for @el_bayyada.
  ///
  /// In en, this message translates to:
  /// **'El Bayyada'**
  String get el_bayyada;

  /// No description provided for @qayqab.
  ///
  /// In en, this message translates to:
  /// **'Qayqab'**
  String get qayqab;

  /// No description provided for @mashashita.
  ///
  /// In en, this message translates to:
  /// **'Mashashita'**
  String get mashashita;

  /// No description provided for @bu_fakhra.
  ///
  /// In en, this message translates to:
  /// **'Bu Fakhra'**
  String get bu_fakhra;

  /// No description provided for @musaid.
  ///
  /// In en, this message translates to:
  /// **'Musaid'**
  String get musaid;

  /// No description provided for @tacnis.
  ///
  /// In en, this message translates to:
  /// **'Tacnis'**
  String get tacnis;

  /// No description provided for @susa.
  ///
  /// In en, this message translates to:
  /// **'Susa'**
  String get susa;

  /// No description provided for @wadi_zem_zem.
  ///
  /// In en, this message translates to:
  /// **'Wadi Zem Zem'**
  String get wadi_zem_zem;

  /// No description provided for @batta.
  ///
  /// In en, this message translates to:
  /// **'Batta'**
  String get batta;

  /// No description provided for @tazirbu.
  ///
  /// In en, this message translates to:
  /// **'Tazirbu'**
  String get tazirbu;

  /// No description provided for @farzougha.
  ///
  /// In en, this message translates to:
  /// **'Farzougha'**
  String get farzougha;

  /// No description provided for @qaryat_umar_al_mukhtar.
  ///
  /// In en, this message translates to:
  /// **'Qaryat Umar Al Mukhtar'**
  String get qaryat_umar_al_mukhtar;

  /// No description provided for @bir_al_ashhab.
  ///
  /// In en, this message translates to:
  /// **'Bir Al Ashhab'**
  String get bir_al_ashhab;

  /// No description provided for @gadames.
  ///
  /// In en, this message translates to:
  /// **'Gadames'**
  String get gadames;

  /// No description provided for @pleaseEnterAllMandatoryInformationToCreateAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Please enter all mandatory information to create an account'**
  String get pleaseEnterAllMandatoryInformationToCreateAnAccount;

  /// No description provided for @libya.
  ///
  /// In en, this message translates to:
  /// **'Libya'**
  String get libya;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @passwordMustBeAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustBeAtLeast8Characters;

  /// No description provided for @mustContainUppercaseLetter.
  ///
  /// In en, this message translates to:
  /// **'Must contain uppercase letter'**
  String get mustContainUppercaseLetter;

  /// No description provided for @mustContainLowercaseLetter.
  ///
  /// In en, this message translates to:
  /// **'Must contain lowercase letter'**
  String get mustContainLowercaseLetter;

  /// No description provided for @mustContainNumber.
  ///
  /// In en, this message translates to:
  /// **'Must contain number'**
  String get mustContainNumber;

  /// No description provided for @mustContainSpecialCharacter.
  ///
  /// In en, this message translates to:
  /// **'Must contain special character'**
  String get mustContainSpecialCharacter;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'female'**
  String get female;

  /// No description provided for @setYourLocalisation.
  ///
  /// In en, this message translates to:
  /// **'Set your localization'**
  String get setYourLocalisation;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zipCode;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Yourcart is empty'**
  String get yourCartIsEmpty;

  /// No description provided for @addItemsToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add items to get started'**
  String get addItemsToGetStarted;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get continueShopping;

  /// No description provided for @noTitle.
  ///
  /// In en, this message translates to:
  /// **'No title'**
  String get noTitle;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @pleaseLoginToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Please login to checkout'**
  String get pleaseLoginToCheckout;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetails;

  /// No description provided for @loadingProduct.
  ///
  /// In en, this message translates to:
  /// **'Loading product...'**
  String get loadingProduct;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No Description'**
  String get noDescription;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get buyNow;

  /// No description provided for @productAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart successfully!'**
  String get productAddedToCart;

  /// No description provided for @failedToLoadUserInfo.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user information. Please try again.'**
  String get failedToLoadUserInfo;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocation;

  /// No description provided for @homeAddress.
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get homeAddress;

  /// No description provided for @pleaseLoginFirst.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get pleaseLoginFirst;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @pleaseSelectLocationOrEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please select location or enter address'**
  String get pleaseSelectLocationOrEnterAddress;

  /// No description provided for @pleaseFillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillAllRequiredFields;

  /// No description provided for @failedToCreateAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to create address'**
  String get failedToCreateAddress;

  /// No description provided for @failedToUpdateCartWithAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to update cart with address'**
  String get failedToUpdateCartWithAddress;

  /// No description provided for @addressCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Address creation failed'**
  String get addressCreationFailed;

  /// No description provided for @cartUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Cart update failed'**
  String get cartUpdateFailed;

  /// No description provided for @similarProducts.
  ///
  /// In en, this message translates to:
  /// **'Similar Products'**
  String get similarProducts;

  /// No description provided for @shippingAddress.
  ///
  /// In en, this message translates to:
  /// **'SHIPPING ADDRESS'**
  String get shippingAddress;

  /// No description provided for @noAddressesFound.
  ///
  /// In en, this message translates to:
  /// **'No addresses found. Please add an address.'**
  String get noAddressesFound;

  /// No description provided for @addressAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Address added successfully'**
  String get addressAddedSuccessfully;

  /// No description provided for @failedToAddAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to add address. Check console for details.'**
  String get failedToAddAddress;

  /// No description provided for @addressUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get addressUpdatedSuccessfully;

  /// No description provided for @failedToUpdateAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to update address. Check console for details.'**
  String get failedToUpdateAddress;

  /// No description provided for @addressDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Address deleted successfully'**
  String get addressDeletedSuccessfully;

  /// No description provided for @failedToDeleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete address'**
  String get failedToDeleteAddress;

  /// No description provided for @pleaseSelectBothAddresses.
  ///
  /// In en, this message translates to:
  /// **'Please select both delivery and shipping addresses'**
  String get pleaseSelectBothAddresses;

  /// No description provided for @deliveryMethod.
  ///
  /// In en, this message translates to:
  /// **'DELIVERY METHOD'**
  String get deliveryMethod;

  /// No description provided for @homeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Home delivery'**
  String get homeDelivery;

  /// No description provided for @storePickupDelivery.
  ///
  /// In en, this message translates to:
  /// **'Store pickup delivery'**
  String get storePickupDelivery;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @selectShop.
  ///
  /// In en, this message translates to:
  /// **'Select Shop'**
  String get selectShop;

  /// No description provided for @pickingDateTime.
  ///
  /// In en, this message translates to:
  /// **'Picking Date & Time'**
  String get pickingDateTime;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time :'**
  String get dateTime;

  /// No description provided for @september142025.
  ///
  /// In en, this message translates to:
  /// **'September 14, 2025'**
  String get september142025;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @pleaseEnterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter first name'**
  String get pleaseEnterFirstName;

  /// No description provided for @pleaseEnterLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter last name'**
  String get pleaseEnterLastName;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address Line 1'**
  String get addressLine1;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get pleaseEnterAddress;

  /// No description provided for @addressLine2Optional.
  ///
  /// In en, this message translates to:
  /// **'Address Line 2 (Optional)'**
  String get addressLine2Optional;

  /// No description provided for @pleaseEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter city'**
  String get pleaseEnterCity;

  /// No description provided for @postcodeOptional.
  ///
  /// In en, this message translates to:
  /// **'Postcode (Optional)'**
  String get postcodeOptional;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT METHOD'**
  String get paymentMethod;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @payInStore.
  ///
  /// In en, this message translates to:
  /// **'Pay in store'**
  String get payInStore;

  /// No description provided for @cashOnStore.
  ///
  /// In en, this message translates to:
  /// **'Cash on store'**
  String get cashOnStore;

  /// No description provided for @posOnlinePayment.
  ///
  /// In en, this message translates to:
  /// **'POS Online payment'**
  String get posOnlinePayment;

  /// No description provided for @onlinePayment.
  ///
  /// In en, this message translates to:
  /// **'Online payment'**
  String get onlinePayment;

  /// No description provided for @sadadPayment.
  ///
  /// In en, this message translates to:
  /// **'Sadad payment'**
  String get sadadPayment;

  /// No description provided for @mooamalatPayment.
  ///
  /// In en, this message translates to:
  /// **'Mooamalat payment'**
  String get mooamalatPayment;

  /// No description provided for @storagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied'**
  String get storagePermissionDenied;

  /// No description provided for @qrCodeSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'QR code saved to gallery!'**
  String get qrCodeSavedToGallery;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed!'**
  String get orderPlaced;

  /// No description provided for @yourOrder.
  ///
  /// In en, this message translates to:
  /// **'Your order'**
  String get yourOrder;

  /// No description provided for @wasPlacedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'was placed successfully.'**
  String get wasPlacedSuccessfully;

  /// No description provided for @checkOrdersForDetails.
  ///
  /// In en, this message translates to:
  /// **'For more details, check all my orders page under Profile tab'**
  String get checkOrdersForDetails;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @failedToLoadProfileData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile data'**
  String get failedToLoadProfileData;

  /// No description provided for @profileSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully'**
  String get profileSavedSuccessfully;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get myOrders;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'LYD'**
  String get currency;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found for'**
  String get noResultsFound;

  /// No description provided for @resultsFoundFor.
  ///
  /// In en, this message translates to:
  /// **'results found for'**
  String get resultsFoundFor;

  /// No description provided for @tryDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or check your spelling'**
  String get tryDifferentKeywords;

  /// No description provided for @homePage.
  ///
  /// In en, this message translates to:
  /// **'Home page'**
  String get homePage;

  /// No description provided for @backToHomePage.
  ///
  /// In en, this message translates to:
  /// **'Back to home page'**
  String get backToHomePage;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @refineYourSearch.
  ///
  /// In en, this message translates to:
  /// **'Refine Your Search'**
  String get refineYourSearch;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get applyFilters;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or Login with'**
  String get orLoginWith;

  /// No description provided for @googleLoginComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Google login coming soon...'**
  String get googleLoginComingSoon;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// No description provided for @facebookLoginComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Facebook login coming soon...'**
  String get facebookLoginComingSoon;

  /// No description provided for @loginWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Login with Facebook'**
  String get loginWithFacebook;

  /// No description provided for @orSignupWith.
  ///
  /// In en, this message translates to:
  /// **'Or Sign up with'**
  String get orSignupWith;

  /// No description provided for @googleSignupComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Google signup coming soon...'**
  String get googleSignupComingSoon;

  /// No description provided for @signupWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signupWithGoogle;

  /// No description provided for @facebookSignupComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Facebook signup coming soon...'**
  String get facebookSignupComingSoon;

  /// No description provided for @signupWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Facebook'**
  String get signupWithFacebook;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
