import 'package:flutter/material.dart';

class Carta {
  int id;
  int grupo;
  String descricao;
  bool visivel;
  String image;

  Carta(
      {required this.id,
      required this.grupo,
      required this.descricao,
      this.visivel = false,
      required this.image});
}
