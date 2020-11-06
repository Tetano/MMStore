import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:michellemirandastore/models/address.dart';

class AddressInputField extends StatelessWidget {
  @override
  final Address address;

  const AddressInputField(this.address);

  Widget build(BuildContext context) {
    String emptyValidator(String text) {
      text.isEmpty ? 'Campo Obrigatório' : null;
    }
    //TODO -> Colocar tudo dentro de um scaffol, quando tiver erro exibir que não conseguiu chamar devido a etc e que é para tentar novamente.
    // TODO -> Usar um showSnackBar para mostrar o erro.
    if(address.zipCode != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: address.streat,
            decoration: const InputDecoration(
                isDense: true, labelText: 'Rua/Avenida', hintText: 'Av.Brasil'),
            validator: emptyValidator,
            onSaved: (t) => address.streat = t,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: address.number,
                  decoration: const InputDecoration(
                      isDense: true, labelText: 'Número', hintText: '1,2,3'),
                  validator: emptyValidator,
                  onSaved: (t) => address.number = t,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Complemento',
                      hintText: 'Portão Azul'),
                  validator: emptyValidator,
                  onSaved: (t) => address.complement = t,
                ),
              )
            ],
          ),
          Row(children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                enabled: false,
                initialValue: address.city,
                decoration: const InputDecoration(
                    isDense: true, labelText: 'Cidade', hintText: 'São Paulo'),
                validator: emptyValidator,
                onSaved: (t) => address.city = t,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                enabled: false,
                initialValue: address.state,
                decoration: const InputDecoration(
                    isDense: true, labelText: 'UF', hintText: 'SP'),
                validator: emptyValidator,
                onSaved: (t) => address.state = t,
              ),
            ),

          ]),
          SizedBox(
            height: 8,
          ),
          RaisedButton(
            color: Colors.black,
            disabledColor: Colors.grey,
            onPressed: () {

            },
            child: const Text(
              "Cálcular Frete",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
          TextFormField(
            enabled: true,
            initialValue: address.district,
            decoration: const InputDecoration(
                isDense: true, labelText: 'Bairro', hintText: 'Asa Norte'),
            validator: emptyValidator,
            onSaved: (t) => address.district = t,
          ),
        ],
      );
    }
    else {
      return Container();
    }
  }
}