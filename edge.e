note
	description: "[
		An Edge has a source and destination vertex:
			source: VERTEX [G]
			destination: VERTEX [G]
		An edge can be created from two vertices 
		or from a tuple (see convert).
		]"
	author: "JSO and JW"
	date: "$Date$"
	revision: "$Revision$"

class
	EDGE [G -> COMPARABLE]
inherit
	ANY
		redefine is_equal, out end

	DEBUG_OUTPUT
		redefine is_equal, out end

create
	make, make_from_tuple

convert
	make_from_tuple ({TUPLE [VERTEX [G], VERTEX [G]]})

feature {NONE}  -- creation

	make (v1, v2: like source)
			-- creates an edge with source `v1` and destination `v2`
		do
			source := v1
			destination := v2
		end

	make_from_tuple (a_tuple: like as_tuple)
			-- creates an edge from `a_tuple`
			-- see `as_tuple` to see what fields you can access on `a_tuple`
		do
			source := a_tuple.source
			destination := a_tuple.destination
		end

feature -- basic queries

	source: VERTEX [G]
		-- soure of edge

	destination: VERTEX [G]
		-- destination of edge

feature -- derived queries

	reverse_edge: like Current
			-- returns a new edge like the current one,
			-- except the source and destination are reversed.
		do
			Result := [destination, source]
		ensure
			destination ~ Result.source
			source ~ Result.destination
		end

	as_tuple: TUPLE [source: VERTEX [G]; destination: VERTEX [G]]
			-- returns the current edge as a tuple
			-- such that Result.source is `Current.source` and Result.destination is `Current.destination`
		do
			Result := [source, destination]
		end

	is_self_loop: BOOLEAN
			-- is the current edge a self loop (an edge going back to the same vertex)?
		do
			Result := source ~ destination
		end

	is_equal(other: like Current): BOOLEAN
			-- Is `other` edge equal to the current edge?
			-- Two edges are equal if they have the same source and destination.
		do
			Result :=
				source ~ other.source
				and
				destination ~ other.destination
		end

feature

	out: STRING
			-- returns a string representation of current edge
		do
			Result := source.out + "," + destination.item.out
		end

	debug_output: STRING
			-- returns a string representation of current edge
			-- in the debugger
		do
			Result := destination.item.out
		end

end
