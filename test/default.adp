comp_opt= -gnatf -gnato -gnatE -funwind-tables
bind_opt=-f -p -E
gnatmake_opt=-g -i 
run_cmd=${main} -v
debug_cmd=gvd ${main}
main=./timed_harness
main_unit=timed_harness
build_dir=./
casing=~/.emacs_case_exceptions/
src_dir=./
src_dir=../aunit/framework/
src_dir=../aunit/text_reporter/
obj_dir=./
obj_dir=../aunit/framework/
obj_dir=../aunit/text_reporter/