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

var width = 800,
    height = 800;
 
var cluster = d3.layout.cluster()
    .size([height, width - 160]);
 
var diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.x, d.y]; });

var redraw = function(json) {
    d3.selectAll("#chart > *").remove();
    var vis = d3.select("#chart")
                  .append("svg")
                  .attr("width", width)
                  .attr("height", height)
                .append("g")
                  .attr("transform", "translate(0, 40)");
    
	var nodes = cluster.nodes(json);
	
    var link = vis.selectAll("path.link")
       .data(cluster.links(nodes))
     .enter().append("path")
       .attr("class", "link")
       .attr("d", diagonal);

    var node = vis.selectAll("g.node")
       .data(nodes)
     .enter().append("g")
       .attr("class", "node")
       .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })

    node.append("circle")
       .attr("r", 4.5);

    node.append("text")
       .attr("dx", function(d) { return d.children ? -8 : 8; })
       .attr("dy", 3)
       .attr("text-anchor", function(d) { return d.children ? "end" : "start"; })
       .text(function(d) { return d.name; });
}

//redraw(flare);
