import 'dart:convert';

import 'package:admin_flutter/plugin/select.dart';
import 'package:admin_flutter/plugin/user_plugin.dart';
import 'package:admin_flutter/primary_button.dart';
import 'package:admin_flutter/style.dart';
import 'package:admin_flutter/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateTaskPricing extends StatefulWidget {
  @override
  _CreateTaskPricingState createState() => _CreateTaskPricingState();
}

class _CreateTaskPricingState extends State<CreateTaskPricing> {
  Map param = {'user': {}, 'task_type': '104', 'subsidy': 0};
  Map taskType = {
    "104": "设计任务",
  };

  BuildContext _context;

  @override
  void initState() {
    super.initState();
    _context = context;
  }

  save() {
    bool flag = true;
    List msg = [];
    if (param['user'].isEmpty) {
      flag = false;
      msg.add('用户');
    }

    if (param['price'] == null || param['price'] == '0' || param['price'] == '') {
      flag = false;
      msg.add('定价标准');
    }

    if (param['subsidy'] == null || param['subsidy'] == '') {
      flag = false;
      msg.add('平台补贴');
    }

    if (flag) {
      ajax(
        'Adminrelas-taskManage-makeTaskPrice',
        {
          'price': 1,
          'subsidy': 1,
          'task_type': 104,
          'user_id': param['user'][param['user'].keys.toList()[0]]['user_id'],
        },
        true,
        (data) {
          Navigator.pop(context, true);
        },
        () {},
        _context,
      );
    } else {
      Fluttertoast.showToast(
        msg: '请填写 ${msg.join(', ')}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新增任务定价'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '* ',
                        style: TextStyle(color: CFColors.danger),
                      ),
                      Text('用户')
                    ],
                  ),
                  margin: EdgeInsets.only(right: 10),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    height: 32,
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: param['user'].keys.toList().map<Widget>((key) {
                        return Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  '${param['user'][key]['login_name']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  color: Color(0xffeeeeee),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        param['user'].remove(key);
                                      });
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                PrimaryButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPlugin(
                          userCount: 1,
                          selectUsersData: jsonDecode(
                            jsonEncode(param['user']),
                          ),
                        ),
                      ),
                    ).then((val) {
                      if (val != null) {
                        setState(() {
                          param['user'] = jsonDecode(jsonEncode(val));
                        });
                      }
                    });
                  },
                  child: Text('选择用户'),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Container(
                width: 80,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '* ',
                      style: TextStyle(color: CFColors.danger, fontSize: CFFontSize.content),
                    ),
                    Text(
                      '定价标准',
                      style: TextStyle(fontSize: CFFontSize.content),
                    )
                  ],
                ),
                margin: EdgeInsets.only(right: 10),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 34,
                  child: TextField(
                    style: TextStyle(fontSize: CFFontSize.content),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: '${param['price'] ?? ''}',
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: '${param['price'] ?? ''}'.length,
                          ),
                        ),
                      ),
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                        left: 15,
                        right: 15,
                      ),
                    ),
                    onChanged: (String val) {
                      setState(() {
                        param['price'] = val;
                      });
                    },
                  ),
                ),
              ),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Container(
                width: 80,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '* ',
                      style: TextStyle(color: CFColors.danger, fontSize: CFFontSize.content),
                    ),
                    Text(
                      '平台补贴',
                      style: TextStyle(fontSize: CFFontSize.content),
                    )
                  ],
                ),
                margin: EdgeInsets.only(right: 10),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 34,
                  child: TextField(
                    style: TextStyle(fontSize: CFFontSize.content),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: '${param['subsidy'] ?? ''}',
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: '${param['subsidy'] ?? ''}'.length,
                          ),
                        ),
                      ),
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                        left: 15,
                        right: 15,
                      ),
                    ),
                    onChanged: (String val) {
                      setState(() {
                        param['subsidy'] = val;
                      });
                    },
                  ),
                ),
              ),
            ]),
          ),
          Select(
            selectOptions: taskType,
            selectedValue: param['task_type'],
            label: '任务类型',
            onChanged: (val) {
              setState(() {
                param['task_type'] = val;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Container(
                width: 80,
                margin: EdgeInsets.only(right: 10),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    PrimaryButton(
                      onPressed: save,
                      child: Text('添加'),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
