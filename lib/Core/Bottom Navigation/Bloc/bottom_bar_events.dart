
abstract class BottomBarEvent {}

class BottomBarSelectedItem extends BottomBarEvent {
  final int index;
  BottomBarSelectedItem(this.index);
}

class UpdateUserType extends BottomBarEvent {
  final String userType;
  UpdateUserType(this.userType);
}