// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vhm_mobile/_api/apiService.dart';
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
  final apiService = locator<ApiService>();

  String? _selectContract;
  List<Members> _members = [];
  Members? members;
  // Utilisez un Map pour stocker l'état (activé/désactivé) de chaque membre
  Map<int, bool> memberButtonStates = {};

  TextEditingController searchController = TextEditingController();

  Future<List<Members>> getAllMembers() async {
    return await dbHandler.readAllMembers();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('------- DATA -------');

      getAllMembers().then((value) => setState(() {
            _members = value;
            // _contracts.sort();
            // Initialisez l'état de chaque membre à true (bouton activé)
            for (var member in _members) {
              memberButtonStates[member.memberId] = true;
            }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15.0, 15.0, 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                    ),
                    child: Text('Nouvelle Personne'),
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
                    getAllMembers().then((memberss) => {
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
                      color: Colors.black,
                    ),
                    itemCount: _members.length,
                    itemBuilder: (context, index) {
                      final memberLine = index;
                      return ListTile(
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
                          onPressed:
                              !memberButtonStates[_members[index].memberId]!
                                  ? null
                                  : () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
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
                                                  memberButtonStates[
                                                          _members[index]
                                                              .memberId] =
                                                      false; // Désactivez le bouton
                                                });

                                                // Mettez à jour le membre avec le nouveau drapeau
                                                _members[index].flag =
                                                    1; // Assurez-vous que '1' est le nouveau drapeau

                                                try {
                                                  // Appelez la méthode updateMembers pour mettre à jour le membre sur le serveur
                                                  // await apiService.updateMembers(
                                                  //     _members[index]);

                                                  // Vous pouvez également mettre à jour le membre localement si nécessaire
                                                  await dbHandler.updateMembers(
                                                      _members[index]);

                                                  Navigator.pop(context, 'Oui');
                                                } catch (e) {
                                                  // Gérez les erreurs en conséquence
                                                  print(
                                                      'Erreur lors de la mise à jour du membre : $e');
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
