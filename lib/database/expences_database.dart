import 'package:expences/modules/expences_class.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpencesDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expences> _allExpences = [];

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

  /*
   HELPER METHODS
  */
}
