// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:vhm_mobile/_api/apiService.dart';
import 'package:vhm_mobile/_api/tokenStorageService.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/user.dart';
import 'package:vhm_mobile/ui/pages/Members/liste.members.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';
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
  bool isLoading = false;
  var loadResponse;

  Future<User?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  Future writeMemberStorage(data) async {
    final storage = new FlutterSecureStorage();
    //final dataListString = data.toString();
    await storage.write(key: 'memberStorage', value: data);
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
        // backgroundColor: Defaults.appBarColor,
        title: const Text('Données'),
        centerTitle: true,
      ),
      // drawer: MyDrawer(),
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
                    width: 310,
                    height: 310,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Chargement des données",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 180,
                            child: Column(
                              children: [
                                Lottie.asset(
                                  'animations/loadData.json',
                                  repeat: true,
                                  reverse: true,
                                  fit: BoxFit.cover,
                                  height: 179,
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
                              onPressed: () => loadData(),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Defaults.bottomColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.send,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Charger',
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

  loadData() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == false) {
      showSimpleNotification(
        Text(
          'Pas de connexion internet',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        background: Colors.red,
      );
    } else {
      print('Internet');
      setState(() {
        isLoading = true;
      });
      loadResponse = await apiService.getAllMembers();
      if (loadResponse == '') {
        print('vide');
        print(loadResponse);
        showSimpleNotification(
          Text(
            'Echec de chargement ',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          background: Colors.red,
        );
        setState(() {
          isLoading = false;
        });
      } else {
        print('non vide');
        print(loadResponse);
        print(loadResponse.length);
        await writeMemberStorage(loadResponse);
        setState(() {
          isLoading = false;
        });
        showSimpleNotification(
          Text(
            'Données chargées',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          background: Colors.green,
        );
        print('local storage');
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => ListMembersPage()),
          );
        });
      }
    }
  }
}



//   _transferMemberServerToLocal() async {
//     if (hasInternet == false) {
//       showSimpleNotification(
//         Text(
//           'Pas de connexion internet',
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         background: Colors.red,
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text(
//               'CONFIRMATION',
//               textAlign: TextAlign.center,
//             ),
//             content: SizedBox(
//               height: 210,
//               child: Column(
//                 children: [
//                   Lottie.asset(
//                     'animations/sendData.json',
//                     repeat: true,
//                     reverse: true,
//                     fit: BoxFit.cover,
//                     height: 170,
//                   ),
//                   const Text(
//                     'Voulez-vous charger les données provenant du serveur ?',
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Non'),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   try {
//                     LoadingIndicatorDialog().show(context);
//                     await apiService.getAllMembers();
//                     LoadingIndicatorDialog().dismiss();
//                     Navigator.pop(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => LoadMembersDataPage()),
//                     );
//                   } on DioError catch (e) {
//                     LoadingIndicatorDialog().dismiss();
//                     ErrorDialog().show(e);
//                   }
//                 },
//                 child: const Text('Oui'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }
