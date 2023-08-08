import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vhm_mobile/models/dto/user.dart';

class TokenStorageService {
  // Create storage
  final FlutterSecureStorage _storage;
  static const String ID_KEY = "ID";
  static const String TOKEN_KEY = "TOKEN";
  static const String USERNAME_KEY = "USERNAME";
  static const String EMAIL_KEY = "EMAIL";
  static const String TELEPHONE_KEY = "TELEPHONE";
  static const String FIRSTNAME_KEY = "FIRSTNAME";
  static const String LASTNAME_KEY = "LASTNAME";
  static const String ROLES_KEY = "ROLES";
  static const String ACCESSTOKEN_KEY = "ACCESSTOKEN";
  static const String ORGANISATION_KEY = "ORGANISATION";

  TokenStorageService(this._storage);

  void saveToken(String token) async {
    await _storage.write(key: TOKEN_KEY, value: token);
  }

  void saveAgentConnected(User user) async {
    await _storage.write(key: ID_KEY, value: user.id);
    await _storage.write(key: USERNAME_KEY, value: user.username);
    await _storage.write(key: EMAIL_KEY, value: user.email);
    await _storage.write(key: TELEPHONE_KEY, value: user.telephone);
    await _storage.write(key: FIRSTNAME_KEY, value: user.firstname);
    await _storage.write(key: LASTNAME_KEY, value: user.lastname);
    await _storage.write(key: ACCESSTOKEN_KEY, value: user.accessToken);
    await _storage.write(key: ORGANISATION_KEY, value: user.organisation);
    await _storage.write(
        key: ROLES_KEY, value: user.roles.elementAt(0).toString());
    //      Agent agentConnected = Agent(
    //     username: agent.username,
    //     email: agent.email,
    //     telephone: agent.telephone,
    //     firstname: agent.firstname,
    //     lastname: agent.lastname,
    //     accessToken: agent.accessToken,
    //     organisation_id: agent.organisation_id,
    //     roles: List.unmodifiable([agent.roles]));

    // return agentConnected;
  }

  Future<User> retrieveAgentConnected() async {
    String? id = await _storage.read(key: ID_KEY);
    String? username = await _storage.read(key: USERNAME_KEY);
    String? email = await _storage.read(key: EMAIL_KEY);
    String? telephone = await _storage.read(key: TELEPHONE_KEY);
    String? firstname = await _storage.read(key: FIRSTNAME_KEY);
    String? lastname = await _storage.read(key: LASTNAME_KEY);
    String? accessToken = await _storage.read(key: ACCESSTOKEN_KEY);
    String? organisation = await _storage.read(key: ORGANISATION_KEY);
    String? roles = await _storage.read(key: ROLES_KEY);
    User agentConnected = User(
        id: id ?? "",
        username: username ?? "",
        email: email ?? "",
        telephone: telephone ?? "",
        firstname: firstname ?? "",
        lastname: lastname ?? "",
        accessToken: accessToken ?? "",
        organisation: organisation ?? "",
        roles: List.unmodifiable([roles ?? ""]));

    return agentConnected;
  }

  Future<String?> retrieveAccessToken() async {
    String? tokenJson = await _storage.read(key: TOKEN_KEY);
    if (tokenJson == null) {
      return null;
    }
    return User.fromJson(jsonDecode(tokenJson)).toString();
    // return TokenModel.fromJson(jsonDecode(tokenJson)).accessToken;
  }

  Future<String?> retrieveRefreshToken() async {
    String? tokenJson = await _storage.read(key: TOKEN_KEY);
    if (tokenJson == null) {
      return null;
    }
    return User.fromJson(jsonDecode(tokenJson)).accessToken;
  }

  Future<bool> isTokenExist() async {
    return await _storage.containsKey(key: TOKEN_KEY);
  }

  Future<void> deleteAllToken() async {
    _storage.deleteAll();
  }

  deleteToken(String tokenKey) {
    _storage.delete(key: tokenKey);
  }
}
