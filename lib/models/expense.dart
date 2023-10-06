// An expense model class that takes a title, amount, date and category and formats them so that they can be displayed by other widgets more easily

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Creates a formater object that will be used to format the date
final formatter = DateFormat.yMd();

const uuid = Uuid();

//Defines which categories the user will be allowed to choose from when creating an expense
enum Category { food, travel, leisure, work }

// Assigns category icons to the categories
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid
            .v4(); //Automatically generates an id when the Expense class is initialized

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  // Uses the formatter in order to format the input date
  String get formattedDate {
    return formatter.format(date);
  }
}

// An expense bucket model class that takes all the amounts in a specified category and sums them so that they can be displayed by other widgets

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
