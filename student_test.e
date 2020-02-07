note
	description: "Summary description for {STUDENT_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TEST

inherit
	ES_TEST

create
	make
feature {NONE} -- Initialization

	make
		do
			add_boolean_case(agent t1)
			add_boolean_case(agent t2)
			add_boolean_case(agent t3)
			add_boolean_case(agent t4)
			add_boolean_case(agent t5)
			add_boolean_case(agent t6)
			add_boolean_case(agent t7)
			add_boolean_case(agent t8)
			add_boolean_case(agent t9)

		end

feature -- Tests
	t1: BOOLEAN
			local
					v1: VERTEX [INTEGER]
				do
					comment ("t1: Create a vertex of type Integer test (+), (-)")
					create v1.make (-1)
					Result := v1.item ~ -1
					check
						Result
					end
					create v1.make (1)
					Result := v1.item ~ 1
					check
						Result
					end
				end

	t2: BOOLEAN
	local
			v1: VERTEX [STRING]
		do
			comment ("t2: Create a vertex of type String")
			create v1.make ("SAAD")
			Result := v1.item ~ "SAAD" and v1.item /~ "saad"
			check
				Result
			end
			create v1.make ("500")
			Result := v1.item ~ "500"
			check
				Result
			end
		end

	t3: BOOLEAN
	local
			v1, v2: VERTEX [INTEGER]
			e1: EDGE [INTEGER]
		do
			comment ("t3: test add_edge for type integer")
			create v1.make (5)
			create v2.make (10)
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1
			check
				Result
			end
		end

	t4: BOOLEAN
	local
			v1, v2, v3, v4: VERTEX [INTEGER]
			e1, e2, e3: EDGE [INTEGER]
		do
			comment("t4: Test outgoing edge count")
			create v1.make (5)
			create v2.make (10)
			create v3.make (15)
			create v4.make (20)
			create e1.make (v1, v2)
			create e2.make (v1, v3)
			create e3.make (v1, v4)
			v1.add_edge (e1)
			v1.add_edge (e2)
			v1.add_edge (e3)
					Result := v1.outgoing.count ~ 3 and v1.incoming.count ~ 0
					check
						Result
					end

		end

	t5: BOOLEAN
	local
			v1, v2, v3, v4: VERTEX [INTEGER]
			e1, e2, e3: EDGE [INTEGER]
		do
			comment("t5: Test incoming edge count")
			create v1.make (5)
			create v2.make (10)
			create v3.make (15)
			create v4.make (20)
			create e1.make (v2, v1)
			create e2.make (v3, v1)
			create e3.make (v4, v1)
			v1.add_edge (e1)
			v1.add_edge (e2)
			v1.add_edge (e3)
			Result := v1.outgoing.count ~ 0 and v1.incoming.count ~ 3
			check
				Result
			end

		end


	t6: BOOLEAN
	local
			v1, v2, v3, v4, v5: VERTEX [INTEGER]
			e1, e2, e3, e4: EDGE [INTEGER]
		do
			comment("t6: Test incoming and outgoing edge count")
			create v1.make (5)
			create v2.make (10)
			create v3.make (15)
			create v4.make (20)
			create v5.make (25)
			create e1.make (v2, v1)
			create e2.make (v3, v1)
			create e3.make (v4, v1)
			create e4.make (v1, v5)
			v1.add_edge (e1)
			v1.add_edge (e2)
			v1.add_edge (e3)
			v1.add_edge (e4)
			Result := (v1.outgoing.count + v1.incoming.count) ~ 4
			check
				Result
			end

		end


	t7: BOOLEAN
	local
			v1, v2, v3, v4, v5: VERTEX [INTEGER]
			e1, e2, e3, e4: EDGE [INTEGER]
		do
			comment("t7: Test has_outgoing_edge function to test if vertex indeed has edge in outgoing list")
			create v1.make (5)
			create v2.make (10)
			create v3.make (15)
			create v4.make (20)
			create v5.make (25)
			create e1.make (v2, v1)
			create e2.make (v3, v1)
			create e3.make (v4, v1)
			create e4.make (v1, v5)
			v1.add_edge (e1)
			v1.add_edge (e2)
			v1.add_edge (e3)
			v1.add_edge (e4)
			Result := v1.has_outgoing_edge (e4)
			check
				Result
			end

		end

	t8: BOOLEAN
	local
			v1, v2, v3, v4, v5: VERTEX [INTEGER]
			e1, e2, e3, e4: EDGE [INTEGER]
		do
			comment("t8: Test has_incoming_edge function to test if vertex indeed has edge in incoming list")
			create v1.make (5)
			create v2.make (10)
			create v3.make (15)
			create v4.make (20)
			create v5.make (25)
			create e1.make (v2, v1)
			create e2.make (v3, v1)
			create e3.make (v4, v1)
			create e4.make (v1, v5)
			v1.add_edge (e1)
			v1.add_edge (e2)
			v1.add_edge (e3)
			v1.add_edge (e4)
			Result := v1.has_incoming_edge (e2)
			check
				Result
			end

		end

	t9: BOOLEAN
	local
			v1, v2, v3, v4, v5: VERTEX [INTEGER]
			e1, e2, e3, e4: EDGE [INTEGER]
			sorted_edges: ARRAY [EDGE [INTEGER]]
			sorted_edges_string: STRING
		do
			comment("t9: Test outgoing_sorted function in vertex class for outputting sorted array of outgoing edges")
			create v1.make (5)
			create v2.make (10)
			create v3.make (15)
			create v4.make (20)
			create v5.make (25)
			create e1.make (v1, v2)
			create e2.make (v1, v3)
			create e3.make (v1, v4)
			create e4.make (v5, v1)
			v1.add_edge (e1)
			v1.add_edge (e2)
			v1.add_edge (e3)
			v1.add_edge (e4)
			sorted_edges := v1.outgoing_sorted
			Result := sorted_edges.count ~ 3
			check
				Result
			end
			create sorted_edges_string.make_empty
			across
				sorted_edges as curr_edge
			loop
				sorted_edges_string.append (curr_edge.item.destination.out)
				sorted_edges_string.append (" ")
			end
			assert_equal ("outgoing_sorted_correct", "5:10,15,20", v1.out)


		end

	t26: BOOLEAN -- topologically_sorted Basic
			local
				i_g: LIST_GRAPH[INTEGER]
				i_a: ARRAY[TUPLE[INTEGER, INTEGER]]
			do
				comment ("t26: Advanced Queries - topologically_sorted - Basic")
				i_a := << [1, 2], [1, 3], [2, 5], [2, 4], [2, 6], [6, 7] >>
				i_a.compare_objects
				create i_g.make_from_array (i_a)
				assert_equal ("correct vertices & edges", "[1:2,3][2:4,5,6][6:7]", i_g.out)
				Result := i_g.edge_count ~ 6 and i_g.vertex_count ~ 7
				check Result end

				Result := i_g.is_topologically_sorted (i_g.topologically_sorted)
				check Result end
			end
end
