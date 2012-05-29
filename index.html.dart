#import('dart:html');
#import('splay.dart', prefix: "s");

s.SplayTree tree = null;

void testClick(event) {
  window.postMessage(tree.genD3(), '*');
}

void main() {
  document.query('#testbtn').on.click.add(testClick);
  
  tree = new s.SplayTree();
  tree.insert(4,1);
  print(tree.genJSON());
  tree.insert(3,2);
  print(tree.genJSON());
  tree.insert(5,3);
  print(tree.genJSON());
  
  print(tree.search(3));
  print(tree.genJSON());
  
  print(tree.genD3());
}