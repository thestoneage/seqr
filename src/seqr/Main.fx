package seqr;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.input.MouseEvent;
import javafx.scene.shape.Line;

var graph = Graph {}
var dispatch = Dispatch {}
var offset: Number = 0;


class Edge {
    var source: Node;
    var target: Node;
    var view: EdgeView;
}

class Graph {
    var nodes: Node[];
}

class Node {
    var edges: Edge[];
    var view: NodeView;
}

class EdgeView extends Line {
    var model: Edge;
}

class NodeView extends Circle {
    var model: Node;
}



class Dispatch {
    var sourceView: NodeView;
    var targetView: NodeView;
    function addNode(e:MouseEvent) {
        var node = Node {}
        var nodeView = NodeView {
                model: node
                blocksMouse: true
                centerX: e.sceneX
                centerY: e.sceneY
                radius: 15
                strokeWidth: 3
                stroke: Color.WHITE
                fill: Color.BLACK
        }
        nodeView.onMouseClicked = function(e: MouseEvent) {
            if (sourceView == null) {
                sourceView = nodeView;
            }
            else {
                targetView = nodeView;
                var edge = Edge {
                    source: sourceView.model
                    target: targetView.model
                }
                var edgeView = EdgeView {
                    model: edge
                    startX: bind edge.source.view.centerX
                    startY: bind edge.source.view.centerY
                    endX: bind edge.target.view.centerX
                    endY: bind edge.target.view.centerY
                    stroke: Color.WHITE
                    strokeWidth: 3
                    strokeDashArray: [3.0, 6.0]
                    strokeDashOffset: bind offset
                }
                edge.view = edgeView;
                insert edgeView into stage.scene.content;
                edge.source.view.toFront();
                edge.target.view.toFront();
                sourceView = null;
                targetView = null;
            }
        }
        nodeView.onMouseDragged = function(e: MouseEvent) {
            nodeView.centerX = e.sceneX;
            nodeView.centerY = e.sceneY;
        }
        nodeView.onMousePressed = function(e: MouseEvent) {
            nodeView.stroke = Color.RED;
        }
        nodeView.onMouseReleased = function(e: MouseEvent) {
            nodeView.stroke = Color.WHITE;
        }
        node.view = nodeView;
        insert nodeView into stage.scene.content;
    }
}


var stage: Stage =
Stage {
    title: "seqr"
    scene: Scene {
        width: 320
        height: 200
        content: [
            Rectangle {
                width: bind stage.scene.width
                height: bind stage.scene.height
                onMouseClicked: dispatch.addNode
            }
        ]
    }
}

javafx.animation.Timeline {
    repeatCount: javafx.animation.Timeline.INDEFINITE
    keyFrames: [
        at (0s) {offset => 18 tween javafx.animation.Interpolator.LINEAR }
        at (1s) {offset => 0  tween javafx.animation.Interpolator.LINEAR }
    ]
}.play();



