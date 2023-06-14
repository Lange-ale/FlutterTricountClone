import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:tricount/db/wallets_database.dart';
import 'package:tricount/model/transiction.dart';
import 'package:tricount/model/person.dart';
import 'package:tricount/model/debt.dart';

class AddEditTransictionPage extends StatefulWidget {
  final Transiction? transiction;
  Map<int, Person> people = {};

  AddEditTransictionPage({
    Key? key,
    required this.transiction,
    required this.people,
  }) : super(key: key);

  @override
  AddEditTransictionPageState createState() => AddEditTransictionPageState();
}

class AddEditTransictionPageState extends State<AddEditTransictionPage> {
  late final Transiction newTransiction;
  final _formKey = GlobalKey<FormState>();
  final peopleCheckboxes = <int, bool>{};
  final peopleDebts = <int, Debt>{};
  bool forWhom = false;

  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    newTransiction = widget.transiction ??
        Transiction(
            id: null,
            description: '',
            totalAmount: 0,
            date: DateTime.now(),
            personId: widget.people.keys.first);
    dateController.text = newTransiction.date.toString().substring(0, 10);
    for (final id in widget.people.keys) {
      peopleCheckboxes[id] = false;
      peopleDebts[id] = Debt(
          id: null, transictionId: newTransiction.id, personId: id, amount: 0);
    }
    initDebts();
    super.initState();
  }

  void initDebts() async {
    final allTransictionDebts =
        await WalletsDatabase.instance.getDebtsOfTransiction(newTransiction);
    setState(() {
      for (final d in allTransictionDebts) {
        peopleDebts[d.personId] = d;
        peopleCheckboxes[d.personId] = true;
      }
      peopleDebts[newTransiction.personId] =
          peopleDebts[newTransiction.personId]!.copyWith(
        amount: newTransiction.totalAmount +
            peopleDebts[newTransiction.personId]!.amount,
      );
      if (peopleDebts[newTransiction.personId]!.amount == 0) {
        peopleCheckboxes[newTransiction.personId] = false;
      }
    });
  }

  void refreshDebts() {
    final debtForeachPerson = newTransiction.totalAmount /
        peopleCheckboxes.values.where((v) => v).length;
    setState(() {
      for (final i in peopleCheckboxes.keys) {
        peopleDebts[i]!.amount =
            peopleCheckboxes[i] == true ? debtForeachPerson : 0;
      }
    });
  }

  void checkForWhom() {
    var allCheckboxes = true;
    for (final i in peopleCheckboxes.keys) {
      if (peopleCheckboxes[i] == false) {
        allCheckboxes = false;
        break;
      }
    }
    setState(() {
      forWhom = allCheckboxes;
    });
  }

  void setForWhom(bool value) {
    setState(() {
      for (final i in peopleCheckboxes.keys) {
        peopleCheckboxes[i] = value;
      }
      forWhom = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newTransiction.id == null ? 'New expense' : 'Edit expense'),
        leading: Column(
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
        actions: [
          Column(
            children: [
              IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    final nChecked = peopleCheckboxes.values.where((v) => v);
                    if (_formKey.currentState!.validate() && nChecked.length > 0) {
                      if (newTransiction.id == null) {
                        WalletsDatabase.instance
                            .insertTransiction(newTransiction);
                      } else {
                        WalletsDatabase.instance
                            .updateTransiction(newTransiction);
                      }
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill the form')));
                    }
                  })
            ],
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: ListView(children: [
              TextFormField(
                initialValue: newTransiction.description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) =>
                    validateIfnotEmpty(value, "Please enter a description"),
                onChanged: (value) => newTransiction.description = value,
              ),
              TextFormField(
                  initialValue: newTransiction.totalAmount.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Amount (€)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => validateIfpositive(
                      value, "Please enter a positive amount"),
                  onChanged: (value) => {
                        newTransiction.totalAmount = double.parse(value),
                        refreshDebts()
                      }),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: newTransiction.date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat("yyyy-MM-dd").format(pickedDate);
                    setState(() {
                      dateController.text = formattedDate;
                      newTransiction.date = pickedDate;
                    });
                  }
                },
              ),
              DropdownButtonFormField(
                  value: newTransiction.personId,
                  decoration: const InputDecoration(
                    labelText: 'Paid by',
                  ),
                  items: widget.people.values
                      .map((person) => DropdownMenuItem(
                            value: person.id,
                            child: Text(person.name),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      {newTransiction.personId = value as int, refreshDebts()}),
              CheckboxListTile(
                title: const Text('For whom',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                value: forWhom,
                onChanged: (value) {
                  setState(() {
                    setForWhom(value!);
                    refreshDebts();
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              ...peopleCheckboxes.keys.map((id) {
                return CheckboxListTile(
                  title: Row(
                    children: [
                      Text(widget.people[id]!.name),
                      const Spacer(),
                      Text(
                        ' (${peopleDebts[id]!.amount.toStringAsFixed(2)}€)',
                        style: const TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  value: peopleCheckboxes[id],
                  onChanged: (value) {
                    setState(() {
                      peopleCheckboxes[id] = value!;
                      checkForWhom();
                      refreshDebts();
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ]),
          )),
    );
  }

  String? validateIfnotEmpty(value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }

  String? validateIfpositive(value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    if (double.parse(value) <= 0) {
      return errorText;
    }
    return null;
  }
}
