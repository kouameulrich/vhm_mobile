// ignore_for_file: prefer_const_constructors
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:vhm_mobile/_api/apiService.dart';
import 'package:vhm_mobile/_api/tokenStorageService.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/user.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';
import 'package:vhm_mobile/widgets/error.dialog.dart';
import 'package:vhm_mobile/widgets/loading.indicator.dart';
import 'package:vhm_mobile/widgets/mydrawer.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoadMembersDataPage extends StatefulWidget {
  const LoadMembersDataPage({Key? key}) : super(key: key);

  @override
  State<LoadMembersDataPage> createState() => _LoadMembersDataPageState();
}

class _LoadMembersDataPageState extends State<LoadMembersDataPage> {
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  final storage = locator<TokenStorageService>();
  bool hasInternet = false;

  Future<User?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  void initState() {
    //CHECKING CONNECTION
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });

      final color = hasInternet ? Colors.green : Colors.red;
      final text = hasInternet ? 'Connexion internet active' : 'Pas Internet';
      showSimpleNotification(
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        background: color,
      );
    });
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // do something
    //   getAgent().then((value) => setState((() {
    //         _matriculeAgent = value!.id;
    //       })));
    //   getAllEncaissement().then((value) => {
    //         setState(() {
    //           _payments = value;
    //           _countEncaissement = value.length;
    //           _montantCollecte = _payments.toList().fold(
    //               0, (value, element) => value.toDouble() + element.amount!);
    //         })
    //       });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.appBarColor,
        title: const Text('Chargement de Donnée'),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      backgroundColor: Defaults.backgroundColorPage,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Card(
                  color: Colors.white,
                  elevation: 70,
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Données",
                            style: TextStyle(fontSize: 20),
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
                              children: const [
                                Text(
                                  'Nombre: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Text(
                                //   NumberFormat.currency(
                                //           decimalDigits: 0, name: '')
                                //       .format(_montantCollecte),
                                //   style: TextStyle(
                                //       fontSize: 35,
                                //       fontWeight: FontWeight.bold,
                                //       color: Defaults.bluePrincipal),
                                // ),
                                // Text(
                                //   'FCFA',
                                //   style: TextStyle(
                                //       fontSize: 20,
                                //       fontWeight: FontWeight.bold,
                                //       color: Defaults.greenSelected),
                                // ),
                                // Text(
                                //   'Montant Collecté',
                                //   style: TextStyle(
                                //       fontSize: 20,
                                //       color: Defaults.bluePrincipal),
                                // )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                  onPressed: () =>
                                      _transferMemberServerToLocal(),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Defaults.bottomColor)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.send),
                                        Text(
                                          'Charger Donnée',
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _transferMemberServerToLocal() async {
    if (hasInternet == false) {
      showSimpleNotification(
        Text(
          'Pas de connexion internet',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        background: Colors.red,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'CONFIRMATION',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 210,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/sendData.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 170,
                  ),
                  const Text(
                    'Voulez-vous charger les données provenant du serveur ?',
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
                child: const Text('Non'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    LoadingIndicatorDialog().show(context);
                    await apiService.getAllMembers();
                    LoadingIndicatorDialog().dismiss();
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoadMembersDataPage()),
                    );
                  } on DioError catch (e) {
                    LoadingIndicatorDialog().dismiss();
                    ErrorDialog().show(e);
                  }
                },
                child: const Text('Oui'),
              ),
            ],
          );
        },
      );
    }
  }
}
