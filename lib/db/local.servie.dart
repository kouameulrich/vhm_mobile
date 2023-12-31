import 'package:vhm_mobile/db/repository.dart';
import 'package:vhm_mobile/models/dto/members.dart';
import 'package:vhm_mobile/models/dto/newMembers.dart';

class LocalService {
  final Repository _repository;

  LocalService(this._repository);

//SAVE MEMBERS
  Future<int> SaveMembers(Members members) async {
    return await _repository.insertData('members', members.toJson());
  }

  //SAVE MEMBERS
  Future<int> SaveNewMembersInMemberTable(Members members) async {
    return await _repository.insertData('members', members.toJson());
  }

//READ ALL MEMEBERS
  Future<List<Members>> readAllMembers() async {
    List<Members> memberss = [];
    List<Map<String, dynamic>> list = await _repository.readData('members');
    for (var members in list) {
      memberss.add(Members.fromJson(members));
    }
    return memberss;
  }

  //Edit Members
  updateMembers(Members members) async {
    return await _repository.updateData('members', members.toJson());
  }

  // delete Members
  deleteMembers(membersId) async {
    return await _repository.deleteData('members', membersId);
  }

  deleteAllMembers() async {
    try {
      final int result = await _repository.deleteData('members',
          {}); // Supprime tous les enregistrements de la table 'members'
      print(
          'Tous les membres ont été supprimés de la base de données. Résultat : $result');
    } catch (e) {
      print('Erreur lors de la suppression de tous les membres : $e');
    }
  }

//SAVE LEAMAN

//READ ALL LEAMAN

//SAVE NEW MEMBERS
  Future<int> SaveNewMembers(NewMembers newMembers) async {
    return await _repository.insertData('newmembers', newMembers.toJson());
  }

  //READ ALL NEW MEMBERS
  Future<List<NewMembers>> readAllNewMembers() async {
    List<NewMembers> newmemberss = [];
    List<Map<String, dynamic>> list = await _repository.readData('newmembers');
    for (var newmembers in list) {
      newmemberss.add(NewMembers.fromJson(newmembers));
    }
    return newmemberss;
  }

  // DELETE NEW MEMBERS
  deleteNewMembers(newmembersId) async {
    return await _repository.deleteData('newMembers', newmembersId);
  }

  //NEW MEMBERS EXISTS
  // Vérifie si un membre existe avec le numéro de téléphone donné
  Future<bool> checkMemberExists(String phoneNumber) async {
    try {
      final List<Map<String, dynamic>> list =
          await _repository.readData('members');
      for (var member in list) {
        if (member['memberPhone'] == phoneNumber) {
          // Le membre existe déjà avec ce numéro de téléphone
          return true;
        }
      }
      // Aucun membre trouvé avec ce numéro de téléphone
      return false;
    } catch (e) {
      // Gérer les erreurs, par exemple, la base de données n'existe pas encore.
      print("Erreur lors de la vérification de l'existence du membre: $e");
      return false; // En cas d'erreur, retournez false
    }
  }
}
