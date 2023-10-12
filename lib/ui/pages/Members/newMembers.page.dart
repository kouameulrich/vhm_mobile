// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/models/dto/newMembers.dart';
import 'package:vhm_mobile/ui/pages/Members/liste.members.dart';
import 'package:vhm_mobile/widgets/Autres/Zone.Saisie.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';

class NewMembersPage extends StatefulWidget {
  const NewMembersPage({super.key});

  @override
  State<NewMembersPage> createState() => _NewMembersPageState();
}

class _NewMembersPageState extends State<NewMembersPage> {
  final _formKey = GlobalKey<FormState>();
  final dbHandler = locator<LocalService>();

  NewMembers? newMembers;

  TextEditingController _selectedValue = TextEditingController();
  TextEditingController membersFistNameController = TextEditingController();
  TextEditingController membersLastNameController = TextEditingController();
  TextEditingController memberPhoneController = TextEditingController();
  TextEditingController memberInvitedByController = TextEditingController();
  TextEditingController memberGenderController = TextEditingController();
  List<String> listOfGender = [
    'Homme',
    'Femme',
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    _selectedValue.dispose();
    membersFistNameController.dispose();
    membersLastNameController.dispose();
    memberPhoneController.dispose();
    memberInvitedByController.dispose();
    memberGenderController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: AppBar(
        backgroundColor: Defaults.blueAppBar,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('NOUVELLE PERSONNE'),
          ],
        ),
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListMembersPage()),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Defaults.bluePrincipal,
                )),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Defaults.blueFondCadre),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Theme(
                  data: ThemeData(primarySwatch: Defaults.primaryBleuColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 3, left: 13, right: 13),
                        child: Column(
                          children: [
                            // --------------- CHAMP DE SAISIE 1 ---------- //
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text('Saisissez votre nom')),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ZoneSaisie(
                                  context, membersFistNameController),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // --------------- CHAMP DE SAISIE 2 ---------- //
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text('Saisissez vos prénoms')),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ZoneSaisie(
                                  context, membersLastNameController),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // --------------- CHAMP DE SAISIE 3 ---------- //
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text('Saisissez votre numéro')),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ZoneSaisie(context, memberPhoneController),
                            ),
                            // --------------- CHAMP DE SAISIE 4 ---------- //
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text("Saisissez le nom de l'inviteur")),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: memberInvitedByController,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: "Remplissez le champ",
                                  filled: true,
                                  fillColor: Defaults.white,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: Defaults.white), //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Defaults.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              // child: ZoneSaisie(
                              //     context, memberInvitedByController),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // --------------- CHAMP DE SAISIE 5 ---------- //
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text('Sélectionnez votre genre')),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                ),
                                value: _selectedValue.text.isNotEmpty
                                    ? _selectedValue.text
                                    : null,
                                hint: const Text(
                                  'Genre',
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedValue.text = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "can't empty";
                                  } else {
                                    return null;
                                  }
                                },
                                items: listOfGender.map((String val) {
                                  return DropdownMenuItem(
                                    value: val,
                                    child: Text(
                                      val,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 15, left: 0, right: 0, top: 15),
                              child: ElevatedButton(
                                onPressed: () async {
                                  onSave();
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Defaults.bluePrincipal)),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 15, left: 0, right: 0, top: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.save_alt_rounded,
                                        color: Defaults.white,
                                      ),
                                      Text(
                                        'Valider',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Defaults.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
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

  onSave() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    // int dernierIdMembre = await dbHandler.getDernierIdMembre();

    // Vérifiez si le membre existe déjà en fonction de certains critères, par exemple, le numéro de téléphone
    bool memberExists =
        await dbHandler.checkMemberExists(memberPhoneController.text);

    if (memberExists) {
      // Affichez un message d'erreur indiquant que le membre existe déjà
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Erreur',
              style: TextStyle(color: Defaults.blueAppBar),
            ),
            content: SizedBox(
              height: 140,
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
                    'Vous êtes déjà membre .',
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
      if (_formKey.currentState!.validate()) {
        // Affichez la boîte de dialogue de confirmation si le membre n'existe pas
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Alerte Nouvelle Personne',
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/success.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 110,
                    ),
                    const Text(
                      'Voulez-vous valider votre inscription ?',
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
                    // int nouvelIdMembre = dernierIdMembre + 1;
                    newMembers = NewMembers(
                      memberLastName: membersLastNameController.text,
                      memberFirstName: membersFistNameController.text,
                      memberPhone: memberPhoneController.text,
                      memberDateOfEntry: dateFormat.format(DateTime.now()),
                      memberInvitedBy: memberInvitedByController.text,
                      memberGender: memberGenderController.text,
                      churchId: 1,
                      memberTypeId: 1,
                    );
                    await dbHandler.SaveNewMembers(newMembers!);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListMembersPage()),
                    );
                  },
                  child: const Text('Oui'),
                )
              ],
            );
          },
        );
      }
    }
  }
}
