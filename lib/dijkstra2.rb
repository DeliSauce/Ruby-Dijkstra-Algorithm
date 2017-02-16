require_relative 'graph'
require_relative 'priority_map'

# O(|V| + |E|*log(|V|)).
def dijkstra2(source)
  shortest_paths = Hash.new
  possible_paths = PriorityMap.new do |data_1, data_2|
    data_1[:cost] <=> data_2[:cost]
  end
  possible_paths[source] = { cost: 0, prev_edge: nil }

  until possible_paths.empty?
    current_vertex, data = possible_paths.extract
    shortest_paths[current_vertex] = data
    update_possible_paths(current_vertex, shortest_paths, possible_paths)
  end

  shortest_paths
end

def update_possible_paths(vertex, shortest_paths, possible_paths)
  path_to_vertex_cost = shortest_paths[vertex][:cost]

  vertex.out_edges.each do |edge|
    to_vertex = edge.to_vertex

    next if shortest_paths.has_key?(to_vertex)

    extended_path_cost = path_to_vertex_cost + edge.cost
    next if possible_paths.has_key?(to_vertex) &&
            possible_paths[to_vertex][:cost] <= extended_path_cost

    possible_paths[to_vertex] = {
      cost: extended_path_cost,
      last_edge: edge
    }
  end
end
