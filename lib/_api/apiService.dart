// ignore_for_file: file_names

import 'dart:convert';

import 'package:vhm_mobile/_api/dioClient.dart';
import 'package:vhm_mobile/_api/endpoints.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/models/dto/membersDto.dart';
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

  Future<void> sendMembers(List<Members> members) async {
    final membersJson =
        convertRecencementToMembersDto(members).map((e) => e.toJson()).toList();
    // try{
    print(json.encode(membersJson));
    await _dioClient.post(Endpoints.sendMembers,
        data: json.encode(membersJson));
  }

  List<Membersdto> convertRecencementToMembersDto(List<Members> members) {
    List<Membersdto> membersDto = [];
    for (var m in members) {
      Membersdto m1 = Membersdto(
        memberId: m.memberId,
        memberLastName: m.memberLastName,
        memberFirstName: m.memberFirstName,
        memberFullName: m.memberFullName,
        memberPhone: m.memberPhone,
        memberStatus: m.memberStatus,
        flag: m.flag == 0 ? false : true,
      );
      membersDto.add(m1);
    }
    return membersDto;
  }
}
