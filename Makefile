
NAME = simple_router
DEPS = simple_router primitives

P4_BM_DIR = ../p4-bm

P4C_BMV2 = p4c-bmv2


DFLAGS = -DHAVE_CONFIG_H -DBMLOG_DEBUG_ON -DBMLOG_TRACE_ON -DBMLOG_ON
CXXFLAGS += -g -O2 -std=c++11
CXX = g++
LIBTOOL = libtool
LIBTOOLFLAGS = --tag=CXX --mode=link


INCLUDES = /targets /modules/bf_lpm_trie/include /third_party/jsoncpp/include /modules/BMI/include \
		   /modules/bm_sim/include /modules/bm_runtime/include
INCLUDES_FULL = $(addprefix -I$(P4_BM_DIR), $(INCLUDES))

SYS_INCLUDES = /third_party/jsoncppp/include /third_party/spdlog/include
SYS_INCLUDES_FULL = $(addprefix -isystem$(P4_BM_DIR), $(SYS_INCLUDES))

BM_LINKS = /modules/bm_runtime/libbmruntime.la /modules/bm_sim/libbmsim.la /modules/bf_lpm_trie/libbflpmtrie.la \
		   /thrift_src/libruntimestubs.la /modules/BMI/libbmi.la /third_party/jsoncpp/libjson.la
BM_LINKS_FULL = $(addprefix $(P4_BM_DIR), $(BM_LINKS))

LIB_LINKS = boost_system boost_thread thrift boost_program_options pcap nanomsg gmp Judy
LIB_LINKS_FULL = $(addprefix -l, $(LIB_LINKS))

all: $(NAME) p4 ln_cli

p4: $(NAME).json

$(NAME): $(addsuffix .o, $(DEPS))
	$(LIBTOOL) $(LIBTOOLFLAGS) $(CXX) $(CXXFLAGS) -pthread -o $@ $+ $(BM_LINKS_FULL) $(LIB_LINKS_FULL)

%.o: %.cpp
	$(CXX) -I. -I$(P4_BM_DIR) $(DFLAGS) $(INCLUDES_FULL) $(SYS_INCLUDES_FULL) $(CXXFLAGS) -c -o $@ $<

$(NAME).json: $(NAME).p4
	$(P4C_BMV2) --json $@ $<

ln_cli:
	ln -s $(P4_BM_DIR)/tools/runtime_CLI.py runtime_CLI.py

clean:
	$(RM) *.o

spotless: clean
	$(RM) $(NAME)
	$(RM) *.pyc
	$(RM) runtime_CLI.py

.PHONY: clean spotless p4 all ln_cli
