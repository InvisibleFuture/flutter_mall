import 'package:flutter/material.dart';
import 'package:mall/constant/app_dimens.dart';
import 'package:mall/constant/app_strings.dart';
import 'package:mall/constant/text_style.dart';
import 'package:mall/model/home_entity.dart';
import 'package:mall/utils/navigator_util.dart';
import 'package:mall/utils/shared_preferences_util.dart';
import 'package:mall/utils/toast_util.dart';
import 'package:mall/view_model/tab_home_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabHomeCoupon extends StatelessWidget {
  List<HomeModelCouponlist> _homeModelCouponlist;
  TabHomeViewModel _tabHomeViewModel;

  TabHomeCoupon(this._homeModelCouponlist, this._tabHomeViewModel);

  @override
  Widget build(BuildContext context) {
    return _homeModelCouponlist.length == 0
        ? Container()
        : Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(AppDimens.DIMENS_30), top: ScreenUtil().setHeight(AppDimens.DIMENS_30), bottom: ScreenUtil().setHeight(AppDimens.DIMENS_10)),
                alignment: Alignment.centerLeft,
                child: Text(AppStrings.COUPON_AREA, style: FMTextStyle.color_333333_size_42_bold),
              ),
              ListView.builder(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  //禁止滑动
                  shrinkWrap: true,
                  //Vertical viewport was given unbounded height.  Column 中且套GridView、ListView的问题
                  itemCount: _homeModelCouponlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _getCouponView(_homeModelCouponlist[index], context);
                  })
            ],
          );
  }

  Widget _getCouponView(HomeModelCouponlist couponEntity, BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () => _receiveCoupon(couponEntity.id, context),
        child: Card(
          color: Colors.pink,
          margin: EdgeInsets.all(ScreenUtil().setWidth(AppDimens.DIMENS_30)),
          child: Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(AppDimens.DIMENS_20), bottom: ScreenUtil().setHeight(AppDimens.DIMENS_20)),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${couponEntity.discount}${AppStrings.MONEY_UNIT}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(couponEntity.name, style: TextStyle(color: Colors.black54, fontSize: 20.0)),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                      ),
                      Text(
                        "${AppStrings.FULL}${couponEntity.min}${AppStrings.USE}",
                        style: TextStyle(fontSize: 20, color: Colors.white70),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                      ),
                      Text(
                        "${AppStrings.VALIDITY}${couponEntity.days}${AppStrings.DAY}",
                        style: TextStyle(
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _receiveCoupon(int id, BuildContext context) {
    SharedPreferencesUtil.getInstance().getString(AppStrings.TOKEN).then((response) {
      if (response != null) {
        _tabHomeViewModel.receiveCoupon(id).then((response) {
          if (response) {
            ToastUtil.showToast(AppStrings.RECEIVE_COUPON_SUCCESS);
          }
        });
      } else {
        NavigatorUtil.goLogin(context);
      }
    });
  }
}
