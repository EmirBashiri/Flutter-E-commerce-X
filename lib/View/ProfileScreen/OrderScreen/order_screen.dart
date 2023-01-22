import 'package:flutter/cupertino.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Constant/const.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/OrderScreen/bloc/order_bloc.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/OrderScreen/order_detail_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderBloc? orderBloc;
  @override
  void dispose() {
    orderBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = OrderBloc();
        orderBloc = bloc;
        bloc.add(OrderInitialEvent());
        return bloc;
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderInitialScreen) {
            final duplicateController = state.duplicateController;
            final colors = duplicateController.colors;
            final textStyle = duplicateController.textStyle;
            return DuplicateTemplate(
              colors: colors,
              textStyle: textStyle,
              title: "Order history",
              child: ListView.builder(
                physics: duplicateController.uiDuplicate.defaultScroll,
                itemCount: state.orderHistoryList.length,
                itemBuilder: (context, index) {
                  final order = state.orderHistoryList[index];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.gray,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order : ${order.productList[0].id}",
                                style: textStyle.bodyNormal,
                              ),
                              CupertinoButton(
                                child: Text(
                                  "View detail",
                                  style: textStyle.bodyNormal
                                      .copyWith(color: colors.primary),
                                ),
                                onPressed: () {
                                  Get.to(OrderDetailScreen(
                                      productList: order.productList));
                                },
                              )
                            ],
                          ),
                        ),
                        orderHistoryItem(
                            rightTitle: order.time.toString().substring(0, 16),
                            leftTitle: "Date :",
                            leftStyle: textStyle.bodyNormal,
                            rightStyle: textStyle.bodyNormal
                                .copyWith(color: colors.captionColor)),
                        orderHistoryItem(
                            rightTitle: order.totalPrice,
                            leftTitle: "Amount :",
                            leftStyle: textStyle.bodyNormal,
                            rightStyle: textStyle.bodyNormal
                                .copyWith(color: colors.captionColor)),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (state is OrderEmpty) {
            final duplicateController = state.duplicateController;
            return EmptyScreen(
                colors: duplicateController.colors,
                textStyle: duplicateController.textStyle,
                title: "Order history",
                content: "Your order history is empty",
                lottieName: emptyListLottie);
          } else if (state is OrderLoading) {
            return const CustomLoading();
          }
          return Container();
        },
      ),
    );
  }

  Widget orderHistoryItem(
      {required String rightTitle,
      required String leftTitle,
      required TextStyle leftStyle,
      required TextStyle rightStyle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftTitle,
            style: leftStyle,
          ),
          Text(
            rightTitle,
            style: rightStyle,
          )
        ],
      ),
    );
  }
}
