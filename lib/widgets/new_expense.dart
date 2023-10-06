// This file is responsible for housing the NewExpense widget which in turn is responsible for displaying a user interface in which the user can create and add a new expense

import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // Creates a TextEditingController when the ModalBottomSheet is brought up by the user in order to store the various user inputs
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate;

  // Stores the value selected in the dropdown menu as well as sets the initial value to food
  Category _selectedCategory = Category.food;

  // Displays a datepicker to the user and prepares to store the date in a variable after user has picked date
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    // Sets the date to variable after the user has picked a date
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // Removes the TextEditingControllers after the user closes the ModalBottomSheet in order to preserve memory
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Displays an error message if there are no inputs or there are invalid inputs provided by the user and then calls the onAddExpense function in order to create a new expense
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        // Displays a popup dialog box to the user in the case of invalid input values
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please make sure a valid title, amount, date and category was entered."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
        ),
      );
      return;
    }

    // Takes the values from the user interface and uses them to create a new Expense
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text("Title"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "\$",
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  // Text input field that stores the data in the Title TextEditingController
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // Date input field
                          children: [
                            // Checks whether _selectDate variabe is null in order to display a message or the date stored in the variable
                            Text(
                              _selectedDate == null
                                  ? "No date selected"
                                  : formatter.format(_selectedDate!),
                            ),
                            // Takes the date selected by the user and passes it to the _presentDatePicker function
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        // Text input field that stores the data in the Amount TextEditingController
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "\$",
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // Date input field
                          children: [
                            // Checks whether _selectDate variabe is null in order to display a message or the date stored in the variable
                            Text(
                              _selectedDate == null
                                  ? "No date selected"
                                  : formatter.format(_selectedDate!),
                            ),
                            // Takes the date selected by the user and passes it to the _presentDatePicker function
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      // Closes the modal sheet when pressed
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                        // Calls on the _submitExpenseData when pressed
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Save"),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      // Creates a dropdown menu that displays all the categories set in the expense model
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      // Closes the modal sheet when pressed
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      // Calls on the _submitExpenseData when pressed
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Save"),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
