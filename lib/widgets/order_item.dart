import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;
  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          if (_expanded)
            Container(
              height: min(widget.order.products.length * 50.0, 100),
              child: ListView(
                children: widget.order.products
                    .map((element) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Text(element.title),
                              Spacer(),
                              Chip(
                                label: Text(
                                  '${element.quantity}X${element.price}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
