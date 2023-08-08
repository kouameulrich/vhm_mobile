// // ignore_for_file: file_names, avoid_print
// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:vhm_mobile/_api/tokenStorageService.dart';
// import 'package:vhm_mobile/models/dto/user.dart';

// class AuthService {
//   final TokenStorageService _tokenStorageService;
//   Dio dio = Dio();

//   AuthService(this._tokenStorageService);

//   Future<int?> authenticateUser(
//       String usernameController, String passwordController) async {
//     String url = 'https://www.digitale-it.com/unicef/api/auth/signin';
//     var response = await http.post(Uri.parse(url),
//         headers: {"Content-type": "application/json"},
//         body: jsonEncode({
//           "username": usernameController,
//           "password": passwordController,
//         }));
//     if (response.statusCode == 200) {
//       var jsonResponse = json.decode(response.body);
//       User apiResponse = User.fromJson(jsonResponse);
//       _tokenStorageService.saveAgentConnected(apiResponse);
//       print('Test--2---${apiResponse.accessToken}');
//       return response.statusCode;
//     } else {
//       debugPrint(
//           "An Error Occurred during loggin in. Status code: ${response.statusCode} , body: ${response.body}");
//       return response.statusCode;
//     }
//   }
// }
