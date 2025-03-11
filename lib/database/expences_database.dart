import 'package:expences/modules/expences_class.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpencesDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Expences> _allExpences = [];

  /*
    SETUP
  */

  //initailise DB //(basically definig the dataStructure)
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpencesSchema], directory: dir.path);
  }

  /*
   GETTER
  */

  List<Expences> get allExpences => _allExpences;
  /*
    oPERATIONS
  */

  // CREATE - new database
  //create a expences
  Future<void> createNewExpences(Expences newExpence) async {
    await isar.writeTxn(() => isar.expences.put(newExpence));

    //re read the functions
    readExpences();
  }
  //re read the functions

  //READ - only read the database
  Future<void> readExpences() async {
    //fetch all data
    List<Expences> fetchedExpences = await isar.expences.where().findAll();

    //give to local expences
    _allExpences.clear();
    _allExpences.addAll(fetchedExpences);

    //update UI
    notifyListeners();
  }

  //UPDATE - edit database
  Future<void> updateExpences(int id, Expences updatedExpences) async {
    //id has to matched
    updatedExpences.id = id;

    //rewirte
    await isar.writeTxn(() => isar.expences.put(updatedExpences));

    //read
    readExpences();
  }

  //DELETE - remove from database

  Future<void> deleteExpences(int id) async {
    //all we have to is matched id
    await isar.writeTxn(()=> isar.expences.delete(id));

    //re read
    readExpences();
  }

  /*
   HELPER METHODS
  */
}
