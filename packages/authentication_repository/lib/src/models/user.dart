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
    this.token,
    this.email,
    this.isVerified,
    this.name,
    this.photo,
  });

  factory User.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,) {
    final data = snapshot.data();
    return User(
      id: data?['id'] as String?,
      token: data?['token'] as String?,
      email: data?['email'] as String?,
      isVerified: data?['isVerified'] as bool,
      name: data?['name'] as String?,
      photo: data?['photo'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) 'id': id,
      if (token != null) 'token': token,
      if (email != null) 'email': email,
      if (isVerified != null) 'isVerified': isVerified,
      if (name != null) 'name': name,
      if (photo != null) 'photo': photo,
    };
  }

  /// The current user's email address.
  final String? email;

  /// is email verified
  final bool? isVerified;

  /// The current user's id.
  final String? id;

  /// The current user's token.
  final String? token;

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
  List<Object?> get props => [email, isVerified, id, token, name, photo];
}
