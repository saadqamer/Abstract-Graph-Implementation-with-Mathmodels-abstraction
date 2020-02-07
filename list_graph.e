note
	description: "[
			Directed Graph implemented as Adjacency List 
		    in generic parameter G that is Comparable:
				vertices: LIST[VERTEX[G]]
				edges: ARRAY [EDGE [G]]
				-- commands
				add_edge (e: EDGE [G])
				add_vertex (v: VERTEX [G])
				remove_edge (a_edge: EDGE [G])
				remove_vertex (a_vertex: VERTEX [G])
				
				A vertex has outgoing and incoming edges.
				An edge has a source vertex and destination vertex.
				Vertices and Edges must be attached.
	]"
	ca_ignore: "CA023", "CA023: Undeed parentheses", "CA017", "CA107: Empty compound after then part of if"
	date: "$Date$"
	revision: "$Revision$"

class
	LIST_GRAPH [G -> COMPARABLE]

inherit

	ITERABLE [VERTEX [G]]
		redefine
			out
		end

	DEBUG_OUTPUT
		redefine
			out
		end

create
	make_empty, make_from_array

feature -- Model

	model: COMPARABLE_GRAPH [VERTEX [G]]
			-- abstraction function
			-- This must be implemented so that the contracts will work properly
			-- You must find a way to translate the `LIST_GRAPH` implementation into the mathematical
			-- model representation of a graph: `COMPARABLE_GRAPH` (which inherits from `GRAPH`).
		do
			create Result.make_empty
				-- To Do.
			across
				vertices as v
			loop
				Result.vertices.extend (v.item)
			end

			across
				edges as e
			loop
				Result.edges.extend (create {PAIR[VERTEX[G], VERTEX[G]]}.make (e.item.source, e.item.destination))
			end


		ensure
			comment ("Establishes model consistency invariants")
		end

feature {NONE} -- Initialization

	make_empty
			-- create empty graph
		do
			create {LINKED_LIST [VERTEX [G]]} vertices.make
			vertices.compare_objects
		ensure
			mm_empty_graph: model.is_empty
		end

	get_vertex (g: G): detachable VERTEX [G]
			-- Return the associated vertext object storing `g`, if any.
			-- Note. In the invariant, it is asserted that all vertices are unique.
		do

				-- To Do.
				across
					vertices as v
				loop
					if v.item.item ~ g then
						Result := v.item
					end
				end

		ensure
			mm_attached: attached Result implies model.has_vertex (create {VERTEX [G]}.make (g))
			mm_not_attached: not attached Result implies not model.has_vertex (create {VERTEX [G]}.make (g))
		end

	make_from_array (a: ARRAY [TUPLE [src: G; dst: G]])
			-- create a new graph from an array of tuples
			-- each tuple stores contents for the source and the destination
		require
			a.object_comparison
		local
			l_v1, l_v2: VERTEX [G]
			l_e: EDGE [G]
		do
			create {LINKED_LIST [VERTEX [G]]} vertices.make
			vertices.compare_objects
			across
				a as tuple
			loop
				if attached get_vertex (tuple.item.src) as v1 then
					l_v1 := v1 -- so that we do not reset the `income` and `outgoing` lists of the existing vertex
				else
					create l_v1.make (tuple.item.src)
				end
				if attached get_vertex (tuple.item.dst) as v2 then
					l_v2 := v2 -- so that we do not reset the `income` and `outgoing` lists of the existing vertex
				else
					create l_v2.make (tuple.item.dst)
				end
				create l_e.make (l_v1, l_v2)
				if not has_vertex (l_v1) then
					add_vertex (l_v1)
				end
				if not has_vertex (l_v2) then
					add_vertex (l_v2)
				end
				if not has_edge (l_e) then
					add_edge (l_e)
				end
			end
		ensure
			mm_edges:
				-- ∀ [src, dst] ∈ a : [src, dst] ∈ model.edges
				across a as l_edge all
					model.has_edge ([create {VERTEX [G]}.make (l_edge.item.src),
												 create {VERTEX [G]}.make (l_edge.item.dst)])
				end

			mm_vertices:
				-- ∀ [src, dst] ∈ a : src ∈ model.vertices ∧ dst ∈ model.vertices
				across a as l_edge all
					model.has_vertex (create {VERTEX [G]}.make (l_edge.item.src))
					and
					model.has_vertex (create {VERTEX [G]}.make (l_edge.item.dst))
				end
		end

feature -- Iterator Pattern

	new_cursor: ITERATION_CURSOR [VERTEX [G]]
			-- returns a new cursor for current graph
		do
			Result := vertices.new_cursor
		end

feature -- queries

	vertices: LIST [VERTEX [G]]
			-- list of vertices

	vertex_count: INTEGER
			-- number of vertices
		do
				-- To Do.
				Result := vertices.count
		ensure
			mm_vertex_count: Result = model.vertex_count
		end

	edge_count: INTEGER
			-- number of outgoing edges
		do
				-- To Do.
				across
					vertices as l_vertex
				loop
				Result := Result + l_vertex.item.outgoing_edge_count
				end
		ensure
			mm_edge_count: Result = model.edge_count
		end

	is_empty: BOOLEAN
			-- does the graph contain no vertices?
		do
				-- To Do.
				Result := vertices.is_empty
		ensure
			comment ("See invariant empty_consistency")
			mm_is_empty: Result = model.is_empty
		end

	has_vertex (a_vertex: VERTEX [G]): BOOLEAN
			-- does the current graph have `a_vertex`?
		do
				-- To Do.
				Result := vertices.has (a_vertex)
		ensure
			mm_has_vertex: Result = model.has_vertex (a_vertex)
		end

	has_edge (a_edge: EDGE [G]): BOOLEAN
			-- does the current graph have `a_edge`?
				-- To Do.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > vertex_count or Result
			loop
				if vertices [i].has_outgoing_edge (a_edge) then
					Result := True
				end
				i := i + 1
			end
		ensure
			mm_has_edge: Result = model.has_edge ([a_edge.source, a_edge.destination])
		end

	edges: ARRAY [EDGE [G]]
			-- array of all outgoing edges
		do
			create Result.make_empty
				-- To Do.
			across
						vertices as l_vertex
					loop
						across
							l_vertex.item.outgoing as l_edge
						loop
							Result.force (l_edge.item, Result.count + 1)
						end
					end
					Result.compare_objects
		ensure
			mm_edges_count: Result.count = model.edge_count
			mm_edges_membership: across Result as l_edge all model.has_edge ([l_edge.item.source, l_edge.item.destination]) end
		end

feature -- Advanced Queries

	topologically_sorted: ARRAY [VERTEX [G]]
			-- Return an array <<..., vi, ..., vj, ...>> such that
			-- (vi, vj) in edges => i < j
			-- A topological sort is performed.
		require
			is_acyclic: model.is_acyclic
		local
			in_degree: ARRAY[INTEGER]
			q: QUEUE[VERTEX[G]]
			front: VERTEX[G]
		do
			create Result.make_empty
			Result.compare_objects
			create in_degree.make_empty
			create q.make_empty
				-- To Do.
		from
			across
				1 |..| vertices.count is i
			loop

				in_degree.force (vertices[i].incoming_edge_count, in_degree.count + 1)
				if in_degree[i] = 0 then
					q.enqueue (vertices[i])
				end
			end
		until
			q.is_empty
		loop
			front := q.first
			q.dequeue
			Result.force (front, Result.count + 1)
			across
				front.outgoing as f_o
			loop
				in_degree[vertices.index_of (f_o.item.destination, 1)] := in_degree[vertices.index_of (f_o.item.destination, 1)] - 1
				if in_degree[vertices.index_of (f_o.item.destination, 1)] = 0 then
					q.enqueue (f_o.item.destination)
				end
			end
		end

		ensure
			mm_sorted: Result ~ model.topologically_sorted.as_array
		end

	is_topologically_sorted (seq: like topologically_sorted): BOOLEAN
			-- does `seq` represent a topological order of the current graph?
		do
				-- To Do.
		Result :=
					-- consistent_counts
					seq.count = vertices.count
					and then
					-- all_vertices_covered
					across
						seq as v
					all
						vertices.has (v.item)
					end
					and then
					-- ∀i,j∈ 1..seq.count : i = j ∨[seq[i], seq[j]] ∈ edges ⇒ i < j
					-- sorted:
					across
						1 |..| seq.count as i
					all
						across
							1 |..| seq.count as j
						all
							i.item = j.item or else (edges.has ([seq[i.item], seq[j.item]]) implies i.item < j.item)
						end
					end
		end

feature -- advanced queries (Lab 1)

	reachable (src: VERTEX [G]): ARRAY [VERTEX [G]]
			-- Starting with vertex `src`, return the list of vertices visited via a breadth-first search.
			-- It is required that `outgoing_sorted` is used for each vertex to reach out to its neighbouring vertices,
			-- so that the resulting array is uniquely ordered.
			-- Note. `outgoing_sorted` is somewhat analogous to `adjacent` in the abstract algorithm documentation of BFS.
		require
			mm_existing_source: model.has_vertex (src)
	local
			-- Include declarations for local variables used here
			reachable_queue: QUEUE[VERTEX[G]]
			front: VERTEX[G]
			visited: ARRAY[VERTEX[G]]
		do
				-- To Do.
			create reachable_queue.make_empty
			create visited.make_empty
			from
				visited.force (src, visited.count +1)
				reachable_queue.enqueue (src)
			until
				reachable_queue.is_empty
			loop
				front := reachable_queue.first
				reachable_queue.dequeue
				across
					front.outgoing_sorted as x
				loop
					if not visited.has (x.item.destination) then
						visited.force (x.item.destination, visited.count + 1)
						reachable_queue.enqueue (x.item.destination)
					end
				end
			end

			Result := visited
			Result.compare_objects
		ensure
			mm_reachable_in_model: model.reachable (src).as_array ~ Result
		end

feature -- commands

	add_vertex (a_vertex: VERTEX [G])
			-- adds `a_vertex` to current graph
		require
			mm_non_existing_vertex: not model.has_vertex (a_vertex)
		do
				-- To Do.
				vertices.extend (a_vertex)
		ensure
			mm_vertex_added: model ~ (old model.deep_twin) + a_vertex
		end

	add_edge (a_edge: EDGE [G])
			-- adds `a_edge` to the current graph
		require
			mm_existing_source_vertex: model.has_vertex (a_edge.source)
			mm_existing_destination_vertex: model.has_vertex (a_edge.destination)
			mm_non_existing_edge: not model.has_edge ([a_edge.source, a_edge.destination])
		local
				src, dst: VERTEX [G]
				new_edge: EDGE [G]

			do
					-- To Do.

			if attached {VERTEX[G]} get_vertex(a_edge.source.item) as e then

				if attached {VERTEX[G]} get_vertex(a_edge.destination.item) as v then
						src := e
						dst := v
						create new_edge.make (src, dst)
						dst.incoming.force(new_edge)
						src.outgoing.force (new_edge)
				end
			end

		ensure
			mm_edge_added: model ~ (old model.deep_twin) |\/| [a_edge.source, a_edge.destination]
		end

	remove_edge (a_edge: EDGE [G])
			-- removes `a_edge` from the current graph
		require
			mm_existing_edge: model.has_edge ([a_edge.source, a_edge.destination])
		local
				src, dst: VERTEX [G]
			do


				-- To Do.
			if attached {VERTEX[G]} get_vertex(a_edge.source.item) as e then


						if attached {VERTEX[G]} get_vertex(a_edge.destination.item) as v then
								src := e
								dst := v
								src.outgoing.prune_all(a_edge)
								dst.outgoing.prune_all (a_edge)
								src.incoming.prune_all (a_edge)
								dst.incoming.prune_all (a_edge)
						end
			end

		ensure
			mm_edge_removed: model ~ (old model.deep_twin) |\ [a_edge.source, a_edge.destination]
		end

	remove_vertex (a_vertex: VERTEX [G])
			-- removes `a_vertex` from the current graph
		require
			mm_existing_vertex: model.has_vertex (a_vertex)
		local
				l_edge: EDGE [G]
				v: VERTEX [G]
			do
				-- To Do.

				across
					vertices as a_v
				loop
					across
						a_v.item.outgoing as a_v_o
						loop
							if a_v_o.item.destination ~ a_vertex then
								remove_edge(a_v_o.item)
							end
				end
					-----------
				across
						a_v.item.incoming as a_v_i
					loop
						if a_v_i.item.source ~ a_vertex then
							remove_edge(a_v_i.item)
						end
					end
				end

				vertices.prune_all (a_vertex)
		ensure
			mm_vertex_removed: model ~ (old model.deep_twin) - a_vertex
		end

feature -- out

	comment (s: STRING): BOOLEAN
		do
			Result := true
		end

	debug_output: STRING
			-- returns a string representation of current graph
			-- in the debugger
		do
			Result := ""
			across
				vertices as l_vertex
			loop
				Result := Result + "[" + l_vertex.item.debug_output + "]"
			end
		end

	out: STRING
			-- returns a string representation of current graph
		do
			Result := ""
			across
				vertices as l_vertex
			loop
				Result := Result + "[" + l_vertex.item.out + "]"
			end
		end

feature -- agent functions

	vertices_edge_count: INTEGER
			-- total number of incoming and outgoing edges of all vertices in `vertices`
			-- Result = (Σv ∈ vertices : v.outgoing_edge_count + v.incoming_edge_count)
		do
			Result := vertices_outgoing_edge_count + vertices_incoming_edge_count
		end

	vertices_outgoing_edge_count: INTEGER
			-- total number of outgoing edges of all vertices in `vertices`
			-- Result = (Σv ∈ vertices : v.outgoing_edge_count)
		do
			Result := {NUMERIC_ITERABLE [VERTEX [G]]}.sumf (vertices, agent  (v: VERTEX [G]): INTEGER
				do
					Result := v.outgoing_edge_count
				end)
		end

	vertices_incoming_edge_count: INTEGER
			-- total number of incoming edges of all vertices in `vertices`
			-- Result = (Σv ∈ vertices : v.incoming_edge_count)
		do
			Result := {NUMERIC_ITERABLE [VERTEX [G]]}.sumf (vertices, agent  (v: VERTEX [G]): INTEGER
				do
					Result := v.incoming_edge_count
				end)
		end

invariant
	empty_consistency:
		vertices.count = 0 implies edges.count = 0
	vertex_count = vertices.count
	vertices.lower = 1
	unique_vertices:
		across 1 |..| vertex_count is i all
		across 1 |..| vertex_count is j all
			i /= j implies vertices [i] /~ vertices [j]
		end end
	consistency_incoming_outgoing:
		across vertices is l_vertex all
			across l_vertex.outgoing is l_edge all
				l_edge.destination.has_incoming_edge (l_edge)
			end
			and
			across l_vertex.incoming is l_edge all
				l_edge.source.has_outgoing_edge (l_edge)
			end
		end
	consistency_incoming_outgoing2:
			-- ∀e ∈ edges:
			--	   ∧ e ∈ e.source.outgoing
			--	   ∧ e ∈ e.destination.incoming
		across edges is l_edge all
			l_edge.source.has_outgoing_edge (l_edge)
			and
			l_edge.destination.has_incoming_edge (l_edge)
		end
	model_consistency_vertex_count:
		model.vertex_count = vertex_count
	model_consistency_edge_count:
		model.edge_count = edge_count
	model_consistency_vertices:
		across model.vertices is l_v all
			has_vertex (l_v)
		end
	model_consistency_edges:
		across model.edges is l_e all
			has_edge ([l_e.first, l_e.second])
		end
	count_property_symmetry_1:
		-- (Σv ∈ vertices : v.outgoing_edge_count + v.incoming_edge_count) = 2 * edge_count
		vertices_edge_count = 2 * edge_count
	count_property_symmetry_2:
		-- (Σv ∈ vertices : v.outgoing_edge_count) = (Σv ∈ vertices : v.incoming_edge_count)
		vertices_outgoing_edge_count = vertices_incoming_edge_count
	self_loops_are_incomng_and_outgoing:
		across vertices is l_vertex all
			across l_vertex.incoming is l_edge some
				l_edge.source ~ l_edge.destination
			end
			=
			across l_vertex.outgoing is l_edge some
				l_edge.source ~ l_edge.destination
			end
		end
end
