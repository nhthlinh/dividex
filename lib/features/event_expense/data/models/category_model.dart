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
        CategoryModel(id: '1', key: 'category.food'),
        CategoryModel(id: '2', key: 'category.transportation'),
        CategoryModel(id: '3', key: 'category.utilities'),
        CategoryModel(id: '4', key: 'category.entertainment'),
        CategoryModel(id: '5', key: 'category.housing'),
        CategoryModel(id: '6', key: 'category.healthcare'),
        CategoryModel(id: '7', key: 'category.shopping'),
        CategoryModel(id: '8', key: 'category.education'),
        CategoryModel(id: '9', key: 'category.savings'),
        CategoryModel(id: '10', key: 'category.miscellaneous'),
      ];

  String localizedName(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    switch (key) {
      case 'category.food':
        return intl.food;
      case 'category.transportation':
        return intl.transportation;
      case 'category.utilities':
        return intl.utilities;
      case 'category.entertainment':
        return intl.entertainment;
      case 'category.housing':
        return intl.housing;
      case 'category.healthcare':
        return intl.healthcare;
      case 'category.shopping':
        return intl.shopping;
      case 'category.education':
        return intl.education;
      case 'category.savings':
        return intl.savings;
      case 'category.miscellaneous':
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