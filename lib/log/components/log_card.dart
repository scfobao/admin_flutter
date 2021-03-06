import 'package:admin_flutter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class LogCard extends StatelessWidget {
  /// 项目的列信息
  final columns;

  /// 数据
  final logs;

  final labelWidth;

  LogCard(this.columns, this.logs, {this.labelWidth});

  Widget msg(col, item) {
    return Container(
      child: col['lines'] == null
          ? Text(
              '${item[col['key']]}',
            )
          : Text(
              '${item[col['key']]}'.replaceAll(RegExp(r"\n", multiLine: true), ''),
              maxLines: col['lines'],
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.blue),
            ),
    );
  }

  dialog(String data, _context) {
    return showDialog<void>(
      context: _context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '参数解析',
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(_context).size.width - 100,
                  child: Html(
                    data: jsonMsg(data),
                    style: {
                      'p': Style(
                        padding: EdgeInsets.zero,
                      ),
                      'em': Style(
                        color: Color(0xff204a87),
                        fontStyle: FontStyle.normal,
                        fontSize: FontSize.smaller,
                      ),
                      'span': Style(
                        color: Color(0xff204a87),
                        fontStyle: FontStyle.normal,
                        fontSize: FontSize.smaller,
                      ),
                      'strong': Style(
                        color: Color(0xff4e9a06),
                        fontStyle: FontStyle.normal,
                        fontSize: FontSize.smaller,
                      ),
                      'i': Style(
                        color: Color(0xff333333),
                        fontStyle: FontStyle.normal,
                        fontSize: FontSize.smaller,
                      ),
                    },
                    shrinkWrap: true,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('关闭'),
              onPressed: () {
                Navigator.of(_context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: logs.map<Widget>((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffdddddd),
                width: 1,
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(left: 6, right: 6, top: 8, bottom: 8),
              child: Column(
                children: columns.map<Widget>((col) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: labelWidth ?? 80,
                          alignment: Alignment.centerRight,
                          child: Text('${col['title']}'),
                          margin: EdgeInsets.only(right: 10),
                        ),
                        Expanded(
                          flex: 1,
                          child: col['event'] == true
                              ? InkWell(
                                  onTap: () {
                                    dialog(item[col['key']], context);
                                  },
                                  child: msg(col, item),
                                )
                              : msg(col, item),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
