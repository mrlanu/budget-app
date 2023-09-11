import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    this.id,
    this.email,
    this.name,
    this.photo,
  });

  factory User.fromJson(
      Map<String, dynamic> json, [
        String? id,
      ]) {
    return User(
      id: id ?? json['id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
    );
  }

  factory User.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,) {
    final data = snapshot.data();
    return User(
      id: data?['id'] as String?,
      email: data?['email'] as String?,
      name: data?['name'] as String?,
      photo: data?['photo'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (photo != null) 'photo': photo,
    };
  }

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String? id;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, photo];
}
