// import 'dart:io';
// import 'dart:convert';
//
// class FileCache {
//   // The directory where the cache files are stored
//   final Directory cacheDir;
//
//   // The constructor that takes the cache directory as a parameter
//   FileCache(this.cacheDir);
//
//   // A function to save data with an expiration date to a file
//   Future<void> saveData(String key, dynamic data, Duration expiration) async {
//     // Encode the data to JSON format
//     String jsonData = jsonEncode(data);
//
//     // Create a file with the key as the name
//     File file = File('${cacheDir.path}/$key');
//
//     // Write the data and the expiration date to the file
//     await file.writeAsString('$jsonData\n${DateTime.now().add(expiration).toIso8601String()}');
//   }
//
//   // A function to load data from a file if it is not expired
//   Future<dynamic> loadData(String key) async {
//     // Get the file with the key as the name
//     File file = File('${cacheDir.path}/$key');
//
//     // Check if the file exists
//     if (await file.exists()) {
//       // Read the file content as a list of lines
//       List<String> lines = await file.readAsLines();
//
//       // Parse the data and the expiration date from the lines
//       dynamic data = jsonDecode(lines[0]);
//       DateTime expiration = DateTime.parse(lines[1]);
//
//       // Check if the data is expired
//       if (DateTime.now().isBefore(expiration)) {
//         // Return the data
//         return data;
//       } else {
//         // Delete the file
//         await file.delete();
//
//         // Return null
//         return null;
//       }
//     } else {
//       // Return null
//       return null;
//     }
//   }
// }
