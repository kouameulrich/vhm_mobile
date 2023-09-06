// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_field
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:vhm_mobile/_api/apiService.dart';
import 'package:vhm_mobile/_api/tokenStorageService.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/models/dto/user.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';
import 'package:vhm_mobile/widgets/mydrawer.dart';

class SynchroMembersDataPage extends StatefulWidget {
  const SynchroMembersDataPage({Key? key}) : super(key: key);

  @override
  State<SynchroMembersDataPage> createState() => _SynchroMembersDataPageState();
}

class _SynchroMembersDataPageState extends State<SynchroMembersDataPage> {
  final dbHandler = locator<LocalService>();
  final apiService = locator<ApiService>();
  final storage = locator<TokenStorageService>();

  // List<Members> _payments = [];
  // final List<Members> _facturePayments = [];

  int _countEncaissement = 0;
  double _montantCollecte = 0.0;

  String userid = '';

  // Future<List<Payment>>? _futureEncaissement;

  // Future<List<Payment>> getAllEncaissement() async {
  //   return await dbHandler.readAllPayment();
  // }

  Future<User?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  void initState() {
    //_futureEncaissement = getAllEncaissement();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      getAgent().then((value) => userid = value!.id!);
      // getAllEncaissement().then((value) => {
      //       setState(() {
      //         _payments = value;
      //         _countEncaissement = value.length;
      //         _montantCollecte = _payments.toList().fold(
      //             0, (value, element) => value.toDouble() + element.amount!);
      //       })
      //     });
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
                                  NumberFormat.currency(
                                          decimalDigits: 0, name: '')
                                      .format(_montantCollecte),
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

  // void sendData() async {
  //   var headersList = {
  //     'Accept': '*/*',
  //     'Content-Type': 'application/json',
  //   };
  //   var url =
  //       Uri.parse('http://192.168.1.12:8080/api/public/bulkPayments/$userid');

  //   // Assurez-vous que _payments n'est pas vide avant de continuer
  //   if (_payments.isNotEmpty) {
  //     var body = [];

  //     // Parcourir chaque paiement et les ajouter à la liste body
  //     for (var payment in _payments) {
  //       body.add({
  //         "agent": {"id": payment.},
  //         "contract": {"id": payment.contract},
  //         "amount": payment.amount,
  //         "paymentDate": payment.paymentDate.toString()
  //       });
  //     }

  //     var req = http.Request('POST', url);
  //     req.headers.addAll(headersList);
  //     req.body = json.encode(body);

  //     var res = await req.send();

  //     ///-------- POPU UP OF SUCCESS ---------//
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       return showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text(
  //             'SUCCESS',
  //             textAlign: TextAlign.center,
  //           ),
  //           content: SizedBox(
  //             height: 120,
  //             child: Column(
  //               children: [
  //                 Lottie.asset(
  //                   'animations/success.json',
  //                   repeat: true,
  //                   reverse: true,
  //                   fit: BoxFit.cover,
  //                   height: 100,
  //                 ),
  //                 const Text(
  //                   'Payment send Successfuly',
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.push(context,
  //                       MaterialPageRoute(builder: (_) => const HomePage()));
  //                 },
  //                 child: const Text('GO BACK'))
  //           ],
  //         ),
  //       );
  //     } else {
  //       setState(() {
  //         showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: const Text(
  //               'ERROR',
  //               textAlign: TextAlign.center,
  //             ),
  //             content: SizedBox(
  //               height: 120,
  //               child: Column(
  //                 children: [
  //                   Lottie.asset(
  //                     'animations/error-dialog.json',
  //                     repeat: true,
  //                     reverse: true,
  //                     fit: BoxFit.cover,
  //                     height: 100,
  //                   ),
  //                   const Text(
  //                     'Error in Payment Data',
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text('Retry'))
  //             ],
  //           ),
  //         );
  //       });
  //     }
  //   } else {
  //     print("La liste _payments est vide.");
  //   }
  // }
}
