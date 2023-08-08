// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:vhm_mobile/_api/tokenStorageService.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/user.dart';
import 'package:vhm_mobile/widgets/HomePage/VHM.HP.dart';
import 'package:vhm_mobile/widgets/HomePage/leamanHP.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';
import 'package:vhm_mobile/widgets/mydrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = locator<TokenStorageService>();
  late Future<User?> _futureAgentConnected;
  bool ligth = true;
  late Future<User> userFuture;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    super.initState();
  }

  Future<User?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Defaults.bluePrincipal,
          centerTitle: false,
          title: const Column(
            children: [
              Text(
                'Accueil',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.yellowAccent[500],
              radius: 20,
              child: SizedBox(
                height: 100,
                child: Image.asset(
                  'images/logo_vhm_blanc.png',
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              childAspectRatio: .95,
              mainAxisSpacing: 20,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VHMHP(context),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LeamanHP(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
