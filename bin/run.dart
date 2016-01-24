import "package:dslink/dslink.dart";

import "dart:math" as Math;
import 'dart:async';


LinkProvider link;
int lastNum;
SimpleNode valueNode;

Math.Random rng = new Math.Random();


main(List<String> args) async {
  //cust_id, site_id, collector_id,mover_id
  Map defaultNodes = {
  };
  
  link = new LinkProvider(
      args, 'sreamdb',
      defaultNodes: defaultNodes,isResponder: true);
  

  var rootnode = link.getNode('/');
  if (rootnode.children.isEmpty) {
    for (int i = 0; i < 20; ++i) {
      int x = i&7;
      var node = link.provider.getOrCreateNode('/node$i', true);
      //cust_id, site_id, collector_id, mover_id
      node.attributes['@cust_id'] = x >> 3;
      node.attributes['@site_id'] = x >> 2;
      node.attributes['@collector_id'] = x >> 1;
      node.attributes['@mover_id'] = x;
      node.configs[r'$type'] = 'number';
    }
  }
  
  new Timer.periodic(new Duration(milliseconds:50), (Timer t){
    rootnode.children.forEach((String key, SimpleNode node) {
      node.updateValue(rng.nextDouble());
    });
  });
  
  link.connect();
}
