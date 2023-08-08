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
  bool hasInternet = false;
  bool isLocalData = false;
  late List member = [];
  List<Members> attendanceStore = [];
  List attendanceIdStore = [];
  int _countMembers = 0;
  TextEditingController searchController = TextEditingController();

  Future writePresenceStorage(Members member, int memberLine) async {
    final storage = new FlutterSecureStorage();

    //Update member into list
    final data = await storage.read(key: 'memberStorage');
    final List members = jsonDecode(data!);
    final memberList = members.map((json) => Members.fromJson(json)).toList();

    setState(() {
      memberList[memberLine] = member;
    });

    print(memberList[memberLine].flag);

    final listUpdate = jsonEncode(memberList);
    await storage.write(key: 'memberStorage', value: listUpdate);

    //Write attendance score in local storage
    final checkAttendanceStore =
        await storage.containsKey(key: 'presenceStorage');
    final checkAttendanceIdStore =
        await storage.containsKey(key: 'presenceIdStorage');

    if (checkAttendanceStore == false || checkAttendanceIdStore == false) {
      setState(() {
        attendanceStore.add(member);
        attendanceIdStore.add(member.memberId);
      });

      final dataEncoded = json.encode(attendanceStore);
      final dataIdEncoded = json.encode(attendanceIdStore);
      await storage.write(key: 'presenceStorage', value: dataEncoded);
      await storage.write(key: 'presenceIdStorage', value: dataIdEncoded);
    } else {
      //Read data storage member
      final readAttendanceData = await storage.read(key: 'presenceStorage');
      final List decodeData = jsonDecode(readAttendanceData!);
      final List<Members> dataToList =
          decodeData.map((json) => Members.fromJson(json)).toList();

      final readAttendanceIdData = await storage.read(key: 'presenceIdStorage');
      final List decodeIdData = jsonDecode(readAttendanceIdData!);

      setState(() {
        dataToList.add(member);
        decodeIdData.add(member.memberId);
      });

      final dataEncoded = json.encode(dataToList);
      await storage.write(key: 'presenceStorage', value: dataEncoded);

      final dataIdEncoded = json.encode(decodeIdData);
      await storage.write(key: 'presenceIdStorage', value: dataIdEncoded);
    }
  }

  String _searchText = ''; // Variable pour stocker le texte de recherche

  void filterMembers(String searchText) {
    setState(() {
      _searchText = searchText; // Met à jour le texte de recherche
      attendanceStore = attendanceStore
          .where((element) =>
              element.memberPhone!.contains(searchText) ||
              element.memberFirstName!
                  .toLowerCase()
                  .contains(searchText.toString().toLowerCase()) ||
              element.memberLastName!
                  .toLowerCase()
                  .contains(searchText.toString().toLowerCase()) ||
              element.memberFullName!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
      _countMembers = attendanceStore.length;
    });
  }

  Future<List<Members>> getAllMembers() async {
    return await dbHandler.readAllMembers();
  }

  void initState() {
    // TODO: implement initState
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });

      final color = hasInternet ? Colors.green : Colors.red;
      final text = hasInternet ? 'Connexion internet active' : 'Pas Internet';

      showSimpleNotification(
        Text(
          '$text',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        background: color,
      );
    });

    getAllMembers().then((value) => setState(() {
          _countMembers = value.length;
          attendanceStore = value;
          // _contracts.sort();
        }));

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('VHM PRÉSENCE'),
          ],
        ),
        //centerTitle: true,
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 15.0, 15.0, 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                  ),
                  child: const Text('Nouvelle Personne'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewMembersPage()),
                    );
                  },
                ),
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 15),
            child: _countMembers == 0
                ? const Text('')
                : TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Votre nom ou numéro de téléphone',
                    ),
                    onChanged: (value) {
                      filterMembers(value);
                    },
                  ),
          ),
          isLocalData
              ? Expanded(
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
                        itemCount: member.length,
                        itemBuilder: (context, index) {
                          Members members = attendanceIdStore[index];
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
                                    '${members.memberFullName}',
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
                                    '${members.memberPhone}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text('Alert Présence'),
                                      content: SizedBox(
                                        height: 120,
                                        child: Column(
                                          children: [
                                            Lottie.asset(
                                              'animations/verif.json',
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
                                            members.flag = !members.flag;
                                            setState(() {
                                              member[index] = members;
                                            });
                                            Navigator.pop(context, 'Oui');
                                            await writePresenceStorage(
                                                members, memberLine);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit),
                                label: Text("Valider"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Aucune donnée',
                      ),
                      const SizedBox(
                        height: 120,
                      ),
                      ElevatedButton(
                        child: const Text('Actualiser'),
                        onPressed: () async {
                          initState();
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
