// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tawasul';

  @override
  String greeting(String name) {
    return 'Hi $name!';
  }

  @override
  String tasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: 'One task',
      zero: 'No tasks',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Language';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get chooseLanguage => 'Choose a language';

  @override
  String get searchProducts => 'Search Products';

  @override
  String get summerSale => 'Summer Sale';

  @override
  String get upTo50Off => 'Up to 50% off on selected items';

  @override
  String get techWeek => 'Tech Week';

  @override
  String get latestGadgets => 'Latest gadgets at special prices';

  @override
  String get newCollection => 'New Collection';

  @override
  String get discount30 => 'Discount 30% for the first transaction';

  @override
  String get shop => 'Shop Now';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get shops => 'Shops';

  @override
  String get bundles => 'Bundles';

  @override
  String get promo => 'Promo';

  @override
  String get warranty => 'Warranty';

  @override
  String get flashSale => 'Flash Sale';

  @override
  String get all => 'All';

  @override
  String get newest => 'Newest';

  @override
  String get brands => 'Brands';

  @override
  String get lyd => 'LYD';

  @override
  String get categories => 'Categories';

  @override
  String get seeAll => 'See All';

  @override
  String get highTech => 'HighTech';

  @override
  String get smartHome => 'Smart Home';

  @override
  String get smartOffice => 'Smart Office';

  @override
  String get lifestyle => 'Lifestyle';

  @override
  String get findTawasul => 'Find Tawasul';

  @override
  String get tawasulAll => 'Tawasul All';

  @override
  String get tawasulApple => 'Tawasul Apple';

  @override
  String get tawasulXiaomi => 'Tawasul Xiaomi';

  @override
  String get tawasulSamsung => 'Tawasul Samsung';

  @override
  String get tawasulHuawei => 'Tawasul Huawei';

  @override
  String get streetAlKhototAlBaidaLibya => 'Street Al Khotot, Al Baida, Libya';

  @override
  String get veniceBenghaziLibya => 'Venice, Benghazi, Libya';

  @override
  String get benghaziLibya => 'Benghazi, Libya';

  @override
  String get shariAlQayrawanBenghaziLibya => 'Shari Al Qayrawan, Benghazi, Libya';

  @override
  String get almadarStreetSertLibya => 'Almadar Street, in front of the city Square, Sert, Libya';

  @override
  String get qadisiyahSquareTripoliLibya => 'Qadisiyah Square, Tripoli, Libya';

  @override
  String get binAshourStreetTripoliLibya => 'Bin Ashour Street, Tripoli, Libya';

  @override
  String get awladBinAlHajStreetTripoliLibya => 'Awlad Bin al Haj Street, Tripoli, Libya';

  @override
  String get alJarabaMallTripoliLibya => 'Al Jaraba Mall, Tripoli, Libya';

  @override
  String get grandMallTripoliLibya => 'Grand Mall, Tripoli, Libya';

  @override
  String get regataVillageTripoliLibya => 'Regata Village, Tripoli, Libya';

  @override
  String get tripoliStreetTripoliLibya => 'Tripoli Street, Tripoli, Libya';

  @override
  String get investmentMarketMisurataLibya => 'Investment market, Sana Street, near The High Mosque, Misurata, Libya';

  @override
  String get alMurqubDistrictMisurataLibya => 'Al Murqub District, Misurata, Libya';

  @override
  String get aldisStreetMisurataLibya => 'Aldis Street, Misurata, Libya';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get bestOffer => 'Best Offer';

  @override
  String get topRated => 'Top Rated';

  @override
  String get priceLowHigh => 'Price Low-High';

  @override
  String get priceHighLow => 'Price High-Low';

  @override
  String get shoppingCart => 'Shopping Cart';

  @override
  String get enter => 'Enter';

  @override
  String get enterDiscountCode => 'Enter Discount Code';

  @override
  String get subTotal => 'Sub Total';

  @override
  String get checkout => 'Checkout';

  @override
  String get clear => 'Clear';

  @override
  String get addYourDetails => 'Add Your Details';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get setYourLocalization => 'Set your localization';

  @override
  String get chooseYourLocation => 'Set your Location';

  @override
  String get orSetAllYourInformationBelow => 'Or set all your information below';

  @override
  String get address => 'Address';

  @override
  String get additionalAddress => 'Additional address';

  @override
  String get city => 'City';

  @override
  String get optional => 'Optional';

  @override
  String get myBillingAddress => 'My Billing Address';

  @override
  String get isTheSameAsMyDeliveryAddress => 'Is The Same As My Delivery Address';

  @override
  String get validateAndContinue => 'Validate and continue';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Signup';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get connexion => 'Connexion';

  @override
  String get pleaseEnterYourInformation => 'Please enter your information to connect to your account';

  @override
  String get forgotPassword => 'Forgot password ?';

  @override
  String get newClient => 'New client ?';

  @override
  String get createYourAccount => 'Create your account';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get pleaseEnterYourPhoneNumber => 'Please enter your phone number associated with your account';

  @override
  String get confirm => 'Confirm';

  @override
  String get useEmailInstead => 'Use Email Instead';

  @override
  String get pleaseEnterYourEmail => 'Please enter your email associated with your account';

  @override
  String get email => 'Email';

  @override
  String get usePhoneNumberInstead => 'Use phone number instead';

  @override
  String get country => 'Country';

  @override
  String get gender => 'Gender';

  @override
  String get birthday => 'Birthday';

  @override
  String get iAcceptTheTerms => 'I accept the terms and conditions and privacy policy';

  @override
  String get createAccount => 'Create Account';

  @override
  String get firstNameIsRequired => 'First name is required';

  @override
  String get lastNameIsRequired => 'Last name is required';

  @override
  String get emailIsRequired => 'Email is required';

  @override
  String get passwordIsRequired => 'Password is required';

  @override
  String get phoneNumberIsRequired => 'Phone number is required';

  @override
  String get accountValidation => 'Account Validation';

  @override
  String get pleaseEnterTheCodeNumber => 'Please enter the code number';

  @override
  String get pleaseEnterUsernameAndPassword => 'Please enter username and password';

  @override
  String get pleaseEnterYourInformationsToConnectToYourAccount => 'Please enter your informations to connect \nto your account';

  @override
  String get codeNumber => 'Code number';

  @override
  String get resendTheCode => 'Resend the code';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get favorites => 'Favorites';

  @override
  String get orderHistory => 'Order History';

  @override
  String get changePassword => 'Change Password';

  @override
  String get logout => 'Logout';

  @override
  String get yourName => 'Your Name';

  @override
  String get yourEmail => 'Your Email';

  @override
  String get yourPhoneNumber => 'Your phone number';

  @override
  String get yourPassword => 'Your Password';

  @override
  String get saveModification => 'Save modification';

  @override
  String get delete => 'Delete';

  @override
  String get upload => 'Upload';

  @override
  String get pleaseSetYourNewPassword => 'Please set your new password';

  @override
  String get oldPassword => 'Old password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get areYouSureYouWantToLogout => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get noProductsFoundFor => 'No products found for';

  @override
  String get typeToSearch => 'Type to search';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get errorFetchingProduct => 'Error Fetching Product';

  @override
  String get noTokenFound => 'No token found. Please log in.';

  @override
  String get appliedFilters => 'Applied Filters';

  @override
  String get apiError => 'API Error';

  @override
  String get failedToLoad => 'Failed to load';

  @override
  String get networkError => 'Network error: Please check your internet connection and try again.';

  @override
  String get requestTimeout => 'Request timeout: Please check your internet connection.';

  @override
  String get anErrorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get off => 'OFF';

  @override
  String get tripoli => 'tripoli';

  @override
  String get benghazi => 'Benghazi';

  @override
  String get misrata => 'Misrata';

  @override
  String get bayda => 'Bayda';

  @override
  String get zawiya => 'Zawiya';

  @override
  String get gharyan => 'Gharyan';

  @override
  String get tobruk => 'Tobruk';

  @override
  String get ajdabiya => 'Ajdabiya';

  @override
  String get zleiten => 'Zleiten';

  @override
  String get derna => 'Derna';

  @override
  String get sirte => 'Sirte';

  @override
  String get sabha => 'Sabha';

  @override
  String get khoms => 'Khoms';

  @override
  String get bani_walid => 'Bani Walid';

  @override
  String get sabratha => 'Sabratha';

  @override
  String get zuwara => 'Zuwara';

  @override
  String get kufra => 'Kufra';

  @override
  String get marj => 'Marj';

  @override
  String get tocra => 'Tocra';

  @override
  String get tarhuna => 'Tarhuna';

  @override
  String get msallata => 'Msallata';

  @override
  String get jumayl => 'Jumayl';

  @override
  String get sorman => 'Sorman';

  @override
  String get al_gseibat => 'Al Gseibat';

  @override
  String get shahat => 'Shahat';

  @override
  String get ubari => 'Ubari';

  @override
  String get asbia => 'Asbi\'a';

  @override
  String get jadid => 'Jadid';

  @override
  String get waddan => 'Waddan';

  @override
  String get el_agheila => 'El Agheila';

  @override
  String get abyar => 'Abyar';

  @override
  String get nofaliya => 'Nofaliya';

  @override
  String get regdalin => 'Regdalin';

  @override
  String get gasr_akhyar => 'Gasr Akhyar';

  @override
  String get al_qubah => 'Al Qubah';

  @override
  String get tawergha => 'Tawergha';

  @override
  String get al_maya => 'Al Maya';

  @override
  String get murzuk => 'Murzuk';

  @override
  String get brega => 'Brega';

  @override
  String get teghsat => 'Teghsat';

  @override
  String get hun => 'Hun';

  @override
  String get jalu => 'Jalu';

  @override
  String get ajaylat => 'Ajaylat';

  @override
  String get nalut => 'Nalut';

  @override
  String get suluq => 'Suluq';

  @override
  String get shuhada_al_buerat => 'Shuhada Al Buerat';

  @override
  String get zaltan => 'Zaltan';

  @override
  String get mizda => 'Mizda';

  @override
  String get ras_lanuf => 'Ras Lanuf';

  @override
  String get al_urban => 'Al Urban';

  @override
  String get yafran => 'Yafran';

  @override
  String get ar_rayaniya => 'Ar Rayaniya';

  @override
  String get umm_al_rizam => 'Umm Al Rizam';

  @override
  String get taucheira => 'Taucheira';

  @override
  String get brak => 'Brak';

  @override
  String get abu_ghlasha => 'Abu Ghlasha';

  @override
  String get ad_dawoon => 'Ad Dawoon';

  @override
  String get teji => 'Teji';

  @override
  String get qaminis => 'Qaminis';

  @override
  String get qatrun => 'Qatrun';

  @override
  String get benina => 'Benina';

  @override
  String get kikla => 'Kikla';

  @override
  String get al_rheibat => 'Al Rheibat';

  @override
  String get sokna => 'Sokna';

  @override
  String get massa => 'Massa';

  @override
  String get bin_jawad => 'Bin Jawad';

  @override
  String get umm_al_aranib => 'Umm Al Aranib';

  @override
  String get jadu => 'Jadu';

  @override
  String get ghadames => 'Ghadames';

  @override
  String get ar_rabta => 'Ar Rabta';

  @override
  String get ghat => 'Ghat';

  @override
  String get al_abraq => 'Al Abraq';

  @override
  String get sidi_as_said => 'Sidi As Said';

  @override
  String get ar_rajban => 'Ar Rajban';

  @override
  String get awjila => 'Awjila';

  @override
  String get ras_al_hamam => 'Ras Al Hamam';

  @override
  String get tolmeita => 'Tolmeita';

  @override
  String get zella => 'Zella';

  @override
  String get wadi_utba => 'Wadi Utba';

  @override
  String get al_barkat => 'Al Barkat';

  @override
  String get martuba => 'Martuba';

  @override
  String get traghan => 'Traghan';

  @override
  String get al_hashan => 'Al Hashan';

  @override
  String get el_bayyada => 'El Bayyada';

  @override
  String get qayqab => 'Qayqab';

  @override
  String get mashashita => 'Mashashita';

  @override
  String get bu_fakhra => 'Bu Fakhra';

  @override
  String get musaid => 'Musaid';

  @override
  String get tacnis => 'Tacnis';

  @override
  String get susa => 'Susa';

  @override
  String get wadi_zem_zem => 'Wadi Zem Zem';

  @override
  String get batta => 'Batta';

  @override
  String get tazirbu => 'Tazirbu';

  @override
  String get farzougha => 'Farzougha';

  @override
  String get qaryat_umar_al_mukhtar => 'Qaryat Umar Al Mukhtar';

  @override
  String get bir_al_ashhab => 'Bir Al Ashhab';

  @override
  String get gadames => 'Gadames';

  @override
  String get pleaseEnterAllMandatoryInformationToCreateAnAccount => 'Please enter all mandatory information to create an account';

  @override
  String get libya => 'Libya';

  @override
  String get pleaseEnterAValidEmail => 'Please enter a valid email';

  @override
  String get passwordMustBeAtLeast8Characters => 'Password must be at least 8 characters';

  @override
  String get mustContainUppercaseLetter => 'Must contain uppercase letter';

  @override
  String get mustContainLowercaseLetter => 'Must contain lowercase letter';

  @override
  String get mustContainNumber => 'Must contain number';

  @override
  String get mustContainSpecialCharacter => 'Must contain special character';

  @override
  String get male => 'male';

  @override
  String get female => 'female';

  @override
  String get setYourLocalisation => 'Set your localization';

  @override
  String get zipCode => 'Zip Code';

  @override
  String get change => 'Change';

  @override
  String get yourCartIsEmpty => 'Yourcart is empty';

  @override
  String get addItemsToGetStarted => 'Add items to get started';

  @override
  String get continueShopping => 'Continue shopping';

  @override
  String get noTitle => 'No title';

  @override
  String get items => 'Items';

  @override
  String get pleaseLoginToCheckout => 'Please login to checkout';

  @override
  String get productDetails => 'Product details';

  @override
  String get loadingProduct => 'Loading product...';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get noDescription => 'No Description';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get buyNow => 'Buy now';

  @override
  String get productAddedToCart => 'Product added to cart successfully!';

  @override
  String get failedToLoadUserInfo => 'Failed to load user information. Please try again.';

  @override
  String get selectedLocation => 'Selected Location';

  @override
  String get homeAddress => 'Home Address';

  @override
  String get pleaseLoginFirst => 'Please login first';

  @override
  String get pleaseEnterValidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get pleaseSelectLocationOrEnterAddress => 'Please select location or enter address';

  @override
  String get pleaseFillAllRequiredFields => 'Please fill all required fields';

  @override
  String get failedToCreateAddress => 'Failed to create address';

  @override
  String get failedToUpdateCartWithAddress => 'Failed to update cart with address';

  @override
  String get addressCreationFailed => 'Address creation failed';

  @override
  String get cartUpdateFailed => 'Cart update failed';

  @override
  String get similarProducts => 'Similar Products';

  @override
  String get shippingAddress => 'SHIPPING ADDRESS';

  @override
  String get noAddressesFound => 'No addresses found. Please add an address.';

  @override
  String get addressAddedSuccessfully => 'Address added successfully';

  @override
  String get failedToAddAddress => 'Failed to add address. Check console for details.';

  @override
  String get addressUpdatedSuccessfully => 'Address updated successfully';

  @override
  String get failedToUpdateAddress => 'Failed to update address. Check console for details.';

  @override
  String get addressDeletedSuccessfully => 'Address deleted successfully';

  @override
  String get failedToDeleteAddress => 'Failed to delete address';

  @override
  String get pleaseSelectBothAddresses => 'Please select both delivery and shipping addresses';

  @override
  String get deliveryMethod => 'DELIVERY METHOD';

  @override
  String get homeDelivery => 'Home delivery';

  @override
  String get storePickupDelivery => 'Store pickup delivery';

  @override
  String get selectCity => 'Select City';

  @override
  String get selectShop => 'Select Shop';

  @override
  String get pickingDateTime => 'Picking Date & Time';

  @override
  String get dateTime => 'Date & Time :';

  @override
  String get september142025 => 'September 14, 2025';

  @override
  String get selectTime => 'Select time';

  @override
  String get editAddress => 'Edit Address';

  @override
  String get pleaseEnterFirstName => 'Please enter first name';

  @override
  String get pleaseEnterLastName => 'Please enter last name';

  @override
  String get addressLine1 => 'Address Line 1';

  @override
  String get pleaseEnterAddress => 'Please enter address';

  @override
  String get addressLine2Optional => 'Address Line 2 (Optional)';

  @override
  String get pleaseEnterCity => 'Please enter city';

  @override
  String get postcodeOptional => 'Postcode (Optional)';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter phone number';

  @override
  String get update => 'Update';

  @override
  String get add => 'Add';

  @override
  String get paymentMethod => 'PAYMENT METHOD';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shipping => 'Shipping';

  @override
  String get tax => 'Tax';

  @override
  String get total => 'Total';

  @override
  String get payInStore => 'Pay in store';

  @override
  String get cashOnStore => 'Cash on store';

  @override
  String get posOnlinePayment => 'POS Online payment';

  @override
  String get onlinePayment => 'Online payment';

  @override
  String get sadadPayment => 'Sadad payment';

  @override
  String get mooamalatPayment => 'Mooamalat payment';

  @override
  String get storagePermissionDenied => 'Storage permission denied';

  @override
  String get qrCodeSavedToGallery => 'QR code saved to gallery!';

  @override
  String get error => 'Error';

  @override
  String get orderPlaced => 'Order Placed!';

  @override
  String get yourOrder => 'Your order';

  @override
  String get wasPlacedSuccessfully => 'was placed successfully.';

  @override
  String get checkOrdersForDetails => 'For more details, check all my orders page under Profile tab';

  @override
  String get download => 'Download';

  @override
  String get failedToLoadProfileData => 'Failed to load profile data';

  @override
  String get profileSavedSuccessfully => 'Profile saved successfully';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get myOrders => 'My orders';

  @override
  String get currency => 'LYD';

  @override
  String get noResultsFound => 'No results found for';

  @override
  String get resultsFoundFor => 'results found for';

  @override
  String get tryDifferentKeywords => 'Try different keywords or check your spelling';

  @override
  String get homePage => 'Home page';

  @override
  String get backToHomePage => 'Back to home page';

  @override
  String get selectDate => 'Select date';

  @override
  String get validate => 'Validate';

  @override
  String get filter => 'Filter';

  @override
  String get refineYourSearch => 'Refine Your Search';

  @override
  String get priceRange => 'Price Range';

  @override
  String get color => 'Color';

  @override
  String get select => 'Select';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get notification => 'Notification';

  @override
  String get orders => 'Orders';

  @override
  String get alerts => 'Alerts';

  @override
  String get orLoginWith => 'Or Login with';

  @override
  String get googleLoginComingSoon => 'Google login coming soon...';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get facebookLoginComingSoon => 'Facebook login coming soon...';

  @override
  String get loginWithFacebook => 'Login with Facebook';

  @override
  String get orSignupWith => 'Or Sign up with';

  @override
  String get googleSignupComingSoon => 'Google signup coming soon...';

  @override
  String get signupWithGoogle => 'Sign up with Google';

  @override
  String get facebookSignupComingSoon => 'Facebook signup coming soon...';

  @override
  String get signupWithFacebook => 'Sign up with Facebook';
}
