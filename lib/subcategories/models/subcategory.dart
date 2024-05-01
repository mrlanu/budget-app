import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'subcategory.g.dart';

@Embedded(inheritance: false)
class Subcategory extends Equatable {
  final String name;

  const Subcategory({this.name = ''});

  Subcategory copyWith({String? name}) {
    return Subcategory(name: name ?? this.name);
  }

  @override
  @ignore
  List<Object?> get props => [name];
}
