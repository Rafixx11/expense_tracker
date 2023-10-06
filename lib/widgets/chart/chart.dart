// This file is responsible for housing the chart widget which in turn is responsible for displaying a chart to the user as well as performing some data processing in order to output various sums

import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/chart/chart_bar.dart';
import 'package:expense_tracker/models/expense.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  // Creates the expense buckets for different categories
  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.leisure),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.work),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    // Checks for the buckets highest total expenses in order to establish a local maxima in order to have a point of comparison for other buckets
    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }

    return maxTotalExpense;
  }

  double get totalExpense {
    double totalExpense = 0;

    // Checks for the buckets highest total expenses in order to get the total amount spent
    for (final bucket in buckets) {
      totalExpense += bucket.totalExpenses;
    }

    return totalExpense;
  }

  // Takes the sum values of all the bucets and adds them to a list for easy access
  List<double> get listOfSums {
    List<double> listOfSums = [];

    // Gets all the values in the bucket and adds them to a list for easy displaying
    for (final bucket in buckets) {
      listOfSums.add(bucket.totalExpenses);
    }

    return listOfSums;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      final isDarkMode =
          MediaQuery.of(context).platformBrightness == Brightness.dark;
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.3),
              Theme.of(context).colorScheme.primary.withOpacity(0.0)
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            // Displays the total amount of expenses
            Text(
              "Total amount spent ${totalExpense.toStringAsFixed(2)} \$",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Creates a chart bar for each of the categories specified in the ExpenseBucket class
                  for (final bucket in buckets) // alternative to map()
                    ChartBar(
                      fill: bucket.totalExpenses == 0
                          ? 0
                          : bucket.totalExpenses / maxTotalExpense,
                    )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: buckets
                  .map(
                    (bucket) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          categoryIcons[bucket.category],
                          color: isDarkMode
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.7),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            // Checks the maximum width and decides on the spacin between the text boxes in order to fit them under the icons
            if (width <= 430)
              Row(
                children: [
                  const SizedBox(width: 30),
                  Text("${listOfSums[0].toStringAsFixed(2)}\$"),
                  const SizedBox(width: 50),
                  Text("${listOfSums[1].toStringAsFixed(2)}\$"),
                  const SizedBox(width: 46),
                  Text("${listOfSums[2].toStringAsFixed(2)}\$"),
                  const SizedBox(width: 53),
                  Text("${listOfSums[3].toStringAsFixed(2)}\$"),
                ],
              )
            else
              Row(
                children: [
                  const SizedBox(width: 28),
                  Text("${listOfSums[0].toStringAsFixed(2)}\$"),
                  const SizedBox(width: 60),
                  Text("${listOfSums[1].toStringAsFixed(2)}\$"),
                  const SizedBox(width: 57),
                  Text("${listOfSums[2].toStringAsFixed(2)}\$"),
                  const SizedBox(width: 55),
                  Text("${listOfSums[3].toStringAsFixed(2)}\$"),
                ],
              ),
          ],
        ),
      );
    });
  }
}
