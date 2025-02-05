import 'node.dart';

class DancingLinks {
  Node root = Node();
  List<Node> columns = [];

  void build(List<List<int>> matrix) {
    int numRows = matrix.length;
    int numCols = matrix[0].length;

    // Create header nodes for each column
    for (int j = 0; j < numCols; j++) {
      Node column = Node();
      columns.add(column);

      column.left = root.left!;
      column.right = root;
      root.left!.right = column;
      root.left = column;

      column.column = column;
    }

    // Create nodes for each cell that contains a 1
    for (int i = 0; i < numRows; i++) {
      Node? prev;
      Node? first;

      for (int j = 0; j < numCols; j++) {
        if (matrix[i][j] == 1) {
          Node node = Node();

          node.column = columns[j];
          node.up = node.column?.up!;
          node.down = node.column;
          node.column?.up!.down = node;
          node.column?.up = node;

          if (prev == null) {
            first = node;
          } else {
            node.left = prev;
            node.right = prev.right!;
            prev.right!.left = node;
            prev.right = node;
          }

          prev = node;
        }
      }

      if (prev != null) {
        first!.left = prev;
        prev.right = first;
      }
    }
  }

  bool search(List<Node> solution) {
    if (root.right == root) {
      return true;
    }

    Node column = chooseColumn();
    column.cover();

    for (Node row = column.down!; row != column; row = row.down!) {
      solution.add(row);
      for (Node node = row.right!; node != row; node = node.right!) {
        node.column!.cover();
      }
      if (search(solution)) {
        return true;
      }
      solution.removeLast();
      for (Node node = row.left!; node != row; node = node.left!) {
        node.column!.uncover();
      }
    }

    column.uncover();
    return false;
  }

  Node chooseColumn() {
    Node column = root.right!;
    for (Node c = column.right!; c != root; c = c.right!) {
      if (c.size < column.size) {
        column = c;
      }
    }
    return column;
  }
}
