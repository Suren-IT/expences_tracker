import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controller for name and amount
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

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
          //done button
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: newOpenExpences,
        child: Icon(Icons.add),
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
      onPressed: () {
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          //pop the box
          Navigator.pop(context);

          //save the writing  to db

          //clear controllers
        }
      },
    );
  }
}
