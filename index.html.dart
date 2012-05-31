#import('dart:html');
#import('dart:json');
#import('splay.dart', prefix: "s");

s.SplayTree tree = null;
InputElement keyEl = null;
InputElement valueEl = null;

// redraw d3 tree
void redrawTree() {
  window.postMessage(tree.genD3(), '*');
  // save current tree in local storage
  window.localStorage['splayTree'] = JSON.stringify(tree.genJSON());
}

void insertClick(event) {
  try {
    int key = Math.parseInt(keyEl.value);
    int value = Math.parseInt(valueEl.value);

    tree.insert(key, value);
    redrawTree();
  }
  catch (BadNumberFormatException e) {
    print(e.toString());
  }
}

void removeClick(event) {
  try {
    int key = Math.parseInt(keyEl.value);
    
    tree.remove(key);
    redrawTree();
  }
  catch (BadNumberFormatException e) {
    print(e.toString());
  }
}

void searchClick(event) {
  try {
    int key = Math.parseInt(keyEl.value);
    
    var result = tree.search(key);
    valueEl.value = '' + result['val'];
    redrawTree();
  }
  catch (BadNumberFormatException e) {
    print(e.toString());
  }
}

void keyTextKeyDown(KeyboardEvent event) {
  // block non numbers
  if (event.keyCode != 8 
   && event.keyCode != 9 
   && event.keyCode != 37
   && event.keyCode != 38 
   && event.keyCode != 39 
   && event.keyCode != 40 
   && (event.keyCode < 48 || event.keyCode > 58)) {
    event.preventDefault();
  }
}

void main() {
  keyEl = document.query('#keyText');
  valueEl = document.query('#valueText');
  keyEl.on.keyDown.add(keyTextKeyDown);
  valueEl.on.keyDown.add(keyTextKeyDown);
  document.query('#insertBtn').on.click.add(insertClick);
  document.query('#removeBtn').on.click.add(removeClick);
  document.query('#searchBtn').on.click.add(searchClick);
  
  tree = new s.SplayTree();
  
  // check local storage
  String splayTreeStr = window.localStorage['splayTree'];
  var splayTreeJSON = null;
  if (splayTreeStr != null) {
    splayTreeJSON = JSON.parse(splayTreeStr);
    tree.parseJSON(splayTreeJSON);
  }
  else {
    // add default values
    splayTreeJSON = 
      {'key' : 5,
       'value' : 432,
       'left' : {
         'key' : 10,
         'value' : 33,
         'left' : null,
         'right' :null
        },
       'right' : {
         'key' : 1,
         'value' : 333,
         'left' : null,
         'right' :null
        }
      };
  }
  tree.parseJSON(splayTreeJSON);
  redrawTree();
}