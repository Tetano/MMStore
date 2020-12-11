import 'dart:math';

import 'package:flutter/material.dart';
import 'package:michellemirandastore/common/price_card.dart';
import 'package:michellemirandastore/models/cart_manager.dart';
import 'package:michellemirandastore/models/checkout_manager.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
              return ListView(
                children: [
                  PriceCard(
                    buttonText: 'Finalizar Pedido',
                    onPressed: () async {
                      checkoutManager.checkout(
                        onStockFail: (e) {
                          Navigator.popUntil(context, (route) => route.settings.name == '/cart');
                        }
                      );

                    },
                  )
                ],
              );
            },
          )),
    );
  }
}
