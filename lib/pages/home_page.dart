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

  @override
  void initState() {
    Provider.of<ExpencesDatabase>(context, listen: false).readExpences();

    super.initState();
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
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: newOpenExpences,
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            // add individual bar 
            //MyBargraph(monthlySalary: monthlySalary, satrtMonth: satrtMonth)

            // add the list
            Expanded(
              child: ListView.builder(
                itemCount: value.allExpences.length,
                itemBuilder: (context, index) {
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

        //clear the box
        await context.read<ExpencesDatabase>().deleteExpences(id);
      },
      child: Text("Delete!"),
    );
  }
}
