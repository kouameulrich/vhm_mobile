// ignore_for_file: file_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vhm_mobile/_api/dioClient.dart';
import 'package:vhm_mobile/_api/endpoints.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/models/dto/membersDto.dart';
import 'package:vhm_mobile/models/dto/newMembers.dart';
import 'package:vhm_mobile/models/dto/newMembersDto.dart';
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

  Future<List<NewMembers>> storeEventGuest() async {
    final response = await _dioClient.post(Endpoints.AddEnventGuest);
    List<NewMembers> newmembers =
        (response.data as List).map((e) => NewMembers.fromJson(e)).toList();
    return newmembers;
  }

  Future<void> sendMembers(List<Members> members) async {
    final membersJson =
        convertMembersToMembersDto(members).map((e) => e.toJson()).toList();

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await _dioClient.post(
      Endpoints.sendMembers,
      data: json.encode(membersJson),
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      final sendResponse = response.data;
      if (sendResponse != "") {
        // Add EventGuest
        final Map<String, String> headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        final response = await _dioClient.post(
          Endpoints.sendNewMembers,
          data: json.encode({
            "eventGuestJoinDate": null,
            "eventGuestJoinDay": null,
            "eventGuestJoinMonth": null,
            "eventGuestJoinYear": null,
            "eventId": null,
            "memberId": sendResponse,
            "churchId":
                1, // Vous pouvez spécifier la valeur appropriée pour churchId ici
          }),
          options: Options(headers: headers),
        );
      }
    }
  }

  List<Membersdto> convertMembersToMembersDto(List<Members> members) {
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

  Future<void> sendNewMembers(List<NewMembers> newmembers) async {
    final newmembersJson = convertNewMembersToNewMembersDto(newmembers)
        .map((e) => e.toJson())
        .toList();
    print(json.encode(newmembersJson));
    await _dioClient.post(Endpoints.sendNewMembers,
        data: json.encode(newmembersJson));
  }

  List<NewMembersdto> convertNewMembersToNewMembersDto(
      List<NewMembers> newmembers) {
    List<NewMembersdto> newmembersDto = [];
    for (var nm in newmembers) {
      NewMembersdto nm1 = NewMembersdto(
          memberLastName: nm.memberLastName,
          memberFirstName: nm.memberFirstName,
          memberPhone: nm.memberPhone,
          memberDateOfEntry: nm.memberDateOfEntry,
          memberInvitedBy: nm.memberInvitedBy,
          memberGender: nm.memberGender,
          churchId: nm.churchId,
          memberTypeId: nm.memberTypeId);
      newmembersDto.add(nm1);
    }
    return newmembersDto;
  }
}
