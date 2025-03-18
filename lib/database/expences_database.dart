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
    await isar.writeTxn(() => isar.expences.delete(id));

    //re read
    readExpences();
  }

  /*
   HELPER METHODS
  */

  //calculate the monthely totals
  // * 2024 -0:200(jan),
  //   2024-1:34(Feb) ....2024-11:344(dec),2025-0:34(Jan)
  Future<Map<String, double>> calculateMonthlyTotals() async {
    //read fiom the data base
    await readExpences();

    //create the map to keep track
    Map<String, double> monthlyExpences = {};

    //iterate the expencs
    for (var expence in _allExpences) {
      //extract the month date from db and year
      String yearMonth = '${expence.date.year} - ${expence.date.year}';

      //if month not mention add the new one
      if (!monthlyExpences.containsKey(yearMonth)) {
        monthlyExpences[yearMonth] = 0;
      }

      //add monthly expences amount to bar graph
      monthlyExpences[yearMonth] = monthlyExpences[yearMonth]! + expence.amount;
    }
    return monthlyExpences;
  }

  //calculate the current month total

  Future<double> calculateCurrentMonthTotal() async {
    //ensure expensce read from db
    await readExpences();
    //get current year,momth
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;
    //fliter the expences include those only for this year,month
    List<Expences> currentMonthExpences = _allExpences.where(
      (expence) {
        return expence.date.month == currentMonth &&
            expence.date.year == currentYear;
      },
    ).toList();

    //calculate total amount for the current month
    double total = currentMonthExpences.fold(
      0,
      (sum, expense) => sum + expense.amount,
    );

    return total;
  }

  //get start month
  int getMonth() {
    //check if is new or not
    if (_allExpences.isEmpty) {
      return DateTime.now().month;
    }
    //sort all expences
    _allExpences.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return _allExpences.first.date.month;
  }

  //get the start year
  int getYear() {
    //check if is new or not
    if (_allExpences.isEmpty) {
      return DateTime.now().year;
    }
    //sort all expences
    _allExpences.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return _allExpences.first.date.year;
  }
}
