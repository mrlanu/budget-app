import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'subcategory.g.dart';

@Collection(inheritance: false)
class Subcategory extends Equatable{
  final Id? id;
  final String name;

  const Subcategory({this.id, this.name = ''});

  Subcategory copyWith({String? name}){
    return Subcategory(id: this.id, name: name ?? this.name);
  }


  @override
  @ignore
  List<Object?> get props => [id, name];
}
