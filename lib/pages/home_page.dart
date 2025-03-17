import 'package:expences/bar_graph/bargarph.dart';
import 'package:expences/components/mylist_tile.dart';
import 'package:expences/database/expences_database.dart';
import 'package:expences/helper_class/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modules/expences_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controller for name and amount
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  //future state for load graph
  Future<Map<int, double>>? _monthlyExpencesFuture;
  Future<double>? _calculateCurrentMonthTotal;

  @override
  void initState() {
    //read the db from start
    Provider.of<ExpencesDatabase>(context, listen: false).readExpences();

    //load the data for garph
    refershData();

    super.initState();
  }

  //refresh state for graph and also refersh th month salary
  void refershData() {
    _monthlyExpencesFuture =
        Provider.of<ExpencesDatabase>(context, listen: false)
            .calculateMonthlyTotals();
    _calculateCurrentMonthTotal =
        Provider.of<ExpencesDatabase>(context, listen: false)
            .calculateCurrentMonthTotal();
  }

  //Editing functions ...
  void openEditing(Expences expences) {
    //show frefectched data
    String exitngName = expences.name;
    String exitngAmount = expences.amount.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editing Expences "),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: exitngName),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: exitngAmount),
            ),
          ],
        ),
        actions: [
          //cancel buttton
          _cancelButton(),

          //save button
          _createEditButton(expences),
        ],
      ),
    );
  }

  //delete functions...
  void openDeleting(Expences expences) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("delete Expences "),
        actions: [
          //cancel buttton
          _cancelButton(),

          //save button
          _createDeleteButton(expences.id),
        ],
      ),
    );
  }

  //open new expencex box
  void newOpenExpences() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New Expences "),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Expences Name"),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: "Expences amount"),
            ),
          ],
        ),
        actions: [
          //cancel buttton
          _cancelButton(),

          //save button
          createSaveButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpencesDatabase>(
      builder: (context, value, child) {
        //get dates
        int startMonth = value.getMonth();
        int startYear = value.getYear();
        int currentMonth = DateTime.now().month;
        int currentYear = DateTime.now().year;

        //calculate the numbers of month since started
        int monthcount = calculateMonthCount(
            startMonth, startYear, currentMonth, currentYear);

        //only display the expences for curent time
        List<Expences> currentMonthExpences = value.allExpences.where(
          (element) {
            return element.date.year == currentYear &&
                element.date.month == currentMonth;
          },
        ).toList();

        //return scaffold
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: newOpenExpences,
            child: Icon(Icons.add),
            backgroundColor: Colors.grey,
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: FutureBuilder<double>(
              future: _calculateCurrentMonthTotal,
              builder: (context, snapshot) {
                //laoded
                if (snapshot.connectionState == ConnectionState.done) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //toget the amount
                      Text(
                        '\$' + snapshot.data!.toStringAsFixed(2),
                      ),
                      //month name
                      Text(getCurrentMonthName()),
                    ],
                  );
                }
                //loading
                else {
                  return const Text("Loading");
                }
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // graphUI
                SizedBox(
                  height: 250,
                  child: FutureBuilder(
                      future: _monthlyExpencesFuture,
                      builder: (context, snapshot) {
                        //data is loading
                        if (snapshot.connectionState == ConnectionState.done) {
                          final monthlyTotals = snapshot.data ?? {};

                          //list
                          List<double> monthlySalary = List.generate(
                              monthcount,
                              (index) =>
                                  monthlyTotals[startMonth + index] ?? 0.0);

                          return MyBargraph(
                              monthlySalary: monthlySalary,
                              startMonth: startMonth);
                        }

                        //laodig
                        else {
                          return const Center(
                            child: Text("loading"),
                          );
                        }
                      }),
                ),

                // add the list
                Expanded(
                  child: ListView.builder(
                    itemCount: currentMonthExpences.length,
                    itemBuilder: (context, index) {
                      //reverse the list
                      int reverseIndex =
                          currentMonthExpences.length - 1 - index;

                      //get the individuals
                      Expences individualEx = value.allExpences[index];
                      //retun it in list ui
                      return MylistTile(
                        title: individualEx.name,
                        trailing: formatCurreny(individualEx.amount),
                        onEditing: (context) => openEditing(individualEx),
                        onDeleting: (context) => openDeleting(individualEx),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //_cancel Button
  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);
        nameController.clear();
        amountController.clear();
      },
      //make sure clear the controller

      child: Text("Cancel"),
    );
  }

  //_Save Button
  Widget createSaveButton() {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          //pop the box
          Navigator.pop(context);

          //create new expences
          Expences newExpences = Expences(
            name: nameController.text,
            amount: convertStrtoDou(amountController.text),
            date: DateTime.now(),
          );
          //save the writing  to db
          await context.read<ExpencesDatabase>().createNewExpences(newExpences);

          //initailize the data
          refershData();

          //clear controllers
          nameController.clear();
          amountController.clear();
        }
      },
      child: Text("Save "),
    );
  }

  //Editing button
  Widget _createEditButton(Expences expences) {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          //pop
          Navigator.pop(context);

          //update existing one
          Expences updateExpences = Expences(
            name: nameController.text.isNotEmpty
                ? nameController.text
                : expences.name,
            amount: amountController.text.isNotEmpty
                ? convertStrtoDou(amountController.text)
                : expences.amount,
            date: DateTime.now(),
          );
          //old expences id
          int existingId = expences.id;

          //referesh the graph
          refershData();

          //update the exiting method
          await context
              .read<ExpencesDatabase>()
              .updateExpences(existingId, updateExpences);
        }
      },
      child: Text("Update"),
    );
  }

  //open the deleting box
  Widget _createDeleteButton(int id) {
    return MaterialButton(
      onPressed: () async {
        //pop box
        Navigator.pop(context);

        //referesh the graph
        refershData();

        //clear the box
        await context.read<ExpencesDatabase>().deleteExpences(id);
      },
      child: Text("Delete!"),
    );
  }
}
