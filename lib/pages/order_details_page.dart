import 'package:flutter/material.dart';
import 'package:golekos/models/product.dart';
import 'package:golekos/theme.dart';
import 'package:golekos/widgets/order_summary_row.dart';
import 'package:intl/intl.dart';

enum payment { transfer, onsite }

class OrderDetails extends StatefulWidget {
  OrderDetails({this.object});

  final Map<String, dynamic> object;
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  payment paymentSelect = payment.onsite;

  String paymentSelected = 'onsite';
  String img = "https://via.placeholder.com/150";
  String kostName = "Product name";
  String type = "Product type";
  String owner = "Product owner";
  String phone = "Product owner phone";
  int price = 0;
  selectAPayment(value) {
    switch (paymentSelect) {
      case payment.transfer:
        paymentSelected = 'transfer';
        setState(() {});
        break;
      case payment.onsite:
        paymentSelected = 'onsite';
        setState(() {});
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    getKost(widget.object['kostID']).then((value) {
      setState(() {
        kostName = value.name;
        img = value.imageUrl;
        type = value.type;
        owner = value.owner;
        phone = value.ownerPhone;
        price = value.price;
      });
    });
  }

  Future<Product> getKost(int id) async {
    var productById = await Product.getProductById(id);
    return productById;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0", "en_US");
    return Scaffold(
      backgroundColor: Color(0xffF2F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Column(
              children: [
                // Title Order Section

                AppBar(
                  centerTitle: true,
                  title: Text(
                    'ORDER #12345678',
                    style: orderBold.copyWith(color: orderBlack),
                  ),
                  leading: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: orderGrey,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),

                SizedBox(
                  height: 35,
                ),

                // Order Summary Section

                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order summary',
                        style: orderBold.copyWith(color: orderBlack),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // Kost image and details

                      Row(
                        children: [
                          Image.network(
                            img ?? 'https://via.placeholder.com/150',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                child: Text(
                                  kostName ?? "name",
                                  maxLines: 4,
                                  style:
                                      orderRegular.copyWith(color: orderBlack),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                type ?? "type",
                                style: orderLight.copyWith(
                                    fontSize: 12, color: Color(0xffA5A5A5)),
                              ),
                            ],
                          )
                        ],
                      ),

                      SizedBox(
                        height: 22,
                      ),
                      Divider(
                        color: Color(0xffd8d8d8),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // Order Details

                      OrderRow(
                        title: 'Owner',
                        value: owner ?? "owner",
                      ),
                      OrderRow(
                        title: 'Phone',
                        value: phone ?? "phone",
                      ),

                      Divider(
                        color: Color(0xffd8d8d8),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      OrderRow(
                          title: 'Rent Month',
                          value: '${widget.object['long_rented']} Months'),
                      OrderRow(
                        title: 'Rental Price /month',
                        value: 'IDR ${currencyFormat.format(price) ?? 0}',
                      ),
                      OrderRow(
                        title: 'Total Price',
                        value:
                            'IDR ${currencyFormat.format(widget.object['total']) ?? 0}',
                      ),
                      OrderRow(
                        title: 'Phone',
                        value: widget.object['phone'],
                      ),
                      OrderRow(
                        title: 'Tax',
                        value: '10%',
                      ),
                      OrderRow(
                        title: 'Payment Status',
                        value: 'Not Yet Paid',
                        isPaymentStatus: true,
                      ),
                      Divider(
                        color: Color(0xffd8d8d8),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      OrderRow(
                        title: 'Total',
                        value:
                            'IDR ${currencyFormat.format(widget.object['total'] + (widget.object['total'] * 0.1)) ?? 0}',
                        isTotal: true,
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                // Payment Section

                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Method',
                        style: orderBold.copyWith(color: Color(0xff000000)),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: Stack(
                                      clipBehavior: Clip.hardEdge,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Choose payment',
                                              style: orderBold.copyWith(
                                                  color: orderBlack),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  paymentSelect =
                                                      payment.transfer;
                                                  selectAPayment(paymentSelect);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/payment/visa.png',
                                                        width: 43,
                                                        height: 26),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text('Bank transfer',
                                                        style: orderMedium
                                                            .copyWith(
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xff000000))),
                                                  ],
                                                )),
                                            Divider(
                                              color: Colors.black12,
                                              height: 2,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  paymentSelect =
                                                      payment.onsite;
                                                  selectAPayment(paymentSelect);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/payment/visa.png',
                                                        width: 43,
                                                        height: 26),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text('Onsite',
                                                        style: orderMedium
                                                            .copyWith(
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xff000000))),
                                                  ],
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/payment/visa.png',
                                width: 43,
                                height: 26,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (paymentSelected == 'onsite')
                                        ? 'On site'
                                        : 'Bank transfer',
                                    style: orderMedium.copyWith(
                                        fontSize: 12, color: Color(0xff000000)),
                                  ),
                                  Text(
                                    (paymentSelected == 'onsite')
                                        ? 'No details needed'
                                        : '••••   ••••   ••••   1996',
                                    style: orderSemiBold.copyWith(
                                        fontSize: 10, color: Color(0xff000000)),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xff8C8C8C),
                              ),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          )),

                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Color(0xffd4d4d4),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // Promo code

                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('PAY'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffFFC33A),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            textStyle: orderMedium.copyWith(
                                fontSize: 12, color: Color(0xff414B5A)),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),

                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
