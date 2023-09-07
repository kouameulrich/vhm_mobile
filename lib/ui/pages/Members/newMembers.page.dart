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
                              child: ZoneSaisie(
                                  context, memberInvitedByController),
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
    if (_formKey.currentState!.validate()) {
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
                      'animations/recap.json',
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
                      newMembers = NewMembers(
                          memberLastName: membersLastNameController.text,
                          memberFirstName: membersFistNameController.text,
                          memberPhone: memberPhoneController.text,
                          memberDateOfEntry: dateFormat.format(DateTime.now()),
                          memberInvitedBy: memberInvitedByController.text,
                          memberGender: memberGenderController.text,
                          churchId: 1,
                          memberTypeId: 1);
                      await dbHandler.SaveNewMembers(newMembers!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListMembersPage()),
                      );
                    },
                    child: const Text('Oui'))
              ],
            );
          });
    }
  }
}
