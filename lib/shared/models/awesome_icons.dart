import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconTile extends Equatable {
  final IconData iconData;
  final String title;

  IconTile({required this.iconData, required this.title});

  @override
  List<Object?> get props => [title];
}

List<IconTile> appIconsList = [
  IconTile(iconData: FontAwesomeIcons.umbrellaBeach, title: 'umbrellaBeach'),
  IconTile(iconData: FontAwesomeIcons.lightbulb, title: 'lightbulb'),
  IconTile(iconData: FontAwesomeIcons.gift, title: 'gift'),
  IconTile(iconData: FontAwesomeIcons.burger, title: 'burger'),
  IconTile(iconData: FontAwesomeIcons.prescription, title: 'prescription'),
  IconTile(iconData: FontAwesomeIcons.hammer, title: 'hammer'),
  IconTile(iconData: FontAwesomeIcons.graduationCap, title: 'graduationCap'),
  IconTile(iconData: FontAwesomeIcons.sackDollar, title: 'sackDollar'),
  IconTile(iconData: FontAwesomeIcons.chartPie, title: 'chartPie'),
  IconTile(iconData: FontAwesomeIcons.heart, title: 'heart'),
  IconTile(iconData: FontAwesomeIcons.cartShopping, title: 'cartShopping'),
  IconTile(iconData: FontAwesomeIcons.plane, title: 'plane'),
  IconTile(iconData: FontAwesomeIcons.users, title: 'users'),
  IconTile(iconData: FontAwesomeIcons.shirt, title: 'shirt'),
  IconTile(iconData: FontAwesomeIcons.wallet, title: 'wallet'),
  IconTile(iconData: FontAwesomeIcons.seedling, title: 'seedling'),
  IconTile(iconData: FontAwesomeIcons.wrench, title: 'wrench'),
  IconTile(iconData: FontAwesomeIcons.crown, title: 'crown'),
  IconTile(iconData: FontAwesomeIcons.wineBottle, title: 'wineBottle'),
  IconTile(iconData: FontAwesomeIcons.venus, title: 'venus'),
  IconTile(iconData: FontAwesomeIcons.tent, title: 'tent'),
  IconTile(iconData: FontAwesomeIcons.shrimp, title: 'shrimp'),
  IconTile(iconData: FontAwesomeIcons.scissors, title: 'scissors'),
  IconTile(iconData: FontAwesomeIcons.scaleUnbalanced, title: 'scaleUnbalanced'),
  IconTile(iconData: FontAwesomeIcons.plane, title: 'plane'),
  IconTile(iconData: FontAwesomeIcons.personHiking, title: 'personHiking'),
  IconTile(iconData: FontAwesomeIcons.moneyBills, title: 'moneyBills'),
  IconTile(iconData: FontAwesomeIcons.martiniGlassEmpty, title: 'martiniGlass'),
  IconTile(iconData: FontAwesomeIcons.couch, title: 'couch'),
  IconTile(iconData: FontAwesomeIcons.carRear, title: 'carRear'),
  IconTile(iconData: FontAwesomeIcons.buildingColumns, title: 'buildingColumns'),
  IconTile(iconData: FontAwesomeIcons.babyCarriage, title: 'babyCarriage'),
  IconTile(iconData: FontAwesomeIcons.faceKissWinkHeart, title: 'faceKissWinkHeart'),
  IconTile(iconData: FontAwesomeIcons.piggyBank, title: 'piggyBank'),
  IconTile(iconData: FontAwesomeIcons.house, title: 'house'),
  IconTile(iconData: FontAwesomeIcons.mugHot, title: 'mugHot'),
  IconTile(iconData: FontAwesomeIcons.truck, title: 'truck'),
  IconTile(iconData: FontAwesomeIcons.gamepad, title: 'gamepad'),
  IconTile(iconData: FontAwesomeIcons.handHoldingHeart, title: 'handHoldingHeart'),
  IconTile(iconData: FontAwesomeIcons.store, title: 'store'),
  IconTile(iconData: FontAwesomeIcons.userTie, title: 'userTie'),
  IconTile(iconData: FontAwesomeIcons.tooth, title: 'tooth'),
  IconTile(iconData: FontAwesomeIcons.pizzaSlice, title: 'pizzaSlice'),
  IconTile(iconData: FontAwesomeIcons.penClip, title: 'penClip'),
  IconTile(iconData: FontAwesomeIcons.dog, title: 'dog'),
  IconTile(iconData: FontAwesomeIcons.cakeCandles, title: 'cakeCandles'),

];
