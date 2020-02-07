note
	description: "[
		Edge comparator to use Gobo quicksort in implementation of:
			outgoing_sorted: ARRAY[EDGE[G]]
		in VERTEX[G] where we use:
			a_comparator: EDGE_COMPARATOR [G]
			a_sorter: DS_ARRAY_QUICK_SORTER [EDGE[G]]
		An edge e1 < e2 iff  e1.destination.item < e2.destination.item
		]"
	author: "JSO and JW"
	date: "$Date$"
	revision: "$Revision$"

class
	EDGE_COMPARATOR[G -> COMPARABLE]

inherit
	KL_COMPARATOR[EDGE[G]]

create
	default_create

feature
	attached_less_than (e1, e2: attached EDGE[G]): BOOLEAN
			-- effect e1 < e2
		do
			Result := e1.destination.item < e2.destination.item
		end

end
