import 'package:isar/isar.dart';

//this line to generate isar file
//run : dart run build_runner build
part 'expences_class.g.dart';

@Collection()
class Expences {
  Id id = Isar.autoIncrement; //0,1,2
  final String name;
  final double amount;
  final DateTime date;

  Expences({required this.name, required this.amount, required this.date});
}
