import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  final String tittle;
  LoginCard({this.tittle});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.red[100],
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.account_circle,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Faça login para acessar a página $tittle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed('/login');
                },
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: const Text(
                    'LOGIN'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}