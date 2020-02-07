note
	description: "ROOT class for project"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT
inherit
	ES_SUITE  -- testing via ESpec
create
	make

feature {NONE} -- Initialization

	make
			-- Run tests
		do

			add_test (create {STUDENT_TEST}.make)
			add_test (create {TEST_LIST_GRAPH_INSTRUCTOR}.make)
			add_test (create {TEST_VERTEX_INSTRUCTOR}.make)
--			show_errors
			show_browser
			run_espec
		end
end
