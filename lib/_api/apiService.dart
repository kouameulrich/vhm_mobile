// ignore_for_file: file_names

import 'dart:convert';

import 'package:vhm_mobile/_api/dioClient.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/models/dto/user.dart';

class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

  Future<User> getUserConnected(String trim) async {
    String agentEndpoint = '';
    final response = await _dioClient.post(agentEndpoint);
    return User.fromJson(response.data);
  }

  Future<List<Members>> getAllMembers() async {
    String memberEndpoints =
        'https://backendvhm.azurewebsites.net/api/Member/getAll?churchId=1';
    final response = await _dioClient.get(memberEndpoints);
    List<dynamic> data = response.data;
    List<Members> member = data.map((e) => Members.fromJson(e)).toList();
    return member;
  }
}
