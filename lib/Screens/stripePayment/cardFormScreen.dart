import 'package:esaa/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardFormScreen extends StatelessWidget {
  const CardFormScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('الدفع بالبطاقة الائتمانية'),
          backgroundColor: kPrimaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'بيانات البطاقة',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 20),
              CardFormField(
                controller: CardFormEditController(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: const Text('ادفع')),
            ],
          ),
        ));
  }
}
