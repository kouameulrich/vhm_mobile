import 'package:flutter/material.dart';
import 'package:vhm_mobile/widgets/Autres/Zone.Saisie.dart';
import 'package:vhm_mobile/widgets/default.colors.dart';

class NewMembersPage extends StatefulWidget {
  const NewMembersPage({super.key});

  @override
  State<NewMembersPage> createState() => _NewMembersPageState();
}

class _NewMembersPageState extends State<NewMembersPage> {
  @override
  final _formKey = GlobalKey<FormState>();

  TextEditingController _selectedValue = TextEditingController();
  TextEditingController membersFistNameController = TextEditingController();
  TextEditingController membersLastNameController = TextEditingController();
  TextEditingController memberPhoneController = TextEditingController();
  TextEditingController memberInvitedByController = TextEditingController();
  TextEditingController memberGenderController = TextEditingController();
  TextEditingController memberDateOfEntry = TextEditingController();
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
    memberDateOfEntry.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Theme(
            data: ThemeData(primarySwatch: Defaults.primaryBleuColor),
            child: Column(
              children: [
                // --------------- CHAMP DE SAISIE 1 ---------- //
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Saisissez votre nom')),
                const SizedBox(
                  height: 4,
                ),
                ZoneSaisie(context, membersFistNameController),
                const SizedBox(
                  height: 8,
                ),
                // --------------- CHAMP DE SAISIE 2 ---------- //
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Saisissez vos prénoms')),
                const SizedBox(
                  height: 4,
                ),
                ZoneSaisie(context, membersLastNameController),
                const SizedBox(
                  height: 8,
                ),
                // --------------- CHAMP DE SAISIE 3 ---------- //
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Saisissez votre numéro')),
                const SizedBox(
                  height: 4,
                ),
                ZoneSaisie(context, memberPhoneController),
                const SizedBox(
                  height: 8,
                ),
                // --------------- CHAMP DE SAISIE 4 ---------- //
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Saisissez le nom de l'inviteur")),
                const SizedBox(
                  height: 4,
                ),
                ZoneSaisie(context, memberInvitedByController),
                const SizedBox(
                  height: 8,
                ),
                // --------------- CHAMP DE SAISIE 5 ---------- //
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Sélectionnez votre genre')),
                const SizedBox(
                  height: 4,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    fillColor: Defaults.white,
                    filled: true,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Defaults.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Defaults.white, width: 2),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
