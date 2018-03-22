history clear
project -load sha256_core_syn.prj
project -run synthesis -clean 
project -run constraint_check 
text_select 5 8 5 18
set_option -top_module sha256_spi
set_option -frequency 100.000000
project -run synthesis -clean 
set_option -num_startend_points 5
set_option -reporting_margin -1.0
set_option -reporting_filename sha256_core_syn.ta
set_option -reporting_output_srm 0
set_option -reporting_filter "-from {i_clk}"
set_option -reporting_margin -1.0
project -run timing 
project -close C:/workspace/sha256-core/work/lattice/sha256_core/sha256_core_syn.prj
