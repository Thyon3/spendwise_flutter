import 'package:flutter/material.dart';

class AppIcons {
  // Category Icons
  static const IconData food = Icons.restaurant;
  static const IconData transport = Icons.directions_car;
  static const IconData shopping = Icons.shopping_bag;
  static const IconData entertainment = Icons.movie;
  static const IconData health = Icons.local_hospital;
  static const IconData education = Icons.school;
  static const IconData utilities = Icons.lightbulb;
  static const IconData housing = Icons.home;
  static const IconData travel = Icons.flight;
  static const IconData gifts = Icons.card_giftcard;
  static const IconData pets = Icons.pets;
  static const IconData sports = Icons.sports_soccer;
  static const IconData beauty = Icons.face;
  static const IconData clothing = Icons.checkroom;
  static const IconData electronics = Icons.devices;
  static const IconData insurance = Icons.security;
  static const IconData taxes = Icons.account_balance;
  static const IconData charity = Icons.volunteer_activism;
  static const IconData other = Icons.more_horiz;

  // Income Icons
  static const IconData salary = Icons.work;
  static const IconData freelance = Icons.laptop;
  static const IconData investment = Icons.trending_up;
  static const IconData rental = Icons.apartment;
  static const IconData business = Icons.business;
  static const IconData bonus = Icons.card_giftcard;
  static const IconData refund = Icons.money_off;

  // Payment Method Icons
  static const IconData cash = Icons.money;
  static const IconData creditCard = Icons.credit_card;
  static const IconData debitCard = Icons.payment;
  static const IconData bankTransfer = Icons.account_balance;
  static const IconData digitalWallet = Icons.account_balance_wallet;

  static List<Map<String, dynamic>> getAllCategoryIcons() {
    return [
      {'name': 'Food', 'icon': food},
      {'name': 'Transport', 'icon': transport},
      {'name': 'Shopping', 'icon': shopping},
      {'name': 'Entertainment', 'icon': entertainment},
      {'name': 'Health', 'icon': health},
      {'name': 'Education', 'icon': education},
      {'name': 'Utilities', 'icon': utilities},
      {'name': 'Housing', 'icon': housing},
      {'name': 'Travel', 'icon': travel},
      {'name': 'Gifts', 'icon': gifts},
      {'name': 'Pets', 'icon': pets},
      {'name': 'Sports', 'icon': sports},
      {'name': 'Beauty', 'icon': beauty},
      {'name': 'Clothing', 'icon': clothing},
      {'name': 'Electronics', 'icon': electronics},
      {'name': 'Insurance', 'icon': insurance},
      {'name': 'Taxes', 'icon': taxes},
      {'name': 'Charity', 'icon': charity},
      {'name': 'Other', 'icon': other},
    ];
  }
}
