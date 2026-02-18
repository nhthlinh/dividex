import 'package:flutter/material.dart';

class ImageExpenseModel {
  final List<ImageExpenseItemModel> items;
  final String name;
  final String? category;
  final double totalAmount;
  final String currency;
  final String? note;
  final DateTime? expenseDate;
  final DateTime? endDate;

  ImageExpenseModel({
    required this.items,
    required this.name,
    required this.category,
    required this.totalAmount,
    required this.currency,
    required this.note,
    required this.expenseDate,
    required this.endDate,
  });

  factory ImageExpenseModel.fromJson(Map<String, dynamic> json) {
    return ImageExpenseModel(
      items: (json['items'] as List)
          .map((item) => ImageExpenseItemModel.fromJson(item))
          .toList(),
      name: json['name'],
      category: json['category'],
      totalAmount: json['total_amount'].toDouble(),
      currency: json['currency'],
      note: json['note'],
      expenseDate: json['expense_date'] != null
          ? DateTime.parse(json['expense_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'name': name,
      'category': category,
      'total_amount': totalAmount,
      'currency': currency,
      'note': note,
      'expense_date': expenseDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }

  void printInfo() {
    debugPrint('Expense Name: $name');
    debugPrint('Category: $category');
    debugPrint('Total Amount: $totalAmount $currency');
    debugPrint('Note: $note');
    debugPrint('Expense Date: ${expenseDate?.toLocal()}');
    debugPrint('End Date: ${endDate?.toLocal()}');
    debugPrint('Items:');
    for (var item in items) {
      debugPrint(
        '- ${item.name}: ${item.quantity} x ${item.unitPrice} = ${item.totalPrice}',
      );
    }
  }
}

class ImageExpenseItemModel {
  final String name;
  final double quantity;
  final double unitPrice;
  final double totalPrice;

  ImageExpenseItemModel({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory ImageExpenseItemModel.fromJson(Map<String, dynamic> json) {
    return ImageExpenseItemModel(
      name: json['name'],
      quantity: json['quantity'].toDouble(),
      unitPrice: json['unit_price'].toDouble(),
      totalPrice: json['total_price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }
}
