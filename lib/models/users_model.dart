class UsersModel {
  UsersModel({
    required this.name,
    required this.givenCashList,
  }) : total = givenCashList.fold(0, (previous, element) => previous + element);

  final List<int> givenCashList;
  final String name;
  final int total;

  @override
  String toString() => '''
UsersModel(
     name: $name,
     givenCashList: $givenCashList,
     total: $total
     )''';
}
