import 'dart:async';

import 'package:admin_flutter/plugin/input.dart';
import 'package:admin_flutter/primary_button.dart';
import 'package:admin_flutter/shop/supply_class_modify.dart';
import 'package:admin_flutter/style.dart';
import 'package:admin_flutter/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SupplyClass extends StatefulWidget {
  @override
  _SupplyClassState createState() => _SupplyClassState();
}

class _SupplyClassState extends State<SupplyClass> {
  BuildContext _context;
  ScrollController _controller;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List ajaxData = [];
  bool loading = true;
  Map industryClass = {};
  double width;
  String searchValue = '';

  void _onRefresh() {
    setState(() {
      getData(isRefresh: true);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _context = context;
    Timer(Duration(milliseconds: 200), () {
      getData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getData({isRefresh: false}) {
    setState(() {
      loading = true;
    });
    ajax('Adminrelas-shopsManage-getSupplyClass', {}, true, (res) {
      if (mounted) {
        setState(() {
          loading = false;
          ajaxData = res['data'];
          toTop();
        });
        industryClass = {'0': '顶级分类'};
        for (var o in res['data']) {
          industryClass['${o['class_id']}'] = o['class_name'];
        }
        if (isRefresh) {
          _refreshController.refreshCompleted();
        }
      }
    }, () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }, _context);
  }

  toTop() {
    _controller.animateTo(
      0,
      duration: Duration(milliseconds: 300), // 300ms
      curve: Curves.bounceIn, // 动画方式
    );
  }

  getPage(page) {
    if (loading) return;
    getData();
  }

  itemContainer(data, level) {
    return searchValue == '' || '${data['class_name']}'.contains(searchValue)
        ? Container(
            height: 66,
            child: Row(
              children: <Widget>[
                Container(
                  width: width / 5,
                  alignment: Alignment.centerRight,
                  child: Text('${data['sort']}'),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        level == 1
                            ? Text('')
                            : Icon(
                                Icons.keyboard_arrow_right,
                                color: CFColors.success,
                              ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupplyClassModify({
                                  'industryClass': industryClass,
                                  'item': {
                                    'parent-class': '${data['parent_class_id']}',
                                    'class-sort': '${data['sort']}',
                                    'goods-class-name': '${data['class_name']}',
                                    'class-comment': '${data['comments']}'
                                  }
                                }),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 6, bottom: 6),
                            child: Text(
                              '${data['class_name']}',
                              style: TextStyle(
                                color: CFColors.primary,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: width / 5,
                  child: Text('${data['comments'] ?? ''}'),
                ),
                Container(
                  width: 50,
                  child: InkWell(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context1, state) {
                              /// 这里的state就是setState
                              return AlertDialog(
                                title: Text(
                                  '信息',
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                        '确认删除 ${data['class_name']} ?',
                                        style: TextStyle(fontSize: CFFontSize.content),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('取消'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    child: Text('提交'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          ); //
                        },
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.delete,
                        color: CFColors.danger,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('供应商分类'),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
//          onLoading: _onLoading,
        child: ListView(
          controller: _controller,
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Input(
              label: '供应商分类',
              onChanged: (String val) {
                searchValue = val;
              },
              labelWidth: 100,
            ),
            Container(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  PrimaryButton(
                    onPressed: () {
                      getData();
                      FocusScope.of(context).requestFocus(
                        FocusNode(),
                      );
                    },
                    child: Text('搜索'),
                  ),
                  PrimaryButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupplyClassModify(
                            {
                              'industryClass': industryClass,
                              'item': null,
                            },
                          ),
                        ),
                      );
                    },
                    child: Text('新增分类'),
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: 10),
            ),
            loading
                ? Container(
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(),
                  )
                : Container(
                    child: ajaxData.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: Text('无数据'),
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: 6,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      width: width / 5,
                                      child: Text('排序'),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text('供应商分类'),
                                      ),
                                    ),
                                    Container(
                                      width: width / 5,
                                      alignment: Alignment.center,
                                      child: Text('备注'),
                                    ),
                                    Container(
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: Text('操作'),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: ajaxData.map<Widget>((item) {
                                  return Column(
                                    children: <Widget>[
                                      itemContainer(item, 1),
                                      item['children'].isEmpty
                                          ? Container(
                                              width: 0,
                                            )
                                          : Column(
                                              children: item['children'].map<Widget>((children) {
                                                return Container(
                                                  child: itemContainer(children, 2),
                                                );
                                              }).toList(),
                                            )
                                    ],
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                  ),
          ],
        ),
      ),
      floatingActionButton: CFFloatingActionButton(
        onPressed: toTop,
        child: Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}
