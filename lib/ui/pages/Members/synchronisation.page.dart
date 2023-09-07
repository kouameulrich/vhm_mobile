// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_field
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:vhm_mobile/_api/apiService.dart';
import 'package:vhm_mobile/_api/tokenStorageService.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';
import 'package:vhm_mobile/widgets/error.dialog.dart';
import 'package:vhm_mobile/widgets/loading.indicator.dart';

class SynchroMembersDataPage extends StatefulWidget {
  const SynchroMembersDataPage({Key? key}) : super(key: key);

  @override
  State<SynchroMembersDataPage> createState() => _SynchroMembersDataPageState();
}

class _SynchroMembersDataPageState extends State<SynchroMembersDataPage> {
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  final storage = locator<TokenStorageService>();

  List<Members> _members = [];
  List<Members> _membersPoint = [];

  int _countMembers = 0;
  double _montantCollecte = 0.0;

  Future<List<Members>> getAllMembers() async {
    return await dbHandler.readAllMembers();
  }

  @override
  void initState() {
    //_futureEncaissement = getAllEncaissement();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      getAllMembers().then((value) => {
            setState(() {
              _members = value;
              // Filtrer les membres dont le flag est passé de 0 à 1
              _membersPoint = value
                  // ignore: unrelated_type_equality_checks
                  .where((member) => member.flag == 1)
                  .toList();
              _countMembers = _membersPoint.length;
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.blueAppBar,
        title: const Text('Transfert'),
        centerTitle: true,
      ),
      backgroundColor: Defaults.backgroundColorPage,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Card(
                  color: Colors.white,
                  elevation: 70,
                  child: SizedBox(
                    width: 270,
                    height: 270,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Membre",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Defaults.appBarColor,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Nombre:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '$_countMembers',
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                Text(
                                  'Membre Présent',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Defaults.bluePrincipal),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () {
                                _transferRecensementsToServer();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Defaults.bottomColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.send),
                                    Text(
                                      'Transferer',
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Card(
                  color: Colors.white,
                  elevation: 70,
                  child: SizedBox(
                    width: 270,
                    height: 270,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Nouveau Membre",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Defaults.appBarColor,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Nombre:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  NumberFormat.currency(
                                          decimalDigits: 0, name: '')
                                      .format(_montantCollecte),
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                Text(
                                  'Nouveau Membre Présent',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Defaults.bluePrincipal),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Defaults.bottomColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.send),
                                    Text(
                                      'Transferer',
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _transferRecensementsToServer() {
    if (_members.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirmation',
                style: TextStyle(color: Defaults.blueAppBar)),
            content: SizedBox(
              height: 140,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/sendData.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  const Text(
                    'Voulez-vous transferer les recensements vers le serveur?',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Non')),
              TextButton(
                  onPressed: () async {
                    try {
                      Navigator.of(context).pop();
                      LoadingIndicatorDialog().show(context);
                      print(_members.toString());
                      await apiService.sendMembers(_members);
                      //delete local data after transfering
                      for (var members in _members) {
                        dbHandler.deleteMembers(members.memberId);
                      }
                      getAllMembers().then((value) => setState(() {
                            _members = value;
                          }));
                      LoadingIndicatorDialog().dismiss();
                    } on DioError catch (e) {
                      LoadingIndicatorDialog().dismiss();
                      ErrorDialog().show(e);
                      //print(e.message);
                    }
                  },
                  child: const Text('Oui'))
            ],
          );
        },
      );
    }
  }
}
