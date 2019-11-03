import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../modules/autoload.dart';
import '../modules/moduleA.dart';
import '../modules/moduleC.dart';
import '../modules/state_builder3.dart';
import 'page1.dart';

final Stream mergedStream = combineAll([moduleA.stream, moduleB.stream]);

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  incrementA() => moduleA.actions.increment.dispatch(null);

  incrementB() => moduleB.actions.increment.dispatch(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
            )),
            Text(title)
          ],
        ),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StateBuilder3<ModuleAState, ModuleAState, ModuleCState>(
                    service1: moduleA, // any stream will trigger rebuild
                    service2: moduleB,
                    service3: moduleC,
                    builder: (BuildContext ctx, ModuleAState s1,
                        ModuleAState s2, ModuleCState s3) {
                      if (s1 == null || s2 == null || s3 == null) {
                        return CircularProgressIndicator();
                      }

                      return Column(children: [
                        TextField(
                            decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        )),
                        Text(
                          'State Connector is\n $StateBuilder3',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
//                      Divider(color: Colors.brown),
                        Text('module A has counter: ${s1.value}'),
                        Text('module B has counter: ${s2.value}'),
//                      Divider(color: Colors.brown),
                        Text('module C watches A and B'),
                        Text('A + B = ${s1.value} + ${s2.value} = ${s3.value}'),
                      ]);
                    }),
              ])),
      persistentFooterButtons: <Widget>[
        FlatButton(
          child: Text('Page 1'),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => Page1())),
        ),
        FlatButton(
          child: Text('inc A'),
          onPressed: incrementA,
        ),
        OutlineButton(
          child: Text('inc B'),
          onPressed: incrementB,
        )
      ],
    );
  }
}
