#import('dart:html');
#import('splay.dart', prefix: "s");

void main() {
  s.SplayTree tree = new s.SplayTree();
  tree.insert(4,1);
  print(tree.genJSON());
  tree.insert(3,2);
  print(tree.genJSON());
  tree.insert(5,3);
  print(tree.genJSON());
  
  print(tree.search(3));
  print(tree.genJSON());
}