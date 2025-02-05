class Node {
  Node? left, right, up, down;
  Node? column;
  int size = 0;

  Node() {
    left = this;
    right = this;
    up = this;
    down = this;
    column = null;
    size = 0;
  }

  void unlinkLR() {
    left!.right = right!;
    right!.left = left!;
  }

  void relinkLR() {
    left!.right = this;
    right!.left = this;
  }

  void unlinkUD() {
    up!.down = down!;
    down!.up = up!;
  }

  void relinkUD() {
    up!.down = this;
    down!.up = this;
  }

  Node cover() {
    unlinkLR();
    for (Node i = down!; i != this; i = i.down!) {
      for (Node j = i.right!; j != i; j = j.right!) {
        j.unlinkUD();
        j.column!.size--;
      }
    }
    return column!;
  }

  Node uncover() {
    for (Node i = up!; i != this; i = i.up!) {
      for (Node j = i.left!; j != i; j = j.left!) {
        j.column!.size++;
        j.relinkUD();
      }
    }
    relinkLR();
    return column!;
  }
}
