// This file is responsible for housing the ExpenseItem widget which in turn is responsible for outputting indidual items in the expenses list


import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';


class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Outputs the title of the expense
            Text(expense.title, style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                // Limits the output to only 2 digits after the comma and outputs the amount of the expense
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    // Chooses an appropriate category based on the category of the expense that is to be output
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 8,),
                    // Outputs the formatted date
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
