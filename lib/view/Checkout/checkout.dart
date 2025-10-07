import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/Services/api_debug_service.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/Services/local_address_service.dart';
import 'package:tawasul_application/Services/user_data_services.dart';
import 'package:tawasul_application/view/Checkout/address_selection.dart';
import 'package:tawasul_application/view/map/map.dart';
import 'package:tawasul_application/view/shopping_cart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension StringExtensions on String {
  bool isNumeric() {
    return double.tryParse(this) != null;
  }
}

class CheckoutController {
  final int customerId;
  List<dynamic> addresses = [];
  dynamic selectedAddress;
  bool isLoading = false;
  String errorMessage = '';
  String errorCode = '';
  bool isUsingStoredData = false;

  CheckoutController(this.customerId);

  Future<bool> loadCustomerData() async {
    try {
      isLoading = true;
      errorMessage = '';
      errorCode = '';
      isUsingStoredData = false;

      print(" Loading customer data from API...");

      final customerResponse = await ApiService.getCustomerDetails();

      if (customerResponse['success'] != true) {
        print(" API failed: ${customerResponse['message']}");
        errorMessage =
            customerResponse['message'] ?? 'Failed to load customer details';
        errorCode = customerResponse['code'] ?? 'UNKNOWN_ERROR';
        isUsingStoredData = true;

        await _loadAddresses();
        return false;
      }

      print(" Customer details loaded from API");

      await _loadAddresses();

      return true;
    } catch (e) {
      errorMessage = 'Failed to load customer data: $e';
      errorCode = 'EXCEPTION';
      print(" Exception in loadCustomerData: $e");
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _loadAddresses() async {
    try {
      print("🔄 Loading addresses from API...");
      final addressesResponse = await ApiService.getCustomerAddresses();

      if (addressesResponse['success'] == true) {
        addresses = addressesResponse['addresses'] ?? [];

        if (addressesResponse['fromLocalStorage'] == true) {
          isUsingStoredData = true;
          print("📍 Using addresses from local storage");
        } else {
          print("📍 Addresses loaded from API: ${addresses.length} found");
        }

        // Auto-select the first address if available
        if (addresses.isNotEmpty) {
          selectedAddress = addresses.first;
          print(
            " Auto-selected address: ${selectedAddress['firstname']} ${selectedAddress['lastname']}",
          );
        } else {
          print("ℹ️ No addresses found");
        }
      } else {
        print("❌ Failed to load addresses: ${addressesResponse['message']}");
        addresses = [];
      }
    } catch (e) {
      print(" Error loading addresses: $e");
      addresses = [];
    }
  }

  Future<bool> createOrUpdateAddress(Map<String, dynamic> addressData) async {
    try {
      isLoading = true;
      errorMessage = '';
      errorCode = '';

      print("🔄 Creating address via API...");

      // Use the API to create address
      final result = await ApiService.createAddress(
        firstname: addressData['firstname'],
        lastname: addressData['lastname'],
        address1: addressData['address1'],
        city: addressData['city'],
        postcode: addressData['postcode'],
        idState: addressData['idState'],
        phone: addressData['phone'],
        address2: addressData['address2'],
      );

      if (result['success'] == true) {
        // Refresh addresses list
        await _loadAddresses();

        // Select the newly created address
        if (result['id_address'] != null) {
          selectedAddress = addresses.firstWhere(
            (addr) => addr['id_address'] == result['id_address'],
            orElse: () => addresses.isNotEmpty ? addresses.first : null,
          );
        }

        print(" Address created successfully");
        return true;
      } else {
        errorMessage = result['message'] ?? 'Failed to create address';
        errorCode = 'API_ERROR';
        return false;
      }
    } catch (e) {
      errorMessage = 'Failed to create address: $e';
      errorCode = 'EXCEPTION';
      return false;
    } finally {
      isLoading = false;
    }
  }

  void selectAddress(dynamic address) {
    selectedAddress = address;
  }

  bool get hasExistingAddresses => addresses.isNotEmpty;
}

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late CheckoutController _checkoutController;
  bool isBillingSame = true;
  String? selectedCity;
  int? selectedStateId;
  Map<String, dynamic>? _selectedLocation;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController additionalAddressController =
      TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController stateDisplayController = TextEditingController();

  bool _isLoading = false;
  bool _userDataLoaded = false;
  bool _statesLoaded = false;
  bool _hasError = false;
  String _errorMessage = '';

  String _customerEmail = "";
  int _customerId = 0;

  bool _isDisposed = false;

  // States data from API
  List<dynamic> _states = [];
  Map<String, int> _stateNameToId = {};
  Map<int, String> _stateIdToName = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _debugAllStoredData();
      _manualTokenCheck();
      _checkTokenStorageOnStartup();
      _initializeController();
    });
  }

  Future<void> _manualTokenCheck() async {
    try {
      print("\n" + "=" * 50);
      print("🛠️ MANUAL TOKEN CHECK");
      print("=" * 50);

      // Test SharedPreferences directly
      final prefs = await SharedPreferences.getInstance();
      final directToken = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');
      final userEmail = prefs.getString('user_email');
      final userFirstName = prefs.getString('user_firstName');
      final userLastName = prefs.getString('user_lastName');

      print("🔧 Direct SharedPreferences Check:");
      print(
        "   - auth_token: ${directToken != null ? 'EXISTS (${directToken.length} chars)' : 'NULL'}",
      );
      print("   - user_id: $userId");
      print("   - user_email: $userEmail");
      print("   - user_firstName: $userFirstName");
      print("   - user_lastName: $userLastName");

      if (directToken != null) {
        print("   - Token length: ${directToken.length}");
        print(
          "   - Token preview: ${directToken.substring(0, min(20, directToken.length))}...",
        );
        print(
          "   - Token ends with: ...${directToken.substring(directToken.length - 10)}",
        );

        // Check token format
        print("   - Contains spaces: ${directToken.contains(' ')}");
        print(
          "   - Contains quotes: ${directToken.contains('"') || directToken.contains("'")}",
        );
      }

      // Test if we can make an API call with the token
      if (directToken != null && directToken.isNotEmpty) {
        print("\n🔐 TESTING API CALL WITH TOKEN:");
        try {
          final response = await http
              .get(
                Uri.parse(
                  'https://tawasul-dev.app-staging.fr/public/getcustomerdetails',
                ),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $directToken',
                  'Accept': 'application/json',
                },
              )
              .timeout(Duration(seconds: 10));

          print("   - Status Code: ${response.statusCode}");
          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);
            print("   -  API CALL SUCCESSFUL");
            print("   - Success: ${responseData['success']}");
            if (responseData['success'] == true) {
              print("   - Customer data received!");
            } else {
              print("   - API returned success: false");
              print("   - Message: ${responseData['message']}");
            }
          } else {
            print("   - API CALL FAILED: ${response.statusCode}");
            print("   - Response: ${response.body}");
          }
        } catch (e) {
          print("   -  API CALL ERROR: $e");
        }
      } else {
        print("\n❌ NO TOKEN AVAILABLE FOR API TEST");
      }

      print("=" * 50 + "\n");
    } catch (e) {
      print(" Manual token check error: $e");
    }
  }

  Future<void> _debugAllStoredData() async {
    try {
      print("\n" + "=" * 50);
      print("📋 ALL STORED DATA IN SHAREDPREFERENCES");
      print("=" * 50);

      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys().toList()..sort();

      print("Total keys stored: ${allKeys.length}");

      for (var key in allKeys) {
        final value = prefs.get(key);
        if (value is String && value.length > 50) {
          print(
            "   - $key: ${value.substring(0, 50)}... (${value.length} chars)",
          );
        } else {
          print("   - $key: $value");
        }
      }

      print("=" * 50 + "\n");
    } catch (e) {
      print(" Debug stored data error: $e");
    }
  }

  Future<void> _checkTokenStorageOnStartup() async {
    try {
      print("\n" + "=" * 50);
      print("🔍 CHECKOUT STARTUP - TOKEN CHECK");
      print("=" * 50);

      final prefs = await SharedPreferences.getInstance();

      // Check token storage
      final token = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');

      print(" STARTUP STATUS:");
      print(
        "   - Token: ${token != null ? 'EXISTS (${token.length} chars)' : 'NULL'}",
      );
      print("   - User ID: $userId");

      if (token == null) {
        print(" CRITICAL: No auth token found at startup!");
        print(" User needs to login again");

        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = 'Please login again to continue';
          });
        }
      } else {
        print(" Token found, user is logged in");
      }

      print("=" * 50 + "\n");
    } catch (e) {
      print(" Startup token check error: $e");
    }
  }

  Future<void> _testApiStepByStep() async {
    try {
      print("\n" + "=" * 50);
      print("STEP-BY-STEP API TEST");
      print("=" * 50);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');
      print("1. 📋 SHARED PREFERENCES CHECK:");
      print(
        "   - Token: ${token != null ? 'EXISTS (${token.length} chars)' : 'NULL'}",
      );
      print("   - User ID: $userId");

      if (token == null) {
        print("❌ STOPPING TEST: No token found");
        return;
      }

      print("\n2. 🌐 DIRECT HTTP TEST:");
      try {
        final response = await http
            .get(
              Uri.parse(
                'https://tawasul-dev.app-staging.fr/public/getcustomerdetails',
              ),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(Duration(seconds: 10));

        print("   - Status: ${response.statusCode}");
        print("   - Body length: ${response.body.length}");

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print("   - Success: ${data['success']}");
          if (data['success'] == true) {
            print("🎉 DIRECT CALL SUCCESS!");
          } else {
            print("❌ Direct call failed: ${data['message']}");
          }
        } else {
          print("❌ HTTP Error: ${response.statusCode}");
          print("   - Response: ${response.body}");
        }
      } catch (e) {
        print("❌ Direct call error: $e");
      }

      print("\n3. 🔧 APISERVICE METHOD TEST:");
      final result = await ApiService.getCustomerDetails();
      print("   - Success: ${result['success']}");
      print("   - Message: ${result['message']}");
      print("   - Code: ${result['code']}");

      print("=" * 50 + "\n");
    } catch (e) {
      print(" Step-by-step test error: $e");
    }
  }

  Future<void> _traceLoginTokenFlow() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      print("\n" + "=" * 50);
      print("🔍 TRACING LOGIN TOKEN FLOW");
      print("=" * 50);

      // Check if we have login data
      final token = prefs.getString('auth_token');
      final loginTime = prefs.getString(
        'login_time',
      ); // You might want to add this

      print("📋 LOGIN STATUS:");
      print("  - Token exists: ${token != null}");
      print("  - Token length: ${token?.length ?? 0}");

      if (token == null) {
        print("❌ USER IS NOT LOGGED IN - No token found");
        print(
          "💡 Solution: User needs to login first before accessing checkout",
        );
      } else {
        print(" User appears to be logged in");
        print("💡 Token: ${token.substring(0, min(30, token.length))}...");
      }

      print("=" * 50 + "\n");
    } catch (e) {
      print(" Token flow trace error: $e");
    }
  }

  Future<void> _debugCustomerDetailsAPI() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');

      print("=== CUSTOMER DETAILS API DEBUG ===");
      print("User ID: $userId");
      print("Token exists: ${token != null}");
      print("Token length: ${token?.length ?? 0}");

      if (token != null) {
        print("Token preview: ${token.substring(0, min(30, token.length))}...");
      }

      // Test the API directly
      final response = await http.get(
        Uri.parse(
          'https://tawasul-dev.app-staging.fr/public/getcustomerdetails',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Direct API Test:");
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");
      print("===================================");
    } catch (e) {
      print("Debug API error: $e");
    }
  }

  Future<void> _debugTokenAndCustomerAPI() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      print("\n" + "=" * 50);
      print(" COMPREHENSIVE TOKEN & CUSTOMER API DEBUG");
      print("=" * 50);

      final token = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');
      final userEmail = prefs.getString('user_email');
      final userFirstName = prefs.getString('user_firstName');
      final userLastName = prefs.getString('user_lastName');

      print(" STORED AUTH DATA:");
      print("  - User ID: $userId");
      print("  - User Email: $userEmail");
      print("  - First Name: $userFirstName");
      print("  - Last Name: $userLastName");
      print("  - Token exists: ${token != null}");
      print("  - Token length: ${token?.length ?? 0}");

      if (token != null) {
        print(
          "  - Token preview: ${token.substring(0, min(30, token.length))}...",
        );
        print("  - Token ends with: ...${token.substring(token.length - 10)}");
      }

      // 2. Test if token is valid by making API call
      if (token != null && token.isNotEmpty) {
        print("\n🔐 TESTING API WITH TOKEN...");

        try {
          final response = await http
              .get(
                Uri.parse(
                  'https://tawasul-dev.app-staging.fr/public/getcustomerdetails',
                ),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                  'Accept': 'application/json',
                },
              )
              .timeout(Duration(seconds: 10));

          print("📡 API RESPONSE:");
          print("  - Status Code: ${response.statusCode}");
          print("  - Response Headers: ${response.headers}");

          if (response.statusCode == 200) {
            try {
              final responseData = json.decode(response.body);
              print("  - Success: ${responseData['success']}");
              print("  - Message: ${responseData['message']}");

              if (responseData['success'] == true &&
                  responseData['customer'] != null) {
                final customer = responseData['customer'];
                print("🎉 CUSTOMER DATA RECEIVED:");
                print("  - ID: ${customer['id']}");
                print(
                  "  - Name: ${customer['firstname']} ${customer['lastname']}",
                );
                print("  - Email: ${customer['email']}");
              } else {
                print("❌ API returned success: false");
                print("  - Full response: $responseData");
              }
            } catch (e) {
              print("❌ JSON Parse Error: $e");
              print("  - Raw response: ${response.body}");
            }
          } else if (response.statusCode == 401) {
            print("❌ AUTHENTICATION FAILED - 401 Unauthorized");
            print("  - The token is invalid or expired");
          } else {
            print("❌ SERVER ERROR: ${response.statusCode}");
            print("  - Response: ${response.body}");
          }
        } catch (e) {
          print("❌ NETWORK ERROR: $e");
        }
      } else {
        print("\n❌ NO TOKEN FOUND - User might not be logged in properly");
      }

      // 3. Test the ApiService.getCustomerDetails method directly
      print("\n🔧 TESTING ApiService.getCustomerDetails()...");
      try {
        final customerResult = await ApiService.getCustomerDetails();
        print("  - Success: ${customerResult['success']}");
        print("  - Message: ${customerResult['message']}");
        print("  - Code: ${customerResult['code']}");

        if (customerResult['success'] == true) {
          print("🎉 ApiService SUCCESS:");
          print("  - First Name: ${customerResult['firstName']}");
          print("  - Last Name: ${customerResult['lastName']}");
          print("  - Email: ${customerResult['email']}");
        }
      } catch (e) {
        print("❌ ApiService Error: $e");
      }

      print("=" * 50 + "\n");
    } catch (e) {
      print(" DEBUG METHOD ERROR: $e");
    }
  }

  Future<void> _verifyLoginTokenStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      print("\n" + "=" * 50);
      print("🔐 VERIFYING LOGIN TOKEN STORAGE");
      print("=" * 50);

      // Get ALL keys from shared preferences to see what's actually stored
      final allKeys = prefs.getKeys();
      print("📋 ALL STORED KEYS:");
      allKeys.forEach((key) {
        if (key.contains('auth') ||
            key.contains('token') ||
            key.contains('user')) {
          final value = prefs.get(key);
          print("  - $key: $value");
        }
      });

      // Specifically check auth_token
      final authToken = prefs.getString('auth_token');
      print("\n🎯 SPECIFIC AUTH TOKEN CHECK:");
      print("  - auth_token key exists: ${prefs.containsKey('auth_token')}");
      print(
        "  - auth_token value: ${authToken != null ? 'EXISTS (${authToken.length} chars)' : 'NULL'}",
      );

      if (authToken != null) {
        print(
          "  - Token starts with: ${authToken.substring(0, min(20, authToken.length))}...",
        );
      }

      print("=" * 50 + "\n");
    } catch (e) {
      print(" Token storage verification error: $e");
    }
  }

  Future<void> _initializeController() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('user_id') ?? 0;
      final token = prefs.getString('auth_token');

      print("Initializing checkout with customer ID: $customerId");
      print("Auth token available: ${token != null && token.isNotEmpty}");

      if (customerId == 0 || token == null) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Please login first';
          _userDataLoaded = true;
          _statesLoaded = true;
        });
        return;
      }
      await _ensureUserDataIsStored(); // ADD THIS

      // Test all authentication methods to find which one works
      print("🔄 Testing authentication methods...");
      await ApiDebugService.testAllAuthMethods();

      // For now, proceed with the app using stored data as fallback
      print("🔄 Proceeding with fallback approach...");
      _checkoutController = CheckoutController(customerId);
      await _loadInitialData();
    } catch (e) {
      print("Error initializing controller: $e");
      setState(() {
        _hasError = true;
        _errorMessage = 'Initialization failed: $e';
        _userDataLoaded = true;
        _statesLoaded = true;
      });
    }
  }

  Future<void> _loadInitialData() async {
    try {
      await Future.wait([_loadStates(), _loadCustomerData()]);
    } catch (e) {
      print("Error loading initial data: $e");
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load data: $e';
      });
    }
  }

  Future<void> _loadCustomerData() async {
    try {
      await _loadCustomerIdAndEmail();

      print("🔄 Loading customer data...");

      // Try to load fresh data from API
      final success = await _checkoutController.loadCustomerData();

      if (!mounted) return;

      if (success) {
        // Successfully loaded from API
        print(" Customer data loaded from API successfully");
        _populateFormFromExistingData();
      } else {
        // API failed, use stored data with warning
        print(
          "⚠️ API failed, using stored data: ${_checkoutController.errorMessage}",
        );

        if (mounted) {
          setState(() {
            _hasError = false; // Don't block the UI
            _userDataLoaded = true;
          });
        }
        _populateFormWithStoredData();
      }
    } catch (e) {
      print(" Error loading customer data: $e");
      if (mounted) {
        setState(() {
          _hasError = false;
          _userDataLoaded = true;
        });
      }
      _populateFormWithStoredData();
    }
  }

  void _populateFormWithStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        firstNameController.text = prefs.getString('user_firstName') ?? '';
        lastNameController.text = prefs.getString('user_lastName') ?? '';
        phoneController.text = prefs.getString('user_phone') ?? '';
        _customerEmail = prefs.getString('user_email') ?? '';
      });

      print("📋 Using stored customer data");
    } catch (e) {
      print("Error loading stored data: $e");
      _populateFormWithDefaults();
    }
  }

  void _populateFormWithDefaults() {
    if (mounted) {
      setState(() {
        if (firstNameController.text.isEmpty) {
          firstNameController.text = 'Customer';
        }
        if (lastNameController.text.isEmpty) {
          lastNameController.text = 'User';
        }
      });
    }
  }

  Future<void> _testTokenManually() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print(" No token found");
      return;
    }

    print(" Testing token manually...");
    print("Token: $token");

    try {
      final response = await http.get(
        Uri.parse(
          'https://tawasul-dev.app-staging.fr/public/getcustomerdetails',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(" Manual test response:");
      print("Status Code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("Body: ${response.body}");

      if (response.statusCode == 401) {
        print(" Token is rejected by server");
      }
    } catch (e) {
      print(" Manual test error: $e");
    }
  }

  void _populateFormFromExistingData() {
    try {
      // First, try to populate from selected address
      if (_checkoutController.selectedAddress != null) {
        final address = _checkoutController.selectedAddress;

        setState(() {
          firstNameController.text = address['firstname'] ?? '';
          lastNameController.text = address['lastname'] ?? '';
          phoneController.text =
              address['phone'] ?? address['phone_mobile'] ?? '';
          addressController.text = address['address1'] ?? '';
          cityController.text = address['city'] ?? '';
          zipCodeController.text = address['postcode'] ?? '';
          selectedStateId = address['id_state'];
          selectedCity = address['city'];

          if (_stateIdToName.containsKey(address['id_state'])) {
            stateDisplayController.text = _stateIdToName[address['id_state']]!;
          }

          _userDataLoaded = true;
        });
      } else {
        _loadBasicCustomerInfo();
      }
    } catch (e) {
      print("Error populating form from address: $e");
      _loadBasicCustomerInfo();
    }
  }

  Future<void> _loadBasicCustomerInfo() async {
    try {
      final customerData = await ApiService.getCustomerDetails();
      if (customerData['success'] == true && mounted) {
        setState(() {
          firstNameController.text = customerData['firstName'] ?? '';
          lastNameController.text = customerData['lastName'] ?? '';
          phoneController.text =
              customerData['mobile'] ?? customerData['phone'] ?? '';
          _customerEmail = customerData['email'] ?? _customerEmail;
          _userDataLoaded = true;
        });

        // Store user data for future use
        await UserDataService.storeUserData(
          firstName: customerData['firstName'] ?? '',
          lastName: customerData['LastName'] ?? '',
          phone: customerData['mobile'] ?? customerData['phone'] ?? '',
          email: customerData['email'] ?? _customerEmail,
        );
      } else {
        setState(() {
          _userDataLoaded = true;
        });
      }
    } catch (e) {
      print("Error loading basic customer info: $e");
      setState(() {
        _userDataLoaded = true;
      });
    }
  }

  Future<void> _loadStates() async {
    try {
      print("Loading states from API...");
      final response = await ApiService.getStates();

      if (response['success'] == true && response['states'] != null) {
        setState(() {
          _states = response['states'];
          _stateNameToId = {};
          _stateIdToName = {};

          for (var state in _states) {
            final stateName = state.name;
            final stateId = state.idState;
            if (stateName.isNotEmpty) {
              _stateNameToId[stateName] = stateId;
              _stateIdToName[stateId] = stateName;
            }
          }

          _statesLoaded = true;
        });
        print("${_states.length} states loaded successfully");
      } else {
        print("Failed to load states: ${response['message']}");
        setState(() {
          _statesLoaded = true;
          _hasError = true;
          _errorMessage = response['message'] ?? 'Failed to load states';
        });
      }
    } catch (e) {
      print("Error loading states: $e");
      setState(() {
        _statesLoaded = true;
        _hasError = true;
        _errorMessage = 'Failed to load states: $e';
      });
    }
  }

  Future<void> _loadCustomerIdAndEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      String? userEmail = prefs.getString('user_email');

      setState(() {
        _customerId = userId ?? 0;
        _customerEmail = userEmail ?? "";
      });

      print("Customer ID and email loaded: $_customerId, $_customerEmail");
    } catch (e) {
      print('Error loading customer ID and email: $e');
      setState(() {
        _customerId = 0;
        _customerEmail = "";
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    additionalAddressController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    stateDisplayController.dispose();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }

  void _updateAddressFromLocation(Map<String, dynamic> location) {
    setState(() {
      _selectedLocation = location;
      final String displayAddress = _getDisplayAddress(location);
      _selectedLocation = {...location, 'displayAddress': displayAddress};

      String? cityFromLocation = location['city'];
      String? zipCodeFromLocation = location['zipCode'];

      if (cityFromLocation != null && cityFromLocation.isNotEmpty) {
        selectedCity = cityFromLocation;
        cityController.text = cityFromLocation;
      }

      String finalZipCode = '';
      if (zipCodeFromLocation != null && zipCodeFromLocation.isNotEmpty) {
        finalZipCode = zipCodeFromLocation;
        zipCodeController.text = finalZipCode;
      }

      addressController.text = displayAddress;
    });
  }

  void _updateStateDisplay() {
    if (selectedStateId != null &&
        _stateIdToName.containsKey(selectedStateId)) {
      final selectedStateName = _stateIdToName[selectedStateId]!;
      stateDisplayController.text = selectedStateName;
    }
  }

  String _getDisplayAddress(Map<String, dynamic> location) {
    final t = AppLocalizations.of(context)!;

    final String? fullAddress = location['address'];
    final String? city = location['city'];
    if (fullAddress == null) return t.selectedLocation;
    if (city == null) return fullAddress;

    if (fullAddress.contains(city)) {
      final parts = fullAddress.split(',');
      for (int i = 0; i < parts.length; i++) {
        final part = parts[i].trim();
        if (part.contains(city) && i > 0) {
          return '${parts[i - 1].trim()}, $city';
        }
      }
    }

    return city;
  }

  Widget _buildLocationPicker() {
    final t = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          _selectedLocation?['displayAddress'] ?? t.chooseYourLocation,
          style: TextStyle(
            color: _selectedLocation != null ? Colors.black : Colors.black54,
          ),
        ),
        trailing: const Icon(Icons.my_location),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InternationalMapScreen(),
            ),
          );

          if (result != null && mounted) {
            _updateAddressFromLocation(result);
          }
        },
      ),
    );
  }

  Widget _buildAddressSelection() {
    final t = AppLocalizations.of(context)!;

    if (_checkoutController.addresses.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.selectExistingAddress,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 10),
        ..._checkoutController.addresses
            .map(
              (address) => Card(
                child: ListTile(
                  title: Text(_getAddressDisplayText(address)),
                  subtitle: Text(
                    '${address['firstname']} ${address['lastname']}',
                  ),
                  trailing: Radio<dynamic>(
                    value: address,
                    groupValue: _checkoutController.selectedAddress,
                    onChanged: (dynamic value) {
                      if (value != null) {
                        setState(() {
                          _checkoutController.selectAddress(value);
                          _populateFormFromExistingData();
                        });
                      }
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _checkoutController.selectAddress(address);
                      _populateFormFromExistingData();
                    });
                  },
                ),
              ),
            )
            .toList(),
        SizedBox(height: 20),
        Divider(),
        SizedBox(height: 10),
        Text(
          t.orAddNewAddress,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  String _getAddressDisplayText(Map<String, dynamic> address) {
    return '${address['address1'] ?? ''}, ${address['city'] ?? ''}, ${address['state'] ?? ''} ${address['postcode'] ?? ''}';
  }

  Widget _buildErrorWidget() {
    final t = AppLocalizations.of(context)!;

    // Check if it's an authentication error
    final isAuthError =
        _errorMessage.toLowerCase().contains('login') ||
        _errorMessage.toLowerCase().contains('authentication') ||
        _errorMessage.toLowerCase().contains('token');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAuthError ? Icons.login : Icons.error_outline,
              size: 64,
              color: isAuthError ? Colors.orange : Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: isAuthError ? Colors.orange : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (isAuthError)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _navigateToLogin,
                    child: Text(t.loginAgain),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ElevatedButton(onPressed: _retryLoading, child: Text(t.retry)),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ShoppingCart()),
                );
              },
              child: Text(t.backToCart),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLogin() async {
    // Clear all stored auth data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_firstName');
    await prefs.remove('user_lastName');
    await prefs.remove('user_phone');

    // Navigate to login screen - replace with your actual login route
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _retryLoading() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _userDataLoaded = false;
      _statesLoaded = false;
      _isLoading = false;
    });
    _initializeController();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(
            left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
            right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCart()),
              );
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                color: Color(0xFF008AD2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(t.checkout, style: TextStyle(color: Colors.black)),
      ),
      body:
          _hasError
              ? _buildErrorWidget()
              : _userDataLoaded && _statesLoaded
              ? _buildContent()
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(t.loading),
                  ],
                ),
              ),
    );
  }

  Widget _buildContent() {
    final t = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_checkoutController.isUsingStoredData)
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Using stored information. Some data may not be up to date.",
                      style: TextStyle(color: Colors.orange[800]),
                    ),
                  ),
                ],
              ),
            ),
          if (_checkoutController.hasExistingAddresses)
            _buildAddressSelection(),
          Text(t.addYourDetails, style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(t.deliveryAddress),
          const SizedBox(height: 10),
          _buildTextField(t.firstName, controller: firstNameController),
          _buildTextField(t.lastName, controller: lastNameController),
          _buildTextField(
            t.phoneNumber,
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          Text(t.setYourLocalization),
          const SizedBox(height: 10),
          _buildLocationPicker(),
          const SizedBox(height: 20),
          Text(t.orSetAllYourInformationBelow),
          const SizedBox(height: 10),
          _buildTextField(t.address, controller: addressController),
          _buildTextField(
            t.additionalAddress,
            controller: additionalAddressController,
            hint: t.optional,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildTextField(t.city, controller: cityController),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _buildTextField(
                  t.zipCode,
                  controller: zipCodeController,
                  hint: t.zipCode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildStateDropdown(),
          const SizedBox(height: 20),
          _buildBillingCheckbox(),
          const SizedBox(height: 30),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildValidateButton(),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    String? hint,
    TextInputType? keyboardType,
    bool readOnly = false,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint ?? label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildStateDropdown() {
    final t = AppLocalizations.of(context)!;

    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        isDense: true,
        hintText: t.state,
      ),
      value: selectedStateId,
      onChanged: (int? value) {
        setState(() {
          selectedStateId = value;
          if (value != null) {
            _updateStateDisplay();
          }
        });
      },
      items:
          _states.map<DropdownMenuItem<int>>((state) {
            final stateId = state.idState;
            final stateName = state.name;
            return DropdownMenuItem<int>(
              value: stateId,
              child: Text(stateName),
            );
          }).toList(),
    );
  }

  Widget _buildBillingCheckbox() {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isBillingSame,
            onChanged: (val) {
              setState(() {
                isBillingSame = val ?? true;
              });
            },
            activeColor: Colors.orange,
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${t.myBillingAddress}\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: t.isTheSameAsMyDeliveryAddress),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidateButton() {
    final t = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF008AD2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _isLoading ? null : _validateAndContinue,
        child:
            _isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
                  t.validateAndContinue,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
      ),
    );
  }

  Future<void> _validateAndContinue() async {
    final t = AppLocalizations.of(context)!;
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // Get customer ID
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('user_id') ?? _customerId;
      final token = prefs.getString('auth_token');

      print("🔐 AUTH STATUS:");
      print("   - Customer ID: $customerId");
      print("   - Token exists: ${token != null}");

      if (customerId == 0 || token == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(t.pleaseLoginFirst)));
        }
        setState(() => _isLoading = false);
        return;
      }

      // Enhanced validation
      final validationErrors = _validateForm();
      if (validationErrors.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(validationErrors.join('\n'))));
        }
        setState(() => _isLoading = false);
        return;
      }

      // Extract form data
      final String firstname = firstNameController.text.trim();
      final String lastname = lastNameController.text.trim();
      final String address1 = _getPrimaryAddress();
      final String address2 = additionalAddressController.text.trim();
      final String city = cityController.text.trim();
      final String postcode = zipCodeController.text.trim();
      final int idState = selectedStateId!;
      final String phone = phoneController.text.trim();

      print("📝 ADDRESS DATA:");
      print("   - Name: $firstname $lastname");
      print("   - Address: $address1");
      print("   - City: $city");
      print("   - State ID: $idState");
      print("   - Zip: $postcode");
      print("   - Phone: ${phone.isNotEmpty ? phone : 'Not provided'}");

      // Create address via API
      print("🔄 CREATING ADDRESS VIA API...");
      final apiResult = await ApiService.createAddress(
        firstname: firstname,
        lastname: lastname,
        address1: address1,
        address2: address2.isNotEmpty ? address2 : null,
        city: city,
        postcode: postcode,
        idState: idState,
        phone: phone.isNotEmpty ? phone : null,
      );

      print("📨 API RESULT:");
      print("   - Success: ${apiResult['success']}");
      print("   - Message: ${apiResult['message']}");
      print("   - From Local: ${apiResult['fromLocalStorage'] ?? false}");

      int? newAddressId;
      bool isLocal = false;

      if (apiResult['success'] == true) {
        newAddressId = apiResult['id_address'] as int?;
        isLocal = apiResult['fromLocalStorage'] == true;

        if (isLocal) {
          print("⚠️ Using locally saved address: $newAddressId");
        } else {
          print("✅ API address created: $newAddressId");
        }
      } else {
        // Show specific error message
        final errorMsg = apiResult['message'] ?? 'Failed to create address';
        print("❌ ADDRESS CREATION FAILED: $errorMsg");

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMsg)));
        }
        setState(() => _isLoading = false);
        return;
      }

      // Prepare navigation data
      final checkoutData = <String, dynamic>{
        'firstName': firstname,
        'lastName': lastname,
        'phone': phone,
        'address': address1,
        'additionalAddress': address2,
        'city': city,
        'stateId': idState,
        'stateName': _stateIdToName[idState] ?? 'Unknown State',
        'zipCode': postcode,
        'location': _selectedLocation,
        'isBillingSame': isBillingSame,
        'addressId': newAddressId,
        'usingStoredData': isLocal,
        'isLocalAddress': isLocal,
        'customerId': customerId,
      };

      print("🚀 NAVIGATING TO ADDRESS SELECTION...");
      print("   - Address ID: $newAddressId");
      print("   - Is Local: $isLocal");

      if (!mounted) return;

      // Navigate to address selection
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => AddressSelection(
                selectedAddressId: newAddressId,
                checkoutData: checkoutData,
              ),
        ),
      );

      print("✅ NAVIGATION COMPLETED");
    } catch (e) {
      print("💥 VALIDATE AND CONTINUE ERROR: $e");
      print("🔄 Stack trace: ${e.toString()}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${t.anErrorOccurred}: ${e.toString()}"),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      print("🏁 VALIDATE AND CONTINUE COMPLETED");
    }
  }

  // Add this helper method for validation
  List<String> _validateForm() {
    final t = AppLocalizations.of(context)!;
    final errors = <String>[];

    if (firstNameController.text.isEmpty) errors.add(t.firstNameRequired);
    if (lastNameController.text.isEmpty) errors.add(t.lastNameRequired);
    if (addressController.text.isEmpty && _selectedLocation == null) {
      errors.add(t.addressRequired);
    }
    if (cityController.text.isEmpty) errors.add(t.cityRequired);
    if (selectedStateId == null) errors.add(t.stateRequired);
    if (zipCodeController.text.isEmpty) errors.add(t.zipCodeRequired);

    if (phoneController.text.isNotEmpty && !phoneController.text.isNumeric()) {
      errors.add(t.pleaseEnterValidPhoneNumber);
    }

    return errors;
  }

  Future<bool> _saveOrUpdateAddress() async {
    final addressData = {
      'id':
          _checkoutController.selectedAddress?['id_address'] ??
          _checkoutController.selectedAddress?['id'],
      'firstname': firstNameController.text.trim(),
      'lastname': lastNameController.text.trim(),
      'address1': _getPrimaryAddress(),
      'city': cityController.text.trim(),
      'postcode': zipCodeController.text.trim(),
      'idState': selectedStateId!,
      'phone':
          phoneController.text.trim().isNotEmpty
              ? phoneController.text.trim()
              : null,
      'address2':
          additionalAddressController.text.trim().isNotEmpty
              ? additionalAddressController.text.trim()
              : null,
      'alias': 'Home Address',
    };

    // First try API
    final apiResult = await _checkoutController.createOrUpdateAddress(
      addressData,
    );

    if (apiResult) {
      return true;
    }

    // If API fails, save locally
    if (_checkoutController.errorMessage.contains('Authentication') ||
        _checkoutController.errorMessage.contains('Token')) {
      print('🔄 API authentication failed, saving address locally...');
      final localResult = await LocalAddressService.saveLocalAddress(
        addressData,
      );

      if (localResult['success'] == true) {
        // Update the controller with the local address
        _checkoutController.selectedAddress = localResult['address'];
        _checkoutController.addresses.add(localResult['address']);

        print(' Address saved locally');
        return true;
      } else {
        _checkoutController.errorMessage = localResult['message'];
        return false;
      }
    }

    return false;
  }

  String _getPrimaryAddress() {
    if (_selectedLocation != null && _selectedLocation!['address'] != null) {
      return _selectedLocation!['address']!;
    } else if (addressController.text.isNotEmpty) {
      return addressController.text;
    } else {
      return 'Unknown Address';
    }
  }

  Future<void> _debugAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    print("=== AUTH DEBUG INFO ===");
    print("User ID: $userId");
    print("Token exists: ${token != null}");
    print("Token length: ${token?.length ?? 0}");
    print(
      "Token preview: ${token != null ? '${token.substring(0, min(20, token.length))}...' : 'null'}",
    );
    print("======================");
  }

  Future<void> _debugStoredData() async {
    final prefs = await SharedPreferences.getInstance();

    print("=== STORED DATA DEBUG ===");
    print("user_id: ${prefs.getInt('user_id')}");
    print("user_email: ${prefs.getString('user_email')}");
    print("user_firstName: ${prefs.getString('user_firstName')}");
    print("user_lastName: ${prefs.getString('user_lastName')}");
    print("user_phone: ${prefs.getString('user_phone')}");
    print(
      "auth_token: ${prefs.getString('auth_token') != null ? 'exists' : 'null'}",
    );
    print("=========================");
  }

  Future<void> _ensureUserDataIsStored() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      final email = prefs.getString('user_email');

      if (userId != null && userId > 0) {
        // Check if basic user data exists
        final firstName = prefs.getString('user_firstName');
        final lastName = prefs.getString('user_lastName');

        if (firstName == null || lastName == null) {
          print("🔄 Basic user data missing, storing default values...");

          // Store default values based on available data
          await UserDataService.storeUserData(
            firstName: firstName ?? 'Customer',
            lastName: lastName ?? 'User',
            phone: prefs.getString('user_phone') ?? '',
            email: email ?? '',
          );

          print(" Default user data stored");
        }
      }
    } catch (e) {
      print(" Error ensuring user data storage: $e");
    }
  }
}
