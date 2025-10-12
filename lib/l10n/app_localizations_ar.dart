// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تواصل';

  @override
  String greeting(String name) {
    return 'مرحبًا يا $name!';
  }

  @override
  String tasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مهمة',
      many: '$count مهمة',
      few: '$count مهام',
      two: 'مهمتان',
      one: 'مهمة واحدة',
      zero: 'لا مهام',
    );
    return '$_temp0';
  }

  @override
  String get language => 'اللغة';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get searchProducts => 'ابحث عن المنتجات';

  @override
  String get summerSale => 'تخفيضات الصيف';

  @override
  String get upTo50Off => 'خصم يصل إلى 50% على عناصر مختارة';

  @override
  String get techWeek => 'أسبوع التقنية';

  @override
  String get latestGadgets => 'أحدث الأجهزة بأسعار خاصة';

  @override
  String get newCollection => 'تشكيلة جديدة';

  @override
  String get discount30 => 'خصم 30٪ على أول عملية شراء';

  @override
  String get shop => 'تسوق الآن';

  @override
  String get quickAccess => 'وصول سريع';

  @override
  String get shops => 'المتاجر';

  @override
  String get bundles => 'الباقات';

  @override
  String get promo => 'عروض';

  @override
  String get warranty => 'الضمان';

  @override
  String get flashSale => 'عروض فلاش';

  @override
  String get all => 'الكل';

  @override
  String get newest => 'الأحدث';

  @override
  String get brands => 'العلامات التجارية';

  @override
  String get lyd => 'دينار';

  @override
  String get categories => 'الفئات';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get highTech => 'التقنية المتقدمة';

  @override
  String get smartHome => 'المنزل الذكي';

  @override
  String get smartOffice => 'المكتب الذكي';

  @override
  String get lifestyle => 'نمط الحياة';

  @override
  String get findTawasul => 'اعثر على تواصل';

  @override
  String get tawasulAll => 'تواصل - الكل';

  @override
  String get tawasulApple => 'تواصل - آبل';

  @override
  String get tawasulXiaomi => 'تواصل - شاومي';

  @override
  String get tawasulSamsung => 'تواصل - سامسونج';

  @override
  String get tawasulHuawei => 'تواصل - هواوي';

  @override
  String get streetAlKhototAlBaidaLibya => 'شارع الخطوط، البيضاء، ليبيا';

  @override
  String get veniceBenghaziLibya => 'فينيس، بنغازي، ليبيا';

  @override
  String get benghaziLibya => 'بنغازي، ليبيا';

  @override
  String get shariAlQayrawanBenghaziLibya => 'شارع القيروان، بنغازي، ليبيا';

  @override
  String get almadarStreetSertLibya =>
      'شارع المدار، مقابل ساحة المدينة، سرت، ليبيا';

  @override
  String get qadisiyahSquareTripoliLibya => 'ميدان القادسية، طرابلس، ليبيا';

  @override
  String get binAshourStreetTripoliLibya => 'شارع بن عاشور، طرابلس، ليبيا';

  @override
  String get awladBinAlHajStreetTripoliLibya =>
      'شارع أولاد بن الحاج، طرابلس، ليبيا';

  @override
  String get alJarabaMallTripoliLibya => 'مول الجرابة، طرابلس، ليبيا';

  @override
  String get grandMallTripoliLibya => 'غراند مول، طرابلس، ليبيا';

  @override
  String get regataVillageTripoliLibya => 'قرية ريقاتا، طرابلس، ليبيا';

  @override
  String get tripoliStreetTripoliLibya => 'شارع طرابلس، طرابلس، ليبيا';

  @override
  String get investmentMarketMisurataLibya =>
      'سوق الاستثمار، شارع سناء، قرب المسجد العالي، مصراتة، ليبيا';

  @override
  String get alMurqubDistrictMisurataLibya => 'منطقة المرقب، مصراتة، ليبيا';

  @override
  String get aldisStreetMisurataLibya => 'شارع الديس، مصراتة، ليبيا';

  @override
  String get mon => 'الاثنين';

  @override
  String get tue => 'الثلاثاء';

  @override
  String get wed => 'الأربعاء';

  @override
  String get thu => 'الخميس';

  @override
  String get fri => 'الجمعة';

  @override
  String get sat => 'السبت';

  @override
  String get sun => 'الأحد';

  @override
  String get bestOffer => 'أفضل عرض';

  @override
  String get topRated => 'الأعلى تقييمًا';

  @override
  String get priceLowHigh => 'السعر: من الأقل إلى الأعلى';

  @override
  String get priceHighLow => 'السعر: من الأعلى إلى الأقل';

  @override
  String get shoppingCart => 'سلة التسوق';

  @override
  String get enter => 'إدخال';

  @override
  String get enterDiscountCode => 'أدخل رمز الخصم';

  @override
  String get subTotal => 'المجموع الفرعي';

  @override
  String get checkout => 'الدفع';

  @override
  String get clear => 'مسح';

  @override
  String get addYourDetails => 'أدخل بياناتك';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'الاسم الأخير';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get setYourLocalization => 'اضبط موقعك';

  @override
  String get chooseYourLocation => 'حدد موقعك';

  @override
  String get orSetAllYourInformationBelow => 'أو أدخل جميع معلوماتك أدناه';

  @override
  String get address => 'العنوان';

  @override
  String get additionalAddress => 'عنوان إضافي';

  @override
  String get city => 'المدينة';

  @override
  String get optional => 'اختياري';

  @override
  String get myBillingAddress => 'عنوان الفوترة';

  @override
  String get isTheSameAsMyDeliveryAddress => 'هو نفس عنوان التوصيل';

  @override
  String get validateAndContinue => 'تأكيد ومتابعة';

  @override
  String get addNewAddress => 'إضافة عنوان جديد';

  @override
  String get myFavorites => 'منتجاتي المفضلة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'التسجيل';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get connexion => 'اتصال';

  @override
  String get pleaseEnterYourInformation =>
      'يرجى إدخال معلوماتك لتسجيل الدخول إلى حسابك';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get newClient => 'عميل جديد؟';

  @override
  String get createYourAccount => 'أنشئ حسابك';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get pleaseEnterYourPhoneNumber =>
      'يرجى إدخال رقم هاتفك المرتبط بحسابك';

  @override
  String get confirm => 'تأكيد';

  @override
  String get useEmailInstead => 'استخدم البريد الإلكتروني بدلًا من ذلك';

  @override
  String get pleaseEnterYourEmail =>
      'يرجى إدخال بريدك الإلكتروني المرتبط بحسابك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get usePhoneNumberInstead => 'استخدم رقم الهاتف بدلًا من ذلك';

  @override
  String get country => 'البلد';

  @override
  String get gender => 'الجنس';

  @override
  String get birthday => 'تاريخ الميلاد';

  @override
  String get iAcceptTheTerms => 'أوافق على الشروط والأحكام وسياسة الخصوصية';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get firstNameIsRequired => 'الاسم الأول مطلوب';

  @override
  String get lastNameIsRequired => 'الاسم الأخير مطلوب';

  @override
  String get emailIsRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get passwordIsRequired => 'كلمة المرور مطلوبة';

  @override
  String get phoneNumberIsRequired => 'رقم الهاتف مطلوب';

  @override
  String get accountValidation => 'تأكيد الحساب';

  @override
  String get pleaseEnterTheCodeNumber => 'يرجى إدخال رمز التحقق';

  @override
  String get pleaseEnterUsernameAndPassword =>
      'يرجى إدخال اسم المستخدم وكلمة المرور';

  @override
  String get pleaseEnterYourInformationsToConnectToYourAccount =>
      'يرجى إدخال معلوماتك لتسجيل الدخول إلى حسابك';

  @override
  String get codeNumber => 'رمز التحقق';

  @override
  String get resendTheCode => 'إعادة إرسال الرمز';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get favorites => 'المفضلة';

  @override
  String get orderHistory => 'سجل الطلبات';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get yourName => 'اسمك';

  @override
  String get yourEmail => 'بريدك الإلكتروني';

  @override
  String get yourPhoneNumber => 'رقم هاتفك';

  @override
  String get yourPassword => 'كلمة مرورك';

  @override
  String get saveModification => 'حفظ التعديلات';

  @override
  String get delete => 'حذف';

  @override
  String get upload => 'رفع';

  @override
  String get pleaseSetYourNewPassword => 'يرجى تعيين كلمة مرورك الجديدة';

  @override
  String get oldPassword => 'كلمة المرور القديمة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get areYouSureYouWantToLogout => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get noProductsFoundFor => ' لم يتم العثور على منتجات لـ';

  @override
  String get typeToSearch => 'اكتب للبحث';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get errorFetchingProduct => 'Error Fetching Product';

  @override
  String get noTokenFound => 'لم يتم العثور على رمز. يرجى تسجيل الدخول.';

  @override
  String get appliedFilters => 'الفلاتر المطبقة';

  @override
  String get apiError => 'خطأ في واجهة البرمجة';

  @override
  String get failedToLoad => 'فشل في التحميل';

  @override
  String get networkError =>
      'خطأ في الشبكة: يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';

  @override
  String get requestTimeout =>
      'انتهت مهلة الطلب: يرجى التحقق من اتصال الإنترنت.';

  @override
  String get anErrorOccurred => 'حدث خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get off => 'خصم';

  @override
  String get tripoli => 'طرابلس';

  @override
  String get benghazi => 'بنغازي';

  @override
  String get misrata => 'مصراتة';

  @override
  String get bayda => 'البيضاء';

  @override
  String get zawiya => 'الزاوية';

  @override
  String get gharyan => 'غريان';

  @override
  String get tobruk => 'طبرق';

  @override
  String get ajdabiya => 'اجدابيا';

  @override
  String get zleiten => 'زليتن';

  @override
  String get derna => 'درنة';

  @override
  String get sirte => 'سرت';

  @override
  String get sabha => 'سبها';

  @override
  String get khoms => 'الخمس';

  @override
  String get bani_walid => 'بني وليد';

  @override
  String get sabratha => 'صبراتة';

  @override
  String get zuwara => 'زوارة';

  @override
  String get kufra => 'الكفرة';

  @override
  String get marj => 'المرج';

  @override
  String get tocra => 'توكرة';

  @override
  String get tarhuna => 'ترهونة';

  @override
  String get msallata => 'مسلاتة';

  @override
  String get jumayl => 'الجميل';

  @override
  String get sorman => 'صرمان';

  @override
  String get al_gseibat => 'القسيبات';

  @override
  String get shahat => 'شحات';

  @override
  String get ubari => 'أوباري';

  @override
  String get asbia => 'الأصابعة';

  @override
  String get jadid => 'جديد';

  @override
  String get waddan => 'ودان';

  @override
  String get el_agheila => 'العقيلة';

  @override
  String get abyar => 'الأبيار';

  @override
  String get nofaliya => 'النوفلية';

  @override
  String get regdalin => 'رقدالين';

  @override
  String get gasr_akhyar => 'قصر أخيار';

  @override
  String get al_qubah => 'القبة';

  @override
  String get tawergha => 'تاورغاء';

  @override
  String get al_maya => 'المية';

  @override
  String get murzuk => 'مرزق';

  @override
  String get brega => 'بريقة';

  @override
  String get teghsat => 'تغسات';

  @override
  String get hun => 'هن';

  @override
  String get jalu => 'جالو';

  @override
  String get ajaylat => 'أجيلات';

  @override
  String get nalut => 'نالوت';

  @override
  String get suluq => 'سلوق';

  @override
  String get shuhada_al_buerat => 'شهداء البئرات';

  @override
  String get zaltan => 'زلطن';

  @override
  String get mizda => 'مزدة';

  @override
  String get ras_lanuf => 'رأس لانوف';

  @override
  String get al_urban => 'العرق';

  @override
  String get yafran => 'يفرن';

  @override
  String get ar_rayaniya => 'الرايانية';

  @override
  String get umm_al_rizam => 'أم الرزم';

  @override
  String get taucheira => 'توشيرة';

  @override
  String get brak => 'براك';

  @override
  String get abu_ghlasha => 'أبو غلاشة';

  @override
  String get ad_dawoon => 'الدواون';

  @override
  String get teji => 'تاجي';

  @override
  String get qaminis => 'قمينس';

  @override
  String get qatrun => 'قطرون';

  @override
  String get benina => 'بنينا';

  @override
  String get kikla => 'ككلة';

  @override
  String get al_rheibat => 'الرهيبات';

  @override
  String get sokna => 'سوقنا';

  @override
  String get massa => 'مسا';

  @override
  String get bin_jawad => 'بن جواد';

  @override
  String get umm_al_aranib => 'أم الأرانب';

  @override
  String get jadu => 'جادو';

  @override
  String get ghadames => 'غدامس';

  @override
  String get ar_rabta => 'الرابطة';

  @override
  String get ghat => 'غات';

  @override
  String get al_abraq => 'الأبرق';

  @override
  String get sidi_as_said => 'سيدي السعيد';

  @override
  String get ar_rajban => 'الرجبان';

  @override
  String get awjila => 'أوجلة';

  @override
  String get ras_al_hamam => 'رأس الحمام';

  @override
  String get tolmeita => 'طلميثة';

  @override
  String get zella => 'زلّة';

  @override
  String get wadi_utba => 'وادي أتبّة';

  @override
  String get al_barkat => 'البُركَات';

  @override
  String get martuba => 'مَرْتُبَة';

  @override
  String get traghan => 'تراغان';

  @override
  String get al_hashan => 'الحشان';

  @override
  String get el_bayyada => 'البيضاء';

  @override
  String get qayqab => 'قَيْقَب';

  @override
  String get mashashita => 'مشاشيته';

  @override
  String get bu_fakhra => 'بو فاخرة';

  @override
  String get musaid => 'مساعيد';

  @override
  String get tacnis => 'تاكنيس';

  @override
  String get susa => 'سوسة';

  @override
  String get wadi_zem_zem => 'وادي زمزم';

  @override
  String get batta => 'بَطَّة';

  @override
  String get tazirbu => 'تازربو';

  @override
  String get farzougha => 'فرزوغة';

  @override
  String get qaryat_umar_al_mukhtar => 'قرية عمر المختار';

  @override
  String get bir_al_ashhab => 'بئر الأشهب';

  @override
  String get gadames => 'غدامس';

  @override
  String get pleaseEnterAllMandatoryInformationToCreateAnAccount =>
      'يرجى إدخال جميع المعلومات الإلزامية لإنشاء حساب';

  @override
  String get libya => 'Libya';

  @override
  String get pleaseEnterAValidEmail => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get mustContainUppercaseLetter => 'يجب أن تحتوي على حرف كبير';

  @override
  String get mustContainLowercaseLetter => 'يجب أن تحتوي على حرف صغير';

  @override
  String get mustContainNumber => 'يجب أن تحتوي على رقم';

  @override
  String get mustContainSpecialCharacter => 'Must contain special character';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get setYourLocalisation => 'قم بتعيين موقعك';

  @override
  String get zipCode => 'الرمز البريدي';

  @override
  String get change => 'تغيير';

  @override
  String get yourCartIsEmpty => 'سلة التسوق فارغة';

  @override
  String get addItemsToGetStarted => 'أضف منتجات للبدء';

  @override
  String get continueShopping => 'تابع التسوق';

  @override
  String get noTitle => 'بدون عنوان';

  @override
  String get items => 'المنتجات';

  @override
  String get pleaseLoginToCheckout => 'يرجى تسجيل الدخول لإتمام عملية الشراء';

  @override
  String get productDetails => 'تفاصيل المنتج';

  @override
  String get loadingProduct => 'جاري تحميل المنتج...';

  @override
  String get productNotFound => 'المنتج غير موجود';

  @override
  String get noDescription => 'لا يوجد وصف';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get buyNow => 'اشتري الآن';

  @override
  String get productAddedToCart => 'تمت إضافة المنتج إلى السلة بنجاح!';

  @override
  String get failedToLoadUserInfo =>
      'فشل تحميل معلومات المستخدم. يرجى المحاولة مرة أخرى.';

  @override
  String get selectedLocation => 'الموقع المحدد';

  @override
  String get homeAddress => 'عنوان المنزل';

  @override
  String get pleaseLoginFirst => 'يرجى تسجيل الدخول أولاً';

  @override
  String get pleaseEnterValidPhoneNumber => 'يرجى إدخال رقم هاتف صالح';

  @override
  String get pleaseSelectLocationOrEnterAddress =>
      'يرجى تحديد الموقع أو إدخال العنوان';

  @override
  String get pleaseFillAllRequiredFields => 'يرجى ملء جميع الحقول المطلوبة';

  @override
  String get failedToCreateAddress => 'فشل إنشاء العنوان';

  @override
  String get failedToUpdateCartWithAddress => 'فشل تحديث السلة مع العنوان';

  @override
  String get addressCreationFailed => 'فشل إنشاء العنوان';

  @override
  String get cartUpdateFailed => 'فشل تحديث السلة';

  @override
  String get similarProducts => 'منتجات مشابهة';

  @override
  String get shippingAddress => 'عنوان الشحن';

  @override
  String get noAddressesFound => 'لم يتم العثور على عناوين. يرجى إضافة عنوان.';

  @override
  String get addressAddedSuccessfully => 'تمت إضافة العنوان بنجاح';

  @override
  String get failedToAddAddress =>
      'فشل إضافة العنوان. تحقق من وحدة التحكم للتفاصيل.';

  @override
  String get addressUpdatedSuccessfully => 'تم تحديث العنوان بنجاح';

  @override
  String get failedToUpdateAddress =>
      'فشل تحديث العنوان. تحقق من وحدة التحكم للتفاصيل.';

  @override
  String get addressDeletedSuccessfully => 'تم حذف العنوان بنجاح';

  @override
  String get failedToDeleteAddress => 'فشل حذف العنوان';

  @override
  String get pleaseSelectBothAddresses =>
      'يرجى تحديد كل من عناوين التوصيل والشحن';

  @override
  String get deliveryMethod => 'طريقة التوصيل';

  @override
  String get homeDelivery => 'توصيل إلى المنزل';

  @override
  String get storePickupDelivery => 'استلام من المتجر';

  @override
  String get selectCity => 'اختر المدينة';

  @override
  String get selectShop => 'اختر المتجر';

  @override
  String get pickingDateTime => 'تاريخ ووقت الاستلام';

  @override
  String get dateTime => 'التاريخ والوقت :';

  @override
  String get september142025 => '14 سبتمبر 2025';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get editAddress => 'تعديل العنوان';

  @override
  String get pleaseEnterFirstName => 'يرجى إدخال الاسم الأول';

  @override
  String get pleaseEnterLastName => 'يرجى إدخال الاسم الأخير';

  @override
  String get addressLine1 => 'سطر العنوان 1';

  @override
  String get pleaseEnterAddress => 'يرجى إدخال العنوان';

  @override
  String get addressLine2Optional => 'سطر العنوان 2 (اختياري)';

  @override
  String get pleaseEnterCity => 'يرجى إدخال المدينة';

  @override
  String get postcodeOptional => 'الرمز البريدي (اختياري)';

  @override
  String get pleaseEnterPhoneNumber => 'يرجى إدخال رقم الهاتف';

  @override
  String get update => 'تحديث';

  @override
  String get add => 'إضافة';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get placeOrder => 'تقديم الطلب';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get shipping => 'الشحن';

  @override
  String get tax => 'الضريبة';

  @override
  String get total => 'المجموع';

  @override
  String get payInStore => 'الدفع في المتجر';

  @override
  String get cashOnStore => 'الدفع نقداً في المتجر';

  @override
  String get posOnlinePayment => 'الدفع الإلكتروني عبر البوس';

  @override
  String get onlinePayment => 'الدفع الإلكتروني';

  @override
  String get sadadPayment => 'الدفع عبر سداد';

  @override
  String get mooamalatPayment => 'الدفع عبر المعاملات';

  @override
  String get storagePermissionDenied => 'تم رفض إذن التخزين';

  @override
  String get qrCodeSavedToGallery => 'تم حفظ رمز الاستجابة السريعة في المعرض!';

  @override
  String get error => 'خطأ';

  @override
  String get orderPlaced => 'تم تقديم الطلب!';

  @override
  String get yourOrder => 'طلبك';

  @override
  String get wasPlacedSuccessfully => 'تم تقديمه بنجاح.';

  @override
  String get checkOrdersForDetails =>
      'لمزيد من التفاصيل، تحقق من صفحة جميع طلباتي تحت علامة التبويب الملف الشخصي';

  @override
  String get download => 'تحميل';

  @override
  String get failedToLoadProfileData => 'فشل في تحميل بيانات الملف الشخصي';

  @override
  String get profileSavedSuccessfully => 'تم حفظ الملف الشخصي بنجاح';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get currency => 'LYD';

  @override
  String get noResultsFound => 'No results found for';

  @override
  String get resultsFoundFor => 'ننتائج وجدت لـ';

  @override
  String get tryDifferentKeywords => 'جرب كلمات مختلفة أو تحقق من الهجاء';

  @override
  String get homePage => 'الصفحة الرئيسية';

  @override
  String get backToHomePage => 'العودة إلى الصفحة الرئيسية';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get validate => 'تحقق';

  @override
  String get filter => 'تصفية';

  @override
  String get refineYourSearch => 'أعد البحث';

  @override
  String get priceRange => 'نطاق السعر';

  @override
  String get color => 'اللون';

  @override
  String get select => 'اختر';

  @override
  String get applyFilters => 'تطبيق الفلتر';

  @override
  String get notification => 'الإشعارات';

  @override
  String get orders => 'الطلبات';

  @override
  String get alerts => 'التنبيهات';

  @override
  String get orLoginWith => 'أو سجل الدخول باستخدام';

  @override
  String get googleLoginComingSoon => 'تسجيل الدخول عبر جوجل قريباً...';

  @override
  String get loginWithGoogle => 'تسجيل الدخول باستخدام جوجل';

  @override
  String get facebookLoginComingSoon => 'تسجيل الدخول عبر فيسبوك قريباً...';

  @override
  String get loginWithFacebook => 'تسجيل الدخول باستخدام فيسبوك';

  @override
  String get orSignupWith => 'أو سجل حساباً باستخدام';

  @override
  String get googleSignupComingSoon => 'التسجيل عبر جوجل قريباً...';

  @override
  String get signupWithGoogle => 'التسجيل باستخدام جوجل';

  @override
  String get facebookSignupComingSoon => 'التسجيل عبر فيسبوك قريباً...';

  @override
  String get signupWithFacebook => 'التسجيل باستخدام فيسبوك';
}
