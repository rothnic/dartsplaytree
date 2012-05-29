var flare =
{
 "name": "flare",
 "children": [
  {
   "name": "analytics",
   "children": [
    {
     "name": "cluster",
     "children": [
      {"name": "AgglomerativeCluster"},
      {"name": "CommunityStructure"}
     ]
    },
    {
     "name": "graph",
     "children": [
      {"name": "BetweennessCentrality"},
      {"name": "LinkDistance"}
     ]
    }
   ]
  }
 ]
};

var radius = 700 / 2;

var tree = d3.layout.tree()
    .size([360, radius - 120])
    .separation(function(a, b) { return (a.parent == b.parent ? 1 : 2) / a.depth; });

var diagonal = d3.svg.diagonal.radial()
    .projection(function(d) { return [d.y, d.x / 180 * Math.PI]; });

var redraw = function(json) {
    d3.selectAll("#chart > *").remove();
    var vis = d3.select("#chart").append("svg")
      .attr("width", radius * 2)
      .attr("height", radius * 2 - 150)
      .append("g")
      .attr("transform", "translate(" + radius + "," + radius + ")");
    
	var nodes = tree.nodes(json);
	
	var link = vis.selectAll("path.link")
	    .data(tree.links(nodes))
	  .enter().append("path")
	    .attr("class", "link")
	    .attr("d", diagonal);
	
	var node = vis.selectAll("g.node")
	    .data(nodes)
	  .enter().append("g")
	    .attr("class", "node")
	    .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")"; });
	
	node.append("circle")
	    .attr("r", 4.5);
	
	node.append("text")
	    .attr("dx", function(d) { return d.x < 180 ? 8 : -8; })
	    .attr("dy", ".31em")
	    .attr("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
	    .attr("transform", function(d) { return d.x < 180 ? null : "rotate(180)"; })
	    .text(function(d) { return d.name; });
}

redraw(flare);