import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class DigitalPaymentView extends StatefulWidget {
  final List<String> paymentList;
  final List<Color> colorList;
  const DigitalPaymentView({Key key,@required this.paymentList,@required this.colorList}) : super(key: key);

  @override
  State<DigitalPaymentView> createState() => _DigitalPaymentViewState();
}

class _DigitalPaymentViewState extends State<DigitalPaymentView> {
  AutoScrollController scrollController;

  @override
  void initState() {
    scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.paymentList.map((_method) {
           return AutoScrollTag(
             controller: scrollController,
             key: ValueKey(widget.paymentList.indexOf(_method)),
             index: widget.paymentList.indexOf(_method),
             child: Consumer<OrderProvider>(
                  builder: (context, orderProvider, _) {
                  return InkWell(
                    radius: 10,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () async {
                      orderProvider.setPaymentMethod( orderProvider.paymentMethod == _method ? '' : _method);
                      await scrollController.scrollToIndex(widget.paymentList.indexOf(_method), preferPosition: AutoScrollPosition.middle);
                    },
                    child: Card(
                      color: orderProvider.paymentMethod == _method
                          ? Theme.of(context).primaryColor.withOpacity(0.1) : CardTheme.of(context).color,
                      shadowColor: orderProvider.paymentMethod == _method
                          ? Theme.of(context).primaryColor.withOpacity(0.2) : CardTheme.of(context).shadowColor,
                      child: Container(
                        width: 130, height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
                        ),
                        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT, horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  _method.replaceAll('_', ' ').toTitleCase(),
                                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                ),

                                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),


                                Image.asset(
                                    Images.getPaymentImage(_method), height: 20, width: 80,
                                  ),



                              ],),

                            if(orderProvider.paymentMethod == _method) Positioned.fill(
                              child:  Align(
                                  alignment: Alignment.centerRight, child: Transform(
                                transform: Matrix4.translationValues(0,10, 0),
                                child: Icon(
                                  Icons.check_circle, color: Theme.of(context).primaryColor,
                                  size: 25,
                                ),
                              )),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                }
              ),
           );
        }).toList(),
      ),
    );
  }
}
