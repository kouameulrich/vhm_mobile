// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:vhm_mobile/_api/apiService.dart';
import 'package:vhm_mobile/_api/tokenStorageService.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/models/dto/user.dart';
import 'package:vhm_mobile/ui/pages/Members/liste.members.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:vhm_mobile/widgets/loading.indicator.dart';

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

  //  Future<List<Members>> getAllContract() async {
  //   return await dbHandler.readAllMembers();
  // }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.appBarColor,
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
                              onPressed: () => loadData1(),
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

  loadData1() async {
    LoadingIndicatorDialog().show(context);
    var headersList = {'Content-Type': 'application/json'};
    var url = Uri.parse(
        'https://backendvhm.azurewebsites.net/api/Member/getAll?churchId=1');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      List<Members> memberss = await apiService.getAllMembers();
      for (var members in memberss) {
        dbHandler.SaveMembers(members);
      }
      LoadingIndicatorDialog().dismiss();
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'SUCCESS',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 120,
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
                  'Donnée chargé avec succès',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ListMembersPage()));
                },
                child: const Text('RETOUR'))
          ],
        ),
      );
    } else {
      print(res.reasonPhrase);
    }
  }
}
