// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:vhm_mobile/_api/apiService.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/ui/pages/home.page.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';
import 'package:vhm_mobile/widgets/loading.indicator.dart';

class ResetMembersDataPage extends StatefulWidget {
  const ResetMembersDataPage({super.key});

  @override
  State<ResetMembersDataPage> createState() => _ResetMembersDataPageState();
}

class _ResetMembersDataPageState extends State<ResetMembersDataPage> {
  // Future resetAllMembers() async {
  //   final storage = new FlutterSecureStorage();
  //   // Delete all
  //   await storage.deleteAll();
  // }

  final apiService = locator<ApiService>();
  final dbHandler = locator<LocalService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.appBarColor,
        title: const Text('Réinitialisation'),
        centerTitle: true,
      ),
      // drawer: MyDrawer(),
      backgroundColor: Defaults.backgroundColorPage,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Card(
                  color: Colors.white,
                  elevation: 70,
                  child: SizedBox(
                    width: 310,
                    height: 310,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Réinitialisation des données",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 155,
                            child: Column(
                              children: [
                                Lottie.asset(
                                  'animations/sendData.json',
                                  repeat: true,
                                  reverse: true,
                                  fit: BoxFit.cover,
                                  height: 150,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _resetData();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Defaults.bottomColor)),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.send,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Réinitialiser',
                                      style: TextStyle(fontSize: 25),
                                    ),
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
            )
          ],
        ),
      ),
    );
  }

  Future<void> _resetData() async {
    LoadingIndicatorDialog().show(context);

    try {
      List<Members> _members = await apiService.getAllMembers();

      for (var members in _members) {
        await dbHandler.deleteMembers(members);
      }

      LoadingIndicatorDialog().dismiss();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'SUCCÈS',
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
                  'Réinitialisation éffectué avec succès',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
                child: const Text('RETOUR'))
          ],
        ),
      );
    } catch (e) {
      LoadingIndicatorDialog().dismiss();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'ERREUR',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/error-dialog.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 120,
                  ),
                  const Text(
                    'Erreur lors de la réinitialisation',
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
                  child: const Text('RÉESSAYER'))
            ],
          );
        },
      );
    }
  }
}
