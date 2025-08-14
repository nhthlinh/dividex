import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavVisibilityCubit extends Cubit<bool> {
  BottomNavVisibilityCubit() : super(true); // mặc định hiển thị

  void hide() => emit(false);
  void show() => emit(true);
}
