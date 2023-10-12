// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vhm_mobile/_api/dioClient.dart';
import 'package:vhm_mobile/_api/endpoints.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/models/dto/membersDto.dart';
import 'package:vhm_mobile/models/dto/newMembers.dart';
import 'package:vhm_mobile/models/dto/newMembersDto.dart';
import 'package:vhm_mobile/models/dto/user.dart';
import 'package:http/http.dart' as http;

final dbHandler = locator<LocalService>();

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

  Future sendNewMembers(List<NewMembers> newmembers) async {
    String sendResponse;
    String responseAlert;
    for (int i = 0; i <= newmembers.length - 1; i++) {
      var url =
          Uri.parse('https://backendvhm.azurewebsites.net/api/Member/add');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "memberLastName": newmembers[i].memberLastName,
          "memberFirstName": newmembers[i].memberFirstName,
          "memberPhone": newmembers[i].memberPhone,
          "memberDateOfEntry": newmembers[i].memberDateOfEntry,
          "memberInvitedBy": newmembers[i].memberInvitedBy,
          "memberGender": newmembers[i].memberGender,
          "churchId": newmembers[i].churchId,
          "memberTypeId": newmembers[i].memberTypeId
        }),
      );

      if (response.statusCode == 200) {
        sendResponse = response.body;
        if (sendResponse != "") {
          // Add EventGuest
          var url = Uri.parse(
              'https://backendvhm.azurewebsites.net/api/EventGuest/AddEventGuestByMobile');
          final responseEventGuest = await http.post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "eventGuestJoinDate": null,
              "eventGuestJoinDay": null,
              "eventGuestJoinMonth": null,
              "eventGuestJoinYear": null,
              "eventId": null,
              "memberId": sendResponse,
              "churchId": newmembers[i].churchId
            }),
          );

          Members newMemb = Members(
            memberId: int.parse(sendResponse),
            memberLastName: newmembers[i].memberLastName,
            memberFirstName: newmembers[i].memberFirstName,
            memberFullName:
                "${newmembers[i].memberFirstName}' '${newmembers[i].memberFirstName}",
            memberPhone: newmembers[i].memberPhone,
            memberStatus: '',
            flag: true,
          );
          // storage memberId in local
          dbHandler.SaveMembers(newMemb);
        }
      } else {
        responseAlert = 'error';
        return responseAlert;
      }
    }

    responseAlert = 'success';
    return responseAlert;
  }

  Future sendMembers(List<Members> members) async {
    if (kDebugMode) {
      print(members[0].memberId);
    }

    for (int i = 0; i <= members.length - 1; i++) {
      var eventMemberJoinDate = DateTime.now().toString();
      var churchId = 1;

      var url = Uri.parse(
          'https://backendvhm.azurewebsites.net/api/EventMember/mobileAdd');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "eventMemberJoinDate": null,
          "eventMemberJoinDay": null,
          "eventMemberJoinMonth": null,
          "eventMemberJoinYear": null,
          "eventId": null,
          "memberId": members[i].memberId,
          "churchId": churchId
        }),
      );

      if (kDebugMode) {
        print(response.statusCode);
      }

      if (response.statusCode != 200) {
        // Lancez une exception pour signaler une erreur
        throw Exception(
            'Erreur lors de l\'envoi du membre ${members[i].memberId}');
      }
    }
    return 'success';
  }
}
