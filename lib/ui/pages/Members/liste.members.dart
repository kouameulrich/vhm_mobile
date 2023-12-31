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
import 'package:vhm_mobile/ui/pages/home.page.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';
import 'package:vhm_mobile/widgets/loading.indicator.dart';

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

  TextEditingController searchController = TextEditingController();

  Future<List<Members>> getAllMembers() async {
    return await dbHandler.readAllMembers();
  }

  // Fonction de clear de la bar de recherche
  final bool _showClearIcon = false;

  void _clearSearch() {
    setState(() {
      searchController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('------- DATA -------');

      // Utilisation du LoadingIndicatorDialog
      LoadingIndicatorDialog().show(context, text: 'Chargement en cours');

      getAllMembers().then((value) {
        setState(() {
          _members = value;

          isLoading = false; // Fin du chargement
          // Dissimulez le LoadingIndicatorDialog une fois que les données sont chargées
          LoadingIndicatorDialog().dismiss();
        });
      });
    });
  }

  @override
  void dispose() {
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Votre nom ou numéro de téléphone',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: _clearSearch,
                              )
                            : null,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black12),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black12),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          getAllMembers().then((memberss) {
                            _members = memberss
                                .where(
                                    (element) =>
                                        element.memberFullName!
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase()) ||
                                        element.memberFirstName!.toLowerCase().contains(
                                            searchController.text
                                                .toString()
                                                .toLowerCase()) ||
                                        element.memberLastName!
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase()) ||
                                        element.memberPhone!
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase()))
                                .toList();
                          });
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
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
                  child: ListView.builder(
                    itemCount: _members.length,
                    itemBuilder: (context, index) {
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
                          onPressed: _members[index].flag == 0
                              ? () async {
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
                                          onPressed: () {
                                            Navigator.pop(context, 'Non');
                                          },
                                          child: Text('Non'),
                                        ),
                                        TextButton(
                                          child: Text('Oui'),
                                          onPressed: () async {
                                            Navigator.pop(context, 'Oui');
                                            // Mettez à jour le flag du membre
                                            setState(() {
                                              _members[index].flag = 1;
                                              dbHandler.updateMembers(
                                                  _members[index]);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              : null,
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
