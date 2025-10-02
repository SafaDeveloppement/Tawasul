// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/model/address_model.dart';

// class CheckoutController {
//   final int customerId;
//   List<AddressModel> addresses = [];
//   AddressModel? selectedAddress;
//   bool isLoading = false;
//   String errorMessage = '';
//   bool isUsingStoredData = false;

//   CheckoutController(this.customerId);

//   Future<bool> loadCustomerData() async {
//     try {
//       isLoading = true;
//       errorMessage = '';
//       bool isUsingStoredData = false;

//       // Load customer details
//       final customerResponse = await ApiService.getCustomerDetails();
//       if (!customerResponse['success']) {
//         errorMessage =
//             customerResponse['message'] ?? 'Failed to load customer details';
//         return false;
//       }
//       isUsingStoredData = customerResponse['fromStorage'] == true;
//       if (isUsingStoredData) {
//         print("ℹ️ Using stored customer data");
//       }

//       // Load customer addresses
//       final addressesResponse = await ApiService.getCustomerAddresses();
//       if (addressesResponse['success']) {
//         addresses = addressesResponse['addresses'] ?? [];

//         // Auto-select the first address if available
//         if (addresses.isNotEmpty) {
//           selectedAddress = addresses.first;
//         }
//       }

//       return true;
//     } catch (e) {
//       errorMessage = 'Failed to load customer data: $e';
//       return false;
//     } finally {
//       isLoading = false;
//     }
//   }

//   Future<bool> createOrUpdateAddress(AddressModel address) async {
//     try {
//       isLoading = true;
//       errorMessage = '';

//       Map<String, dynamic> response;

//       if (address.id != null) {
//         // Update existing address
//         response = await ApiService.updateAddress(
//           idAddress: address.id!,
//           firstname: address.firstname,
//           lastname: address.lastname,
//           address1: address.address1,
//           city: address.city,
//           postcode: address.postcode,
//           idState: address.idState,
//           phone: address.phone,
//           address2: address.address2,
//         );
//       } else {
//         // Create new address
//         response = await ApiService.createAddress(
//           firstname: address.firstname,
//           lastname: address.lastname,
//           address1: address.address1,
//           city: address.city,
//           postcode: address.postcode,
//           idState: address.idState,
//           phone: address.phone,
//           address2: address.address2,
//         );
//       }

//       if (response['success']) {
//         // Reload addresses to get the updated list
//         await loadCustomerData();
//         return true;
//       } else {
//         errorMessage = response['message'] ?? 'Failed to save address';
//         return false;
//       }
//     } catch (e) {
//       errorMessage = 'Failed to save address: $e';
//       return false;
//     } finally {
//       isLoading = false;
//     }
//   }

//   void selectAddress(AddressModel address) {
//     selectedAddress = address;
//   }

//   bool get hasExistingAddresses => addresses.isNotEmpty;
// }
