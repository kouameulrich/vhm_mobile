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

  //LAST MEMBERS
  Future<int> getDernierIdMembre() async {
    try {
      final List<Map<String, dynamic>> list =
          await _repository.readData('members');

      if (list.isNotEmpty) {
        // Tri des membres par ID dans l'ordre décroissant pour obtenir le dernier ID.
        list.sort((a, b) => b['id'].compareTo(a['id']));
        return list.first['id'] as int;
      } else {
        return 0; // Aucun membre trouvé, retourne 0 par défaut
      }
    } catch (e) {
      // Gérer les erreurs, par exemple, la base de données n'existe pas encore.
      print('Erreur lors de la récupération du dernier ID de membre: $e');
      return 0; // En cas d'erreur, retournez 0
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
