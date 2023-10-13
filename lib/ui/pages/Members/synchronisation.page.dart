// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_field
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:vhm_mobile/_api/apiService.dart';
import 'package:vhm_mobile/_api/tokenStorageService.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/models/dto/newMembers.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';
import 'package:vhm_mobile/widgets/error.dialog.dart';
import 'package:vhm_mobile/widgets/loading.indicator.dart';
import 'package:connectivity/connectivity.dart';

class SynchroMembersDataPage extends StatefulWidget {
  const SynchroMembersDataPage({Key? key}) : super(key: key);

  @override
  State<SynchroMembersDataPage> createState() => _SynchroMembersDataPageState();
}

class _SynchroMembersDataPageState extends State<SynchroMembersDataPage> {
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  final storage = locator<TokenStorageService>();
  bool hasInternet = false;
  bool isLoadingVisitor = false;
  bool isLoadingPresence = false;
  List<Members> _members = [];
  List<Members> _membersPoint = [];

  List<NewMembers> _newmembers = [];

  int _countMembers = 0;
  int _countNewMembers = 0;

  Future<List<Members>> getAllMembers() async {
    return await dbHandler.readAllMembers();
  }

  Future<List<NewMembers>> getAllNewMembers() async {
    return await dbHandler.readAllNewMembers();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      getAllMembers().then((value) => {
            setState(() {
              _members = value;
              // Filtrer les membres dont le flag est passé de 0 à 1
              _membersPoint =
                  value.where((member) => member.flag == 1).toList();
              _countMembers = _membersPoint.length;
            })
          });

      getAllNewMembers().then((value) => {
            setState(() {
              _countNewMembers = value.length;
              _newmembers = value;
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

            ///-------------NEW MEMBER-----------///
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
                                  '$_countNewMembers',
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
                              onPressed: () {
                                _transferNewMembersToServer();
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

            ///-------------MEMBER-----------///
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
                                _transferMembersToServer();
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
          ],
        ),
      ),
    );
  }

  _transferNewMembersToServer() async {
    try {
      hasInternet = await InternetConnectionChecker().hasConnection;
      if (hasInternet == false) {
        // ignore: use_build_context_synchronously
        // Vérifiez votre connexion Internet et réessayez.
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('ERROR',
                  style: TextStyle(color: Defaults.blueAppBar)),
              content: SizedBox(
                height: 140,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/nodata.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    const Text(
                      'Vérifiez votre connexion Internet et réessayez.',
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
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Affichez l'indicateur de chargement au début de la fonction
        LoadingIndicatorDialog().show(context);
        setState(() {
          isLoadingVisitor = true;
        });

        //APPEL DE L'API D'ENVOI
        var sendResponse = await apiService.sendNewMembers(_newmembers);

        // Fermez l'indicateur de chargement après avoir obtenu une réponse
        LoadingIndicatorDialog().dismiss();

        if (kDebugMode) {
          print(sendResponse);
        }

        if (sendResponse == 'success') {
          getAllMembers().then((value) => {
                setState(() {
                  _members = value;
                  // Filtrer les membres dont le flag est passé de 0 à 1
                  _membersPoint =
                      value.where((member) => member.flag == 1).toList();
                  _countMembers = _membersPoint.length;
                })
              });
          // ignore: use_build_context_synchronously
          // Nouveau membre validé avec succès
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'SUCCESS',
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: 140,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/success.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    const Text(
                      'Nouveau membre validé avec succès',
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
                    child: const Text('RETOUR'))
              ],
            ),
          );
        } else if (sendResponse == 'error') {
          setState(() {
            isLoadingVisitor = false;
          });
          // ignore: use_build_context_synchronously
          // Aucun visiteur enregistré .
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('ERROR',
                    style: TextStyle(color: Defaults.blueAppBar)),
                content: SizedBox(
                  height: 140,
                  child: Column(
                    children: [
                      Lottie.asset(
                        'animations/nodata.json',
                        repeat: true,
                        reverse: true,
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      const Text(
                        'Aucun visiteur enregistré .',
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
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            isLoadingVisitor = false;
          });
          // ignore: use_build_context_synchronously
          // Une erreur est survenue .
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('ERROR',
                    style: TextStyle(color: Defaults.blueAppBar)),
                content: SizedBox(
                  height: 140,
                  child: Column(
                    children: [
                      Lottie.asset(
                        'animations/nodata.json',
                        repeat: true,
                        reverse: true,
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      const Text(
                        'Une erreur est survenue .',
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
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      // En cas d'erreur inattendue, affichez un message d'erreur
      print('Erreur lors de l\'envoi des nouveaux membres : $e');
      setState(() {
        isLoadingPresence = false;
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('ERROR',
                style: TextStyle(color: Defaults.blueAppBar)),
            content: SizedBox(
              height: 140,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/nodata.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  const Text(
                    'Une erreur est survenue lors de l\'envoi des nouveaux membres.',
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
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  _transferMembersToServer() async {
    try {
      hasInternet = await InternetConnectionChecker().hasConnection;
      if (!hasInternet) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('ERROR',
                  style: TextStyle(color: Defaults.blueAppBar)),
              content: SizedBox(
                height: 140,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/nodata.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    const Text(
                      'Vérifiez votre connexion Internet et réessayez.',
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
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        // Affichez l'indicateur de chargement au début de la fonction
        LoadingIndicatorDialog().show(context);
        setState(() {
          isLoadingVisitor = true;
        });

        // APPEL DE L'API D'ENVOI
        var sendResponse = await apiService.sendMembers(_membersPoint);

        // Fermez l'indicateur de chargement après avoir obtenu une réponse
        LoadingIndicatorDialog().dismiss();

        if (sendResponse == 'success') {
          setState(() {
            isLoadingPresence = true;
          });

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'SUCCESS',
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: 140,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/success.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    const Text(
                      'Membre validé avec succès',
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
                    child: const Text('RETOUR'))
              ],
            ),
          );
        } else {
          setState(() {
            isLoadingPresence = false;
          });

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('ERROR',
                    style: TextStyle(color: Defaults.blueAppBar)),
                content: SizedBox(
                  height: 140,
                  child: Column(
                    children: [
                      Lottie.asset(
                        'animations/nodata.json',
                        repeat: true,
                        reverse: true,
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      const Text(
                        'Une erreur est survenue .',
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
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      // En cas d'erreur inattendue, affichez un message d'erreur
      print('Erreur lors de l\'envoi des membres : $e');
      setState(() {
        isLoadingPresence = false;
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('ERROR',
                style: TextStyle(color: Defaults.blueAppBar)),
            content: SizedBox(
              height: 140,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/nodata.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  const Text(
                    'Une erreur est survenue lors de l\'envoi des membres.',
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
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      Future.delayed(const Duration(seconds: 5), () {
        print('One second has passed.');
        LoadingIndicatorDialog().dismiss(); // Prints after 1 second.
      });
    }
  }
}
