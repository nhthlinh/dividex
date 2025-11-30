import 'dart:typed_data';

import 'package:Dividex/shared/models/enum.dart';
import 'package:equatable/equatable.dart';

enum LoadType {
  friends,
  groupMembers,
  eventParticipants,
  mutualFriends
}

abstract class LoadUserEvent extends Equatable {
  const LoadUserEvent();

  @override
  List<Object?> get props => [];
}
 
class InitialEvent extends LoadUserEvent {
  final String? id;
  final LoadType action; 
  final String? searchQuery;
  const InitialEvent(this.id, this.action, {this.searchQuery});
}

class LoadMoreUsersEvent extends LoadUserEvent {
  final int page;
  final String? id;
  final LoadType action;
  final String? searchQuery;
  const LoadMoreUsersEvent(this.page, this.id, this.action, {this.searchQuery});
}

class RefreshUsersEvent extends LoadUserEvent {
  final String? id;
  final LoadType action;
  final String? searchQuery;
  const RefreshUsersEvent(this.id, this.action, {this.searchQuery});
}

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
