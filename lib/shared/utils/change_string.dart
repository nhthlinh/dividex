String toSnakeCase(String input) {
  return input
      .replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'),
        (match) => '${match.group(1)}_${match.group(2)}',
      )
      .toLowerCase();
}

String fromSnakeCase(String input) {
  return input.split('_').map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  }).join();
}

String toPascalCase(String input) {
  return input
      .split(RegExp(r'\s+')) // tách theo khoảng trắng
      .map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join('');
}

String toCamelCase(String input) {
  final words = input.split(RegExp(r'\s+'));
  if (words.isEmpty) return '';

  return words.first.toLowerCase() +
      words
          .skip(1)
          .map((word) {
            if (word.isEmpty) return '';
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          })
          .join('');
}

String getLastTwoWords(String? fullName) {
  if (fullName == null || fullName.trim().isEmpty) return '';

  final parts = fullName.trim().split(RegExp(r'\s+'));

  if (parts.length <= 2) {
    return parts.join(' ');
  }

  return parts.sublist(parts.length - 2).join(' ');
}
