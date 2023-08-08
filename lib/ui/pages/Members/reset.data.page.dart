// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vhm_mobile/ui/pages/Members/load.data.page.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';
import 'package:vhm_mobile/widgets/loading.indicator.dart';
import 'package:vhm_mobile/widgets/mydrawer.dart';

class ResetMembersDataPage extends StatefulWidget {
  const ResetMembersDataPage({super.key});

  @override
  State<ResetMembersDataPage> createState() => _ResetMembersDataPageState();
}

class _ResetMembersDataPageState extends State<ResetMembersDataPage> {
  @override
  Future resetAllMembers() async {
    final storage = new FlutterSecureStorage();
    // Delete all
    await storage.deleteAll();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: AppBar(
        title: const Text('Réinitialiser'),
      ),
      drawer: MyDrawer(),
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
                    width: 300,
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
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
                            child: const Column(
                              children: [
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
                              onPressed: () async {
                                LoadingIndicatorDialog().show(context);
                                await resetAllMembers();
                                LoadingIndicatorDialog().dismiss();
                                Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoadMembersDataPage()),
                                );
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Defaults.bottomColor)),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.update),
                                    Text(
                                      'Réinitialiser',
                                      style: TextStyle(fontSize: 20),
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
}
