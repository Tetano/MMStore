import 'package:flutter/material.dart';
import 'package:michellemirandastore/common/price_card.dart';
import 'package:michellemirandastore/models/cart_manager.dart';
import 'package:michellemirandastore/models/checkout_manager.dart';

import 'package:provider/provider.dart';

import 'components/credit_card_widget.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    void goToCartScreen() {
      Navigator.popUntil(context, (route) => route.settings.name == '/cart');
    }

    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text("Pagamento"),
            centerTitle: true,
          ),
          body: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              if(checkoutManager.loading){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      const SizedBox(height: 16,),
                      Text("Processando seu pagamento...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),)
                    ],
                  ),
                );
              }
              return Form(
                key: formKey,
                child: ListView(
                  children: [
                    CreditCardWidget(

                    ),
                    PriceCard(
                      buttonText: 'Finalizar Pedido',
                      onPressed: (){
                        if(formKey.currentState.validate()){
                          print("Enviado");
                        }
//                        checkoutManager.checkout(
//                          onSuccess: (order){
//                            //TODO: criar uma página de sucesso informando o produto e para onde ele está indo
//                            Navigator.popUntil(context, (route) => route.settings.name == '/');
//                            //context.read<PageManager>().setPage(2);
//                            Navigator.of(context).pushNamed('/confirmation', arguments: order);
//                          },
//                          onStockFail: (e) {
//                            goToCartScreen();
//
//                          }
//                        );

                      },
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
