// // In your logout function (wherever it is in your app):
// Future<void> logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('auth_token');
//   await UserDataService.clearUserData(); // Add this line
// }