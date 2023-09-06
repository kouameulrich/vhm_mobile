import 'package:vhm_mobile/db/repository.dart';
import 'package:vhm_mobile/models/dto/members.dart';

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
  UpdateMembers(members) async {
    return await _repository.updateData('members', members);
  }

  // delete Members
  deleteMembers(Members members) async {
    return await _repository.deleteData('members', members.toJson());
  }

//SAVE LEAMAN

//READ ALL LEAMAN

//SAVE NEW MEMBERS
}
