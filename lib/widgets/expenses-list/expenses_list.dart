// This file is responsible for housing the ExpensesList widget which in turn is responsible for displaying a list of the created expenses

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses-list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Decides on how many widgets to create based on the amount of created expenses
      itemCount: expenses.length,
      // Outputs each of the expenses as the ExpenseItem widget
      itemBuilder: (ctx, index) => Dismissible(
        // Ensures that the items can only be deleted when the user swipes left
        direction: DismissDirection.endToStart,
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        // Executes the onRemoveExpense function when user fully swipes left
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(expense: expenses[index]),
      ),
    );
  }
}
