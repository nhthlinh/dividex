import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String key;

  CategoryModel({
    required this.id,
    required this.key,
  });

  // Static list of all financial categories
  static List<CategoryModel> get categories => [
        CategoryModel(id: '1', key: 'food'),
        CategoryModel(id: '2', key: 'transportation'),
        CategoryModel(id: '3', key: 'utilities'),
        CategoryModel(id: '4', key: 'entertainment'),
        CategoryModel(id: '5', key: 'housing'),
        CategoryModel(id: '6', key: 'healthcare'),
        CategoryModel(id: '7', key: 'shopping'),
        CategoryModel(id: '8', key: 'education'),
        CategoryModel(id: '9', key: 'savings'),
        CategoryModel(id: '10', key: 'miscellaneous'),
      ];

  String localizedName(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    switch (key) {
      case 'food':
        return intl.food;
      case 'transportation':
        return intl.transportation;
      case 'utilities':
        return intl.utilities;
      case 'entertainment':
        return intl.entertainment;
      case 'housing':
        return intl.housing;
      case 'healthcare':
        return intl.healthcare;
      case 'shopping':
        return intl.shopping;
      case 'education':
        return intl.education;
      case 'savings':
        return intl.savings;
      case 'miscellaneous':
        return intl.miscellaneous;
      default:
        return key; // fallback
    }
  }

  @override
  String toString() {
    return key;
  }
}