import 'dart:typed_data';

import 'package:Dividex/shared/models/enum.dart';

class UserEvent {}

class GetMeEvent extends UserEvent {}

class UpdateMeEvent extends UserEvent {
  final String name;
  final Uint8List? avatar;
  final String? deletedAvatarUid;
  final CurrencyEnum currency;

  UpdateMeEvent({
    required this.name,
    this.avatar,
    required this.currency,
    this.deletedAvatarUid
  });
}

class CreatePinEvent extends UserEvent {
  final String pin;

  CreatePinEvent({required this.pin});
}

class UpdatePinEvent extends UserEvent {
  final String oldPin;
  final String newPin;

  UpdatePinEvent({required this.oldPin, required this.newPin});
}

class ReviewEvent extends UserEvent {
  final int stars;
  ReviewEvent({this.stars = 5});
}
