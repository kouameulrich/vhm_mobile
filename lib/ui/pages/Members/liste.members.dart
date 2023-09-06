// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/ui/pages/Members/load.data.page.dart';
import 'package:vhm_mobile/ui/pages/Members/newMembers.page.dart';
import 'package:vhm_mobile/ui/pages/Members/reset.data.page.dart';
import 'package:vhm_mobile/ui/pages/Members/synchronisation.page.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';

class ListMembersPage extends StatefulWidget {
  const ListMembersPage({super.key});

  @override
  State<ListMembersPage> createState() => _ListMembersPageState();
}

class _ListMembersPageState extends State<ListMembersPage> {
  final dbHandler = locator<LocalService>();

  String? _selectContract;
  List<Members> _members = [];
  Members? members;

  TextEditingController searchController = TextEditingController();

  Future<List<Members>> getAllContract() async {
    return await dbHandler.readAllMembers();
  }

  Future<void> writePresenceStorage(Members member, int memberLine) async {
    final storage = FlutterSecureStorage();

    // Mise à jour du membre dans la liste
    final data = await storage.read(key: 'memberStorage');
    final List<dynamic> membersData = jsonDecode(data!) ?? [];
    final memberList =
        membersData.map((json) => Members.fromJson(json)).toList();

    memberList[memberLine] = member;

    final listUpdate = jsonEncode(memberList);
    await storage.write(key: 'memberStorage', value: listUpdate);

    // Écrire le score de présence dans le stockage local
    final checkAttendanceStore =
        await storage.containsKey(key: 'presenceStorage');
    final checkAttendanceIdStore =
        await storage.containsKey(key: 'presenceIdStorage');

    if (checkAttendanceStore == false || checkAttendanceIdStore == false) {
      member.flag = 1; // Supposons que 1 signifie "présent"

      final dataEncoded = json.encode([member]);
      await storage.write(key: 'presenceStorage', value: dataEncoded);

      final dataIdEncoded = json.encode([member.memberId]);
      await storage.write(key: 'presenceIdStorage', value: dataIdEncoded);
    } else {
      final readAttendanceData = await storage.read(key: 'presenceStorage');
      final List<dynamic> decodeData = jsonDecode(readAttendanceData!) ?? [];
      final List<Members> dataToList =
          decodeData.map((json) => Members.fromJson(json)).toList();

      final readAttendanceIdData = await storage.read(key: 'presenceIdStorage');
      final List<dynamic> decodeIdData =
          jsonDecode(readAttendanceIdData!) ?? [];

      dataToList.add(member);
      decodeIdData.add(member.memberId);

      final dataEncoded = json.encode(dataToList);
      await storage.write(key: 'presenceStorage', value: dataEncoded);

      final dataIdEncoded = json.encode(decodeIdData);
      await storage.write(key: 'presenceIdStorage', value: dataIdEncoded);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('------- DATA -------');

      getAllContract().then((value) => setState(() {
            _members = value;
            // _contracts.sort();
          }));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.blueAppBar,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('VHM PRÉSENCE'),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return const [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Réinitialiser"),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text("Valider"),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text("Données"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ResetMembersDataPage()),
              );
            } else if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SynchroMembersDataPage()),
              );
            } else if (value == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoadMembersDataPage()),
              );
            }
          }),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Defaults.blueFondCadre),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 10, top: 15, bottom: 15),
              child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: 'Votre nom ou numéro de téléphone',
                ),
                onChanged: (value) {
                  setState(() {
                    getAllContract().then((memberss) => {
                          _members = memberss
                              .where((element) =>
                                  element.memberFirstName!
                                      .toLowerCase()
                                      .contains(searchController.text
                                          .toString()
                                          .toLowerCase()) ||
                                  element.memberLastName!
                                      .toLowerCase()
                                      .contains(searchController.text
                                          .toString()
                                          .toLowerCase()) ||
                                  element.memberPhone!.toLowerCase().contains(
                                      searchController.text
                                          .toString()
                                          .toLowerCase()))
                              .toList(),
                        });
                  });
                },
              ),
            ),
            // if (_searchText
            //     .isNotEmpty) // Affiche les données uniquement si le champ de recherche n'est pas vide
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTileTheme(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.white,
                    ),
                    itemCount: _members.length,
                    itemBuilder: (context, index) {
                      final memberLine = index;
                      return Card(
                        elevation: 10,
                        margin: const EdgeInsets.all(0.0),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _members![index].memberFullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Defaults.bluePrincipal,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _members![index].memberPhone,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Defaults.bluePrincipal,
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            child: Text('Valider'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text('Alerte Présence'),
                                  content: SizedBox(
                                    height: 140,
                                    child: Column(
                                      children: [
                                        Lottie.asset(
                                          'animations/read.json',
                                          repeat: true,
                                          reverse: true,
                                          fit: BoxFit.cover,
                                          height: 100,
                                        ),
                                        const Text(
                                          'Voulez-vous confirmer votre présence ?',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Non'),
                                      child: Text('Non'),
                                    ),
                                    TextButton(
                                      child: Text('Oui'),
                                      onPressed: () async {
                                        setState(() {
                                          _members[index].flag =
                                              1; // Supposons que 1 signifie "présent"
                                        });
                                        Navigator.pop(context, 'Oui');
                                        await writePresenceStorage(
                                            _members[index], memberLine);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
