import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../models/carta.dart';

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<Carta> _cartas = [];
  var _caratasAgrupadas;
  bool _mostrandoErro = false;
  bool _end = false;
  var _footerMessage = 'Inicie a rodada';

  @override
  void initState() {
    _criaListaCartas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _criaGridCartas();
  }

  Widget _criaGridCartas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: GridView.count(
              crossAxisCount: 4,
              children: _criaItensGrid(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.center,
            height: 75.0,
            width: double.infinity,
            color: Colors.red,
            child: !this._end ? this._getText() : this._getButton(),
          ),
        ),
      ],
    );
  }

  Widget _getText() {
    return Text(
      this._footerMessage,
      style: TextStyle(
        fontSize: 22.0,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  void _restart() {
    setState(() {
      this._end = false;
      this._caratasAgrupadas = [];
      this._mostrandoErro = false;
      this._footerMessage = 'Inicie a rodada';
      this._criaListaCartas();
    });
  }

  Widget _getButton() {
    return RaisedButton(
        child: Text("Iniciar"),
        onPressed: () => _restart(),
        color: Colors.black,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        splashColor: Colors.grey);
  }

  void _criaListaCartas() {
    this._cartas = [
      Carta(
          id: 1,
          grupo: 1,
          descricao: "Stephen Curry",
          image: 'assets/nba/curry.jpg'),
      Carta(
          id: 2,
          grupo: 1,
          descricao: "Klay Thompson",
          image: 'assets/nba/thompson.jpg'),
      Carta(
          id: 3,
          grupo: 2,
          descricao: "Michael Jordan",
          image: 'assets/nba/jordan.jpg'),
      Carta(
          id: 4,
          grupo: 2,
          descricao: "Scottie Pippen",
          image: 'assets/nba/pippen.jpeg'),
      Carta(
          id: 5,
          grupo: 3,
          descricao: "Kobe Bryant",
          image: 'assets/nba/kobe.jpg'),
      Carta(
          id: 6,
          grupo: 3,
          descricao: "Shaquille O'Neal",
          image: 'assets/nba/shaq.jpg'),
      Carta(
          id: 7,
          grupo: 4,
          descricao: "Lebron James",
          image: 'assets/nba/james.jpg'),
      Carta(
          id: 8,
          grupo: 4,
          descricao: "Antony Davis",
          image: 'assets/nba/devis.jpg'),
      Carta(
          id: 9,
          grupo: 5,
          descricao: "Kyrie Irving",
          image: 'assets/nba/irving.jpg'),
      Carta(
          id: 10,
          grupo: 5,
          descricao: "Kevin Durant",
          image: 'assets/nba/durant.jpg'),
      Carta(
          id: 11,
          grupo: 6,
          descricao: "Damian Lillard",
          image: 'assets/nba/lillard.jpg'),
      Carta(
          id: 12,
          grupo: 6,
          descricao: "C. J. McCollum",
          image: 'assets/nba/cj.jpg'),
      Carta(
          id: 13,
          grupo: 7,
          descricao: "Russell Westbrook",
          image: 'assets/nba/westbrook.jpg'),
      Carta(
          id: 14,
          grupo: 7,
          descricao: "James Harden",
          image: 'assets/nba/harden.jpg'),
      Carta(
          id: 15,
          grupo: 8,
          descricao: "Karl Malone",
          image: 'assets/nba/malone.jpg'),
      Carta(
          id: 16,
          grupo: 8,
          descricao: "John Stockton",
          image: 'assets/nba/stockton.jpg'),
    ];
    _cartas.shuffle();
  }

  List<Widget> _criaItensGrid() {
    return this._cartas.map((carta) => _criaCardCarta(carta)).toList();
  }

  Widget _criaCardCarta(Carta carta) {
    return GestureDetector(
      onTap: !carta.visivel && !_mostrandoErro
          ? () => _mostrarCarta(carta)
          : () => _setDescription(''),
      child: Card(
        color: Colors.grey,
        child: _criaTextoCard(carta),
      ),
    );
  }

  Widget _criaTextoCard(Carta carta) {
    if (carta.visivel) {
      return Image.asset(
        carta.image,
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(
        Icons.memory,
        color: Colors.black,
      );
    }
  }

  void _mostrarCarta(Carta carta) {
    setState(() {
      carta.visivel = !carta.visivel;
    });
    _setDescription(carta.descricao);
    _validaAcerto();
    _validEnd();
  }

  void _validEnd() {
    if (_cartas.where((p) => !p.visivel).toList().isEmpty) {
      Timer(
          const Duration(milliseconds: 1000),
          () => {
                _setDescription('Parabéns você completou a rodada !'),
                Timer(const Duration(milliseconds: 1000), () => {_setEnd(true)})
              });
    }
  }

  void _setEnd(bool val) {
    setState(() {
      _end = val;
    });
  }

  void _setDescription(String valor) {
    setState(() {
      _footerMessage = valor;
    });
  }

  void _validaAcerto() {
    List<Carta> listaCartasVisiveis = _getCartasVisiveis();
    if (listaCartasVisiveis.length >= 2) {
      _caratasAgrupadas = _getCartasAgrupadas(listaCartasVisiveis);
      List<Carta> cartasIcorretas = <Carta>[];
      _caratasAgrupadas.forEach((key, value) {
        if (value.length < 2) {
          cartasIcorretas.add(value[0]);
        }
      });

      if (cartasIcorretas.length >= 2) {
        _escondeCartasIcorretas(cartasIcorretas);
      }
    }
  }

  List<Carta> _getCartasVisiveis() {
    return _cartas.where((Carta carta) => carta.visivel).toList();
  }

  Map<int, List<Carta>> _getCartasAgrupadas(List<Carta> cartas) {
    return groupBy(cartas, (Carta carta) => carta.grupo);
  }

  void _escondeCartasIcorretas(List<Carta> cartasIcorretas) {
    setState(() {
      _mostrandoErro = true;
    });
    Timer(const Duration(seconds: 1), () {
      for (var i = 0; i < cartasIcorretas.length; i++) {
        setState(() {
          cartasIcorretas[i].visivel = false;
          _setDescription('');
        });
      }
      setState(() {
        _mostrandoErro = false;
      });
    });
  }
}
