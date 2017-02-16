require_relative 'graph'

# O(|V|**2 + |E|).
def dijkstra1(source)
  shortest_paths = Hash.new
  possible_paths = { source => { cost: 0, prev_edge: nil } }

  until possible_paths.empty?
    min = nil
    current_vertex = nil
    possible_paths.each do |vertex, data|
      if min.nil? || data[:cost] < min
        min = data[:cost]
        current_vertex = vertex
      end
    end

    shortest_paths[current_vertex] = possible_paths[current_vertex]
    possible_paths.delete(current_vertex)
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
